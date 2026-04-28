#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"

JAR_REL_PATH="infoq-scaffold-backend/infoq-admin/target/infoq-admin.jar"
HOST="${CLUSTER_SMOKE_HOST:-127.0.0.1}"
PORT_A="${CLUSTER_SMOKE_PORT_A:-19081}"
PORT_B="${CLUSTER_SMOKE_PORT_B:-19082}"
SPRING_PROFILE="${CLUSTER_SMOKE_SPRING_PROFILES_ACTIVE:-local}"
NODE_ID_A="${CLUSTER_SMOKE_NODE_ID_A:-node-a}"
NODE_ID_B="${CLUSTER_SMOKE_NODE_ID_B:-node-b}"
CLIENT_ID="${CLUSTER_SMOKE_CLIENT_ID:-e5cd7e4891bf95d1d19206ce24a7b32e}"
USERNAME="${CLUSTER_SMOKE_USERNAME:-}"
PASSWORD="${CLUSTER_SMOKE_PASSWORD:-}"
LOGIN_CANDIDATES="${CLUSTER_SMOKE_LOGIN_CANDIDATES:-dept:666666,owner:666666,admin:123456}"
RSA_PUBLIC_KEY="${CLUSTER_SMOKE_RSA_PUBLIC_KEY:-MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAKoR8mX0rGKLqzcWmOzbfj64K8ZIgOdHnzkXSOVOZbFu/TJhZ7rFAN+eaGkl3C4buccQd/EjEsj9ir7ijT7h96MCAwEAAQ==}"
REDIS_HOST="${CLUSTER_SMOKE_REDIS_HOST:-8.134.159.245}"
REDIS_PORT="${CLUSTER_SMOKE_REDIS_PORT:-36379}"
REDIS_DB="${CLUSTER_SMOKE_REDIS_DB:-15}"
REDIS_PASSWORD="${CLUSTER_SMOKE_REDIS_PASSWORD:-6SEKKLDifbw2fCFB}"
WEBSOCKET_PATH="${CLUSTER_SMOKE_WEBSOCKET_PATH:-/resource/websocket}"
USER_SETTLE_SECONDS="${CLUSTER_SMOKE_USER_SETTLE_SECONDS:-1.5}"
USER_CLEAR_TIMEOUT_SECONDS="${CLUSTER_SMOKE_USER_CLEAR_TIMEOUT_SECONDS:-15}"
CLEANUP_TIMEOUT_SECONDS="${CLUSTER_SMOKE_CLEANUP_TIMEOUT_SECONDS:-140}"

BUILD_FIRST=0
KEEP_SERVERS=0
SKIP_ABNORMAL_EXIT=0
SERVER_A_PID=""
SERVER_B_PID=""
LOG_A=""
LOG_B=""

usage() {
  cat <<'EOF'
Usage: run_cluster_smoke.sh [options]

Options:
  --build                    Build backend jar before cluster smoke testing.
  --keep-servers             Keep surviving backend process alive after checks.
  --skip-abnormal-exit       Skip the kill -9 stale-registration cleanup phase.
  --host <host>              Server host (default: 127.0.0.1).
  --port-a <port>            Node A port (default: 19081).
  --port-b <port>            Node B port (default: 19082).
  --profile <name>           Spring profile (default: local).
  --node-id-a <id>           Node A websocket node id (default: node-a).
  --node-id-b <id>           Node B websocket node id (default: node-b).
  --client-id <id>           Client ID for login.
  --username <name>          Preferred login username.
  --password <pwd>           Preferred login password.
  --login-candidates <list>  Comma list like "dept:666666,owner:666666".
  --redis-host <host>        Redis host used by application-local.yml.
  --redis-port <port>        Redis port used by application-local.yml.
  --redis-db <db>            Redis db used by application-local.yml.
  --redis-password <pwd>     Redis password used by application-local.yml.
  --jar <path>               Jar path relative to repo root.
  -h, --help                 Show this help.
EOF
}

port_pid() {
  local port="$1"
  lsof -t -nP -iTCP:"${port}" -sTCP:LISTEN 2>/dev/null | head -n 1 || true
}

is_server_ready() {
  local base_url="$1"
  local health_code=""
  health_code="$(curl -s -o /dev/null -w '%{http_code}' "${base_url}/actuator/health" || true)"
  if [[ "${health_code}" == "200" || "${health_code}" == "401" ]]; then
    return 0
  fi

  local code_resp=""
  code_resp="$(curl -s -o /dev/null -w '%{http_code}' "${base_url}/auth/code" || true)"
  if [[ "${code_resp}" == "200" ]]; then
    return 0
  fi

  local root_code=""
  root_code="$(curl -s -o /dev/null -w '%{http_code}' "${base_url}/" || true)"
  [[ "${root_code}" == "200" ]]
}

