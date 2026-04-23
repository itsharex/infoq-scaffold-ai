# Admin Commands

Prefer `pnpm` for the commands below. If `pnpm` is unavailable in the current environment, replace them with the equivalent `npm` commands.

## Install And Bootstrap

```bash
cd infoq-scaffold-frontend-vue
pnpm install
```

## Run One Test File

```bash
cd infoq-scaffold-frontend-vue
npx vitest --config vitest.config.ts --run tests/utils/request.test.ts
```

## Run P1 Plugin Or Realtime Batch

```bash
cd infoq-scaffold-frontend-vue
npx vitest --config vitest.config.ts --run \
  tests/plugins/download.test.ts \
  tests/plugins/modal.test.ts \
  tests/plugins/tab.test.ts \
  tests/utils/sse.test.ts \
  tests/utils/websocket.test.ts
```

## Run P2 Components And Lightweight Views

```bash
cd infoq-scaffold-frontend-vue
npx vitest --config vitest.config.ts --run \
  tests/components/Breadcrumb.test.ts \
  tests/components/Pagination.test.ts \
  tests/components/RightToolbar.test.ts \
  tests/components/DictTag.test.ts \
  tests/components/IconSelect.test.ts \
  tests/views/error401.test.ts \
  tests/views/error404.test.ts \
  tests/views/redirect.test.ts \
  tests/views/index.test.ts
```

## Run P3 Heavy System Or Monitor Views

```bash
cd infoq-scaffold-frontend-vue
npx vitest --config vitest.config.ts --run \
  tests/views/system/menu/index.test.ts \
  tests/views/system/user/index.test.ts \
  tests/views/system/notice/index.test.ts \
  tests/views/system/config/index.test.ts \
  tests/views/system/client/index.test.ts \
  tests/views/system/oss/index.test.ts \
  tests/views/system/oss/config.test.ts \
  tests/views/monitor/online/index.test.ts \
  tests/views/monitor/loginInfo/index.test.ts \
  tests/views/monitor/cache/index.test.ts \
  tests/views/monitor/operLog/index.test.ts \
  tests/views/monitor/operLog/oper-info-dialog.test.ts
```

## Runtime Follow-Up

```bash
bash .agents/skills/infoq-vue-runtime-verification/scripts/start_admin_dev_stack.sh
bash .agents/skills/infoq-vue-runtime-verification/scripts/print_admin_login_inject_snippet.sh
bash .agents/skills/infoq-vue-runtime-verification/scripts/fetch_admin_routes_with_token.sh
```

## Full Quality Gate

```bash
cd infoq-scaffold-frontend-vue
pnpm run test:unit
pnpm run test:unit:coverage
pnpm run lint:eslint
pnpm run build:prod
```
