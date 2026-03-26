#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../.." && pwd)"

exec bash "${REPO_ROOT}/.agents/skills/infoq-browser-automation/scripts/print_login_inject_snippet.sh" "$@"