cleanup() {
  if [[ -n "${SERVER_A_PID}" && "${KEEP_SERVERS}" -eq 0 ]] && kill -0 "${SERVER_A_PID}" >/dev/null 2>&1; then
    kill "${SERVER_A_PID}" >/dev/null 2>&1 || true
    wait "${SERVER_A_PID}" >/dev/null 2>&1 || true
  fi
  if [[ -n "${SERVER_B_PID}" && "${KEEP_SERVERS}" -eq 0 ]] && kill -0 "${SERVER_B_PID}" >/dev/null 2>&1; then
    kill "${SERVER_B_PID}" >/dev/null 2>&1 || true
    wait "${SERVER_B_PID}" >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build)
      BUILD_FIRST=1
      shift
      ;;
    --keep-servers)
      KEEP_SERVERS=1
      shift
      ;;
    --skip-abnormal-exit)
      SKIP_ABNORMAL_EXIT=1
      shift
      ;;
    --host)
      HOST="$2"
      shift 2
      ;;
    --port-a)
      PORT_A="$2"
      shift 2
      ;;
    --port-b)
      PORT_B="$2"
      shift 2
      ;;
    --profile)
      SPRING_PROFILE="$2"
      shift 2
      ;;
    --node-id-a)
      NODE_ID_A="$2"
      shift 2
      ;;
    --node-id-b)
      NODE_ID_B="$2"
      shift 2
      ;;
    --client-id)
      CLIENT_ID="$2"
      shift 2
      ;;
    --username)
      USERNAME="$2"
      shift 2
      ;;
    --password)
      PASSWORD="$2"
      shift 2
      ;;
    --login-candidates)
      LOGIN_CANDIDATES="$2"
      shift 2
      ;;
    --redis-host)
      REDIS_HOST="$2"
      shift 2
      ;;
    --redis-port)
      REDIS_PORT="$2"
      shift 2
      ;;
    --redis-db)
      REDIS_DB="$2"
      shift 2
      ;;
    --redis-password)
      REDIS_PASSWORD="$2"
      shift 2
      ;;
    --jar)
      JAR_REL_PATH="$2"
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

if ! command -v node >/dev/null 2>&1; then
  echo "node is required but not found in PATH" >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but not found in PATH" >&2
  exit 1
fi

for port in "${PORT_A}" "${PORT_B}"; do
  pid="$(port_pid "${port}")"
  if [[ -n "${pid}" ]]; then
    echo "[cluster-smoke] port ${port} already occupied by pid=${pid}" >&2
    exit 1
  fi
done

JAR_PATH="${REPO_ROOT}/${JAR_REL_PATH}"
if [[ "${BUILD_FIRST}" -eq 1 || ! -f "${JAR_PATH}" ]]; then
  echo "[cluster-smoke] building backend jar..."
  (
    cd "${REPO_ROOT}/infoq-scaffold-backend"
    mvn -pl infoq-admin -am -DskipTests package
  )
fi

if [[ ! -f "${JAR_PATH}" ]]; then
  echo "[cluster-smoke] jar not found: ${JAR_PATH}" >&2
  exit 1
fi

start_node() {
  local port="$1"
  local node_id="$2"
  local log_file="$3"
  local pid_var="$4"
  local pid=""

  echo "[cluster-smoke] starting ${node_id} on http://${HOST}:${port}"
  pid="$(
    python3 - "${log_file}" "${SPRING_PROFILE}" "${JAR_PATH}" "${port}" "${node_id}" <<'PY'
import os
import subprocess
import sys

log_path, spring_profile, jar_path, port, node_id = sys.argv[1:6]
env = os.environ.copy()
env["SPRING_PROFILES_ACTIVE"] = spring_profile
cmd = [
    "java",
    "-jar",
    jar_path,
    f"--server.port={port}",
    "--captcha.enable=false",
    "--websocket.enabled=true",
    f"--websocket.node-id={node_id}",
    "--infoq.quartz.bootstrap.reconcile-enabled=false",
]
with open(log_path, "ab", buffering=0) as stream:
    proc = subprocess.Popen(
        cmd,
        stdin=subprocess.DEVNULL,
        stdout=stream,
        stderr=subprocess.STDOUT,
        env=env,
        start_new_session=True,
    )
print(proc.pid)
PY
  )"
  printf -v "${pid_var}" '%s' "${pid}"
}

wait_node() {
  local base_url="$1"
  local log_file="$2"

  for _ in $(seq 1 90); do
    if is_server_ready "${base_url}"; then
      return 0
    fi
    sleep 1
  done

  echo "[cluster-smoke] server failed to become ready: ${base_url}" >&2
  sed -n '1,220p' "${log_file}" >&2 || true
  return 1
}

