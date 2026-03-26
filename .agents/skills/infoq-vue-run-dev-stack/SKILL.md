---
name: infoq-vue-run-dev-stack
description: Start, restart, and stop this repository's local backend plus Vue dev stack with health checks and logs. Use when users ask to 启动 Vue 前端, 启动 Vue 联调, 启动后端加 Vue, restart Vue stack, or stop the Vue local stack. If the task targets React instead, use infoq-react-run-dev-stack.
---

# Infoq Vue Run Dev Stack

Use this skill when local verification targets `infoq-scaffold-frontend-vue`.
This skill exposes the Vue-focused entrypoints; shared implementation lives under `.agents/skills/infoq-run-dev-stack/`.

## Execute

Start backend + Vue frontend:

```bash
bash .agents/skills/infoq-vue-run-dev-stack/scripts/start_vue_dev_stack.sh
```

Common variants:

```bash
# Build backend jar first, then start backend + Vue
bash .agents/skills/infoq-vue-run-dev-stack/scripts/start_vue_dev_stack.sh --build-backend

# Start Vue frontend only
bash .agents/skills/infoq-vue-run-dev-stack/scripts/start_vue_dev_stack.sh --frontend-only --vue-port 5173

# Stop services started for local stack verification
bash .agents/skills/infoq-vue-run-dev-stack/scripts/stop_vue_dev_stack.sh
```

## Defaults

- Backend port: `8080`
- Vue dev host: `127.0.0.1`
- Vue dev port: `5173`
- Package manager: prefer `pnpm`; fallback to `npm` only when `pnpm` is unavailable

## Notes

- This skill is Vue-only by design.
- If both frontends must run, invoke both paired stack skills explicitly or use the shared helper entrypoints directly.
