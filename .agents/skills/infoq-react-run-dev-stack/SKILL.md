---
name: infoq-react-run-dev-stack
description: Start, restart, and stop this repository's local backend plus React dev stack with health checks and logs. Use when users ask to 启动 React 前端, 启动 React 联调, 启动后端加 React, restart React stack, or stop the React local stack. If the task targets Vue instead, use infoq-vue-run-dev-stack.
---

# Infoq React Run Dev Stack

Use this skill when local verification targets `infoq-scaffold-frontend-react`.
This skill exposes the React-focused entrypoints; shared implementation lives under `.agents/skills/infoq-run-dev-stack/`.

## Execute

Start backend + React frontend:

```bash
bash .agents/skills/infoq-react-run-dev-stack/scripts/start_react_dev_stack.sh
```

Common variants:

```bash
# Build backend jar first, then start backend + React
bash .agents/skills/infoq-react-run-dev-stack/scripts/start_react_dev_stack.sh --build-backend

# Start React frontend only
bash .agents/skills/infoq-react-run-dev-stack/scripts/start_react_dev_stack.sh --frontend-only --react-port 5174

# Stop services started for local stack verification
bash .agents/skills/infoq-react-run-dev-stack/scripts/stop_react_dev_stack.sh
```

## Defaults

- Backend port: `8080`
- React dev host: `127.0.0.1`
- React dev port: `5174`
- Package manager: prefer `pnpm`; fallback to `npm` only when `pnpm` is unavailable

## Notes

- This skill is React-only by design.
- If both frontends must run, invoke both paired stack skills explicitly or use the shared helper entrypoints directly.
