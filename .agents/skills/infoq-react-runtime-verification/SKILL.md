---
name: infoq-react-runtime-verification
description: Run repository-specific runtime verification for the React family in this project, covering `infoq-scaffold-frontend-react` admin and `infoq-scaffold-frontend-weapp-react` mini-program flows. Use when users ask for React login checks, route checks, local stack startup or restart, screenshots, console diagnostics, or React weapp smoke/e2e verification. Choose `admin` vs `weapp` through this skill's client-specific references and scripts. Prefer `infoq-browser-automation` for generic non-repository browser work.
---

# InfoQ React Runtime Verification

This skill owns one job only: runtime verification for the React family in this repository.
It requires the local backend plus the relevant React client runtime. Admin verification relies on browser automation; mini-program verification relies on WeChat DevTools and the workspace `build-open` scripts.
It covers two clients:

- `admin`: `infoq-scaffold-frontend-react`
- `weapp`: `infoq-scaffold-frontend-weapp-react`

Do not split this work into a separate run-dev-stack skill and a separate weapp smoke skill. Keep the workflow here and select the client-specific references that match the task.

## Client Selection

1. If the task targets browser login, route guards, page screenshots, console diagnostics, or backend + admin startup, use the `admin` path.
2. If the task targets WeChat DevTools open flow, mini-program login, route traversal, API contract coverage, or e2e smoke, use the `weapp` path.
3. If the request is generic website automation without repository-specific bootstrap, use `infoq-browser-automation` instead.

## Admin Workflow

1. Start or restart the backend + React admin stack with `scripts/start_admin_dev_stack.sh`.
2. Acquire a deterministic login token with `scripts/print_admin_login_inject_snippet.sh`.
3. Enumerate real backend routes with `scripts/fetch_admin_routes_with_token.sh` instead of guessing route paths.
4. Use `infoq-browser-automation` or Playwright MCP to open `http://127.0.0.1:5174/login`, inject the token, navigate target routes, capture screenshots, and inspect console errors.
5. Stop only the processes started by this skill with `scripts/stop_admin_dev_stack.sh`.

## Weapp Workflow

1. Before any `build-open:weapp` command, replace `TARO_APP_ID` in `infoq-scaffold-frontend-weapp-react/.env.development` with your own mini-program AppID. Empty values and `touristappid` are rejected by the launcher script.
2. Use the exact local open command when the task is “自动化启动小程序” or “打开微信开发者工具联调”:
   - `pnpm --dir infoq-scaffold-frontend-weapp-react build-open:weapp:dev`
3. For deterministic smoke or e2e verification, use `scripts/run_weapp_smoke.sh` and pick `--suite smoke|core|full` based on scope.
4. When the smoke flow needs backend login, keep backend reachable on `http://127.0.0.1:8080` and disable captcha.
5. Treat `[object Object]` in smoke logs as a product defect, not a tolerable test artifact.

## Guardrails

- Do not reintroduce a shared-base helper skill under `.agents/skills` for React runtime work.
- Do not guess admin routes when the backend route API can be queried.
- Do not hardcode mini-program AppID into source changes for local verification; keep it in `.env.*` or shell env.
- Do not mark runtime verification as passed when browser or DevTools startup failed.

## References

Load only what is needed:

- `references/admin/commands.md`
- `references/weapp/commands.md`
- `references/weapp/endpoints.md`