timestamp="$(date +%s)"
LOG_A="/tmp/infoq-cluster-smoke-${NODE_ID_A}-${timestamp}.log"
LOG_B="/tmp/infoq-cluster-smoke-${NODE_ID_B}-${timestamp}.log"

start_node "${PORT_A}" "${NODE_ID_A}" "${LOG_A}" SERVER_A_PID
start_node "${PORT_B}" "${NODE_ID_B}" "${LOG_B}" SERVER_B_PID

wait_node "http://${HOST}:${PORT_A}" "${LOG_A}"
wait_node "http://${HOST}:${PORT_B}" "${LOG_B}"

echo "[cluster-smoke] both nodes are ready, running node-a HTTP smoke and encrypted login..."
SMOKE_OUTPUT="$(
  BASE_URL="http://${HOST}:${PORT_A}" \
  CLIENT_ID="${CLIENT_ID}" \
  USERNAME="${USERNAME}" \
  PASSWORD="${PASSWORD}" \
  LOGIN_CANDIDATES="${LOGIN_CANDIDATES}" \
  RSA_PUBLIC_KEY="${RSA_PUBLIC_KEY}" \
  PRINT_TOKEN=1 \
  PRINT_USER_ID=1 \
  node "${SCRIPT_DIR}/smoke_checks.mjs"
)"
printf '%s\n' "${SMOKE_OUTPUT}"

TOKEN="$(printf '%s\n' "${SMOKE_OUTPUT}" | sed -n 's/^TOKEN=//p' | tail -n 1)"
USER_ID="$(printf '%s\n' "${SMOKE_OUTPUT}" | sed -n 's/^USER_ID=//p' | tail -n 1)"

if [[ -z "${TOKEN}" || -z "${USER_ID}" ]]; then
  echo "[cluster-smoke] failed to extract TOKEN/USER_ID from smoke output" >&2
  exit 1
fi

echo "[cluster-smoke] running websocket cluster verification..."
CLUSTER_SMOKE_TOKEN="${TOKEN}" \
CLUSTER_SMOKE_USER_ID="${USER_ID}" \
CLUSTER_SMOKE_CLIENT_ID="${CLIENT_ID}" \
CLUSTER_SMOKE_REDIS_HOST="${REDIS_HOST}" \
CLUSTER_SMOKE_REDIS_PORT="${REDIS_PORT}" \
CLUSTER_SMOKE_REDIS_DB="${REDIS_DB}" \
CLUSTER_SMOKE_REDIS_PASSWORD="${REDIS_PASSWORD}" \
python3 "${SCRIPT_DIR}/websocket_cluster_smoke.py" \
  --host "${HOST}" \
  --port-a "${PORT_A}" \
  --port-b "${PORT_B}" \
  --node-id-a "${NODE_ID_A}" \
  --node-id-b "${NODE_ID_B}" \
  --websocket-path "${WEBSOCKET_PATH}" \
  --server-b-pid "${SERVER_B_PID}" \
  --user-settle-seconds "${USER_SETTLE_SECONDS}" \
  --user-clear-timeout-seconds "${USER_CLEAR_TIMEOUT_SECONDS}" \
  --cleanup-timeout-seconds "${CLEANUP_TIMEOUT_SECONDS}" \
  $( [[ "${SKIP_ABNORMAL_EXIT}" -eq 1 ]] && printf '%s' '--skip-abnormal-exit' )

if [[ "${SKIP_ABNORMAL_EXIT}" -eq 0 ]]; then
  wait "${SERVER_B_PID}" >/dev/null 2>&1 || true
  SERVER_B_PID=""
fi

if grep -q "ClassCastException" "${LOG_A}" "${LOG_B}"; then
  echo "[cluster-smoke] detected ClassCastException in node logs" >&2
  exit 1
fi

if [[ "${SKIP_ABNORMAL_EXIT}" -eq 0 ]]; then
  if ! grep -q "清理WebSocket节点用户注册, nodeId=${NODE_ID_B}" "${LOG_A}"; then
    echo "[cluster-smoke] node-a log missing stale-node cleanup evidence for ${NODE_ID_B}" >&2
    exit 1
  fi
fi

echo "[cluster-smoke] cluster smoke passed."
echo "[cluster-smoke] node-a log: ${LOG_A}"
echo "[cluster-smoke] node-b log: ${LOG_B}"
if [[ "${KEEP_SERVERS}" -eq 1 ]]; then
  survivors=()
  if [[ -n "${SERVER_A_PID}" ]] && kill -0 "${SERVER_A_PID}" >/dev/null 2>&1; then
    survivors+=("${SERVER_A_PID}")
  fi
  if [[ -n "${SERVER_B_PID}" ]] && kill -0 "${SERVER_B_PID}" >/dev/null 2>&1; then
    survivors+=("${SERVER_B_PID}")
  fi
  echo "[cluster-smoke] keep-servers enabled; surviving pids: ${survivors[*]:-none}"
fi
