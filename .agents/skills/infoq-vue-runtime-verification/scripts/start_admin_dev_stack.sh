#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"

BACKEND_DIR="${REPO_ROOT}/infoq-scaffold-backend"
FRONTEND_DIR="${REPO_ROOT}/infoq-scaffold-frontend-vue"
BACKEND_JAR="${BACKEND_DIR}/infoq-admin/target/infoq-admin.jar"

BACKEND_PORT="${BACKEND_PORT:-8080}"
FRONTEND_HOST="${FRONTEND_HOST:-127.0.0.1}"
FRONTEND_PORT="${VUE_PORT:-5173}"
PROFILE="${PROFILE:-dev}"
WAIT_SECONDS="${WAIT_SECONDS:-90}"

BUILD_BACKEND=0
FORCE_RESTART=0
BACKEND_ONLY=0
FRONTEND_ONLY=0

STATE_FILE="/tmp/infoq-vue-runtime-verification.state"
LOG_DIR="/tmp/infoq-vue-runtime-verification"
mkdir -p "${LOG_DIR}"
BACKEND_LOG="${LOG_DIR}/backend-${BACKEND_PORT}.log"
FRONTEND_LOG="${LOG_DIR}/frontend-vue-${FRONTEND_PORT}.log"

STARTED_BACKEND_PID=""
STARTED_FRONTEND_PID=""

usage() {
  cat <<'USAGE'
Usage: start_admin_dev_stack.sh [options]

Options:
  --build-backend        Build backend jar before startup.
  --force-restart        Restart service if target port is already in use.
  --backend-only         Start backend only.
  --frontend-only        Start frontend only.
  --backend-port <port>  Backend HTTP port. Default: 8080.
  --vue-port <port>      Vue dev port. Default: 5173.
  --frontend-host <host> Frontend host. Default: 127.0.0.1.
  --profile <name>       Spring profile. Default: dev.
  -h, --help             Show help.
USAGE
}

port_pid() {
  local port="$1"
  lsof -t -nP -iTCP:"${port}" -sTCP:LISTEN 2>/dev/null | head -n 1 || true
}

wait_http() {
  local url="$1"
  local max_wait="$2"
  local i
  for i in $(seq 1 "${max_wait}"); do
    if curl -fsS "${url}" >/dev/null 2>&1; then
      return 0
    fi
    sleep 1
  done
  return 1
}

kill_pid_if_running() {
  local pid="$1"
  if [[ -n "${pid}" ]] && kill -0 "${pid}" >/dev/null 2>&1; then
    kill "${pid}" >/dev/null 2>&1 || true
    sleep 1
  fi
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build-backend)
      BUILD_BACKEND=1
      shift
      ;;
    --force-restart)
      FORCE_RESTART=1
      shift
      ;;
    --backend-only)
      BACKEND_ONLY=1
      shift
      ;;
    --frontend-only)
      FRONTEND_ONLY=1
      shift
      ;;
    --backend-port)
      BACKEND_PORT="$2"
      shift 2
      ;;
    --vue-port)
      FRONTEND_PORT="$2"
      shift 2
      ;;
    --frontend-host)
      FRONTEND_HOST="$2"
      shift 2
      ;;
    --profile)
      PROFILE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ "${BACKEND_ONLY}" -eq 1 && "${FRONTEND_ONLY}" -eq 1 ]]; then
  echo "--backend-only and --frontend-only cannot be used together." >&2
  exit 1
fi

if [[ ! -d "${BACKEND_DIR}" || ! -d "${FRONTEND_DIR}" ]]; then
  echo "Repository layout not found under ${REPO_ROOT}" >&2
  exit 1
fi

