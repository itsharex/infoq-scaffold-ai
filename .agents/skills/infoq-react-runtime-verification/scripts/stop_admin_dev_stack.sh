#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="/tmp/infoq-react-runtime-verification.state"

if [[ ! -f "${STATE_FILE}" ]]; then
  echo "[react-runtime] no state file found: ${STATE_FILE}"
  exit 0
fi

# shellcheck source=/dev/null
source "${STATE_FILE}"

stop_one() {
  local name="$1"
  local pid="$2"
  if [[ -z "${pid}" ]]; then
    echo "[react-runtime] ${name}: no pid recorded"
    return
  fi
  if kill -0 "${pid}" >/dev/null 2>&1; then
    kill "${pid}" >/dev/null 2>&1 || true
    sleep 1
    if kill -0 "${pid}" >/dev/null 2>&1; then
      kill -9 "${pid}" >/dev/null 2>&1 || true
    fi
    echo "[react-runtime] ${name} stopped (pid=${pid})"
  else
    echo "[react-runtime] ${name} already stopped (pid=${pid})"
  fi
}

stop_one "backend" "${STARTED_BACKEND_PID:-}"
stop_one "React admin" "${STARTED_FRONTEND_PID:-}"
rm -f "${STATE_FILE}"
echo "[react-runtime] removed state file: ${STATE_FILE}"
