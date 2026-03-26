# Commands

Prefer `pnpm` for the commands below. If `pnpm` is unavailable in the current environment, replace them with the equivalent `npm` commands.

## Install and Bootstrap

```bash
cd infoq-scaffold-frontend-react
pnpm install
```

## Run One Test File

```bash
cd infoq-scaffold-frontend-react
npx vitest --run tests/utils/request.test.ts
```

## Run P0 Foundation Batch

```bash
cd infoq-scaffold-frontend-react
npx vitest --run \
  tests/utils/auth.test.ts \
  tests/utils/crypto.test.ts \
  tests/utils/request.test.ts \
  tests/store/layout-store.test.ts \
  tests/store/permission-store.test.ts \
  tests/router/auth-permission.test.tsx \
  tests/router/backend-route-view.test.tsx \
  tests/router/path-to-component.test.ts \
  tests/router/route-transform.test.ts
```

## Run P1 Layout and Reusable Components

```bash
cd infoq-scaffold-frontend-react
npx vitest --run \
  tests/components/bridge-components.test.tsx \
  tests/components/common-components.test.tsx \
  tests/components/svg-icon.test.tsx \
  tests/components/upload-editor.test.tsx \
  tests/layout/keep-alive.test.tsx \
  tests/layout/main-layout-icons.test.tsx \
  tests/layout/tags-view-bar.test.tsx
```

## Run P2 Representative Pages

```bash
cd infoq-scaffold-frontend-react
npx vitest --run \
  tests/pages/login.test.tsx \
  tests/pages/home.test.tsx \
  tests/pages/cache-page.test.tsx \
  tests/pages/system-pages.test.tsx \
  tests/pages/ops-pages.test.tsx \
  tests/pages/monitor-auth-profile.test.tsx
```

## Frontend Smoke (Login Page + Console Errors)

```bash
# start the local backend + React stack first
bash .agents/skills/infoq-react-run-dev-stack/scripts/start_react_dev_stack.sh

# then run browser verification helpers as needed
bash .agents/skills/infoq-react-browser-automation/scripts/print_login_inject_snippet.sh
bash .agents/skills/infoq-react-browser-automation/scripts/fetch_routes_with_token.sh
```

## Run Full Unit Suite

```bash
cd infoq-scaffold-frontend-react
pnpm run test
```

## Run Coverage

```bash
cd infoq-scaffold-frontend-react
pnpm run test:coverage
```

## Full Quality Gate

```bash
cd infoq-scaffold-frontend-react
pnpm run test
pnpm run test:coverage
pnpm run lint:fix
pnpm run build:prod
```
