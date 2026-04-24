#!/usr/bin/env bash
set -euo pipefail

STATE_FILE="/tmp/infoq-vue-runtime-verification.state"

if [[ ! -f "${STATE_FILE}" ]]; then
  echo "[vue-runtime] no state file found: ${STATE_FILE}"
  exit 0
fi

# shellcheck source=/dev/null
source "${STATE_FILE}"

stop_one() {
  local name="$1"
  local pid="$2"
  if [[ -z "${pid}" ]]; then
    echo "[vue-runtime] ${name}: no pid recorded"
    return
  fi
  if kill -0 "${pid}" >/dev/null 2>&1; then
    kill "${pid}" >/dev/null 2>&1 || true
    sleep 1
    if kill -0 "${pid}" >/dev/null 2>&1; then
      kill -9 "${pid}" >/dev/null 2>&1 || true
    fi
    echo "[vue-runtime] ${name} stopped (pid=${pid})"
  else
    echo "[vue-runtime] ${name} already stopped (pid=${pid})"
  fi
}

stop_one "backend" "${STARTED_BACKEND_PID:-}"
stop_one "Vue admin" "${STARTED_FRONTEND_PID:-}"
rm -f "${STATE_FILE}"
echo "[vue-runtime] removed state file: ${STATE_FILE}"