if [[ "${FRONTEND_ONLY}" -ne 1 ]]; then
  BACKEND_PID="$(port_pid "${BACKEND_PORT}")"
  if [[ -n "${BACKEND_PID}" && "${FORCE_RESTART}" -eq 1 ]]; then
    echo "[vue-runtime] restarting backend on port ${BACKEND_PORT} (pid=${BACKEND_PID})"
    kill_pid_if_running "${BACKEND_PID}"
    BACKEND_PID=""
  fi

  if [[ "${BUILD_BACKEND}" -eq 1 || ! -f "${BACKEND_JAR}" ]]; then
    echo "[vue-runtime] building backend jar..."
    (
      cd "${BACKEND_DIR}"
      mvn -pl infoq-admin -am -DskipTests package
    )
  fi

  if [[ ! -f "${BACKEND_JAR}" ]]; then
    echo "[vue-runtime] backend jar not found: ${BACKEND_JAR}" >&2
    exit 1
  fi

  if [[ -z "${BACKEND_PID}" ]]; then
    echo "[vue-runtime] starting backend on :${BACKEND_PORT}"
    nohup java -jar "${BACKEND_JAR}" --spring.profiles.active="${PROFILE}" --server.port="${BACKEND_PORT}" >"${BACKEND_LOG}" 2>&1 &
    STARTED_BACKEND_PID="$!"
    if ! wait_http "http://127.0.0.1:${BACKEND_PORT}/auth/code" "${WAIT_SECONDS}"; then
      echo "[vue-runtime] backend failed to become ready. log=${BACKEND_LOG}" >&2
      tail -n 120 "${BACKEND_LOG}" >&2 || true
      exit 1
    fi
    echo "[vue-runtime] backend ready: http://127.0.0.1:${BACKEND_PORT}/auth/code (pid=${STARTED_BACKEND_PID})"
  else
    echo "[vue-runtime] backend already running on :${BACKEND_PORT} (pid=${BACKEND_PID})"
  fi
fi

if [[ "${BACKEND_ONLY}" -ne 1 ]]; then
  FRONTEND_PID="$(port_pid "${FRONTEND_PORT}")"
  if [[ -n "${FRONTEND_PID}" && "${FORCE_RESTART}" -eq 1 ]]; then
    echo "[vue-runtime] restarting Vue admin on port ${FRONTEND_PORT} (pid=${FRONTEND_PID})"
    kill_pid_if_running "${FRONTEND_PID}"
    FRONTEND_PID=""
  fi

  if [[ -n "${FRONTEND_PID}" ]]; then
    echo "[vue-runtime] Vue admin already running on :${FRONTEND_PORT} (pid=${FRONTEND_PID})"
  else
    echo "[vue-runtime] starting Vue admin on ${FRONTEND_HOST}:${FRONTEND_PORT}"
    if command -v pnpm >/dev/null 2>&1; then
      FRONT_CMD="pnpm run dev -- --host ${FRONTEND_HOST} --port ${FRONTEND_PORT} --open false --strictPort"
    else
      FRONT_CMD="npm run dev -- --host ${FRONTEND_HOST} --port ${FRONTEND_PORT} --open false --strictPort"
    fi

    (
      cd "${FRONTEND_DIR}"
      nohup bash -lc "${FRONT_CMD}" >"${FRONTEND_LOG}" 2>&1 &
      echo $! > "${LOG_DIR}/frontend.pid.tmp"
    )

    STARTED_FRONTEND_PID="$(cat "${LOG_DIR}/frontend.pid.tmp")"
    rm -f "${LOG_DIR}/frontend.pid.tmp"

    if ! wait_http "http://${FRONTEND_HOST}:${FRONTEND_PORT}/" "${WAIT_SECONDS}"; then
      echo "[vue-runtime] Vue admin failed to become ready. log=${FRONTEND_LOG}" >&2
      tail -n 120 "${FRONTEND_LOG}" >&2 || true
      exit 1
    fi

    echo "[vue-runtime] Vue admin ready: http://${FRONTEND_HOST}:${FRONTEND_PORT}/ (pid=${STARTED_FRONTEND_PID})"
  fi
fi

cat > "${STATE_FILE}" <<STATE
STARTED_BACKEND_PID=${STARTED_BACKEND_PID}
STARTED_FRONTEND_PID=${STARTED_FRONTEND_PID}
BACKEND_PORT=${BACKEND_PORT}
FRONTEND_HOST=${FRONTEND_HOST}
FRONTEND_PORT=${FRONTEND_PORT}
BACKEND_LOG=${BACKEND_LOG}
FRONTEND_LOG=${FRONTEND_LOG}
STATE

echo "[vue-runtime] state file: ${STATE_FILE}"
echo "[vue-runtime] backend log: ${BACKEND_LOG}"
if [[ "${BACKEND_ONLY}" -ne 1 ]]; then
  echo "[vue-runtime] frontend log: ${FRONTEND_LOG}"
fi
