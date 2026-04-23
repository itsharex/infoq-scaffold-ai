# InfoQ Project Reference

## Table of Contents

- Project Scope
- Backend Reference
- Admin Frontend Reference
  - React Admin
  - Vue Admin
- Mini Program Frontend Reference
  - React Weapp
  - Vue Weapp
- Infrastructure And Operations
- Conventions
- Commands
  - Backend
  - React Admin
  - Vue Admin
  - React Weapp
  - Vue Weapp
- Validation And Delivery

## Project Scope

- Project root: `./`
- Active workspaces:
  - `infoq-scaffold-backend`
  - `infoq-scaffold-frontend-react`
  - `infoq-scaffold-frontend-vue`
  - `infoq-scaffold-frontend-weapp-react`
  - `infoq-scaffold-frontend-weapp-vue`
  - `openspec`
  - `script`
  - `sql`
  - `doc`
- Workspace instruction files:
  - `AGENTS.md`
  - `infoq-scaffold-backend/AGENTS.md`
  - `infoq-scaffold-frontend-react/AGENTS.md`
  - `infoq-scaffold-frontend-vue/AGENTS.md`
  - `infoq-scaffold-frontend-weapp-react/AGENTS.md`
  - `infoq-scaffold-frontend-weapp-vue/AGENTS.md`

## Backend Reference

- Backend modules:
  - `infoq-core`: `infoq-core-bom`, `infoq-core-common`, `infoq-core-data`
  - `infoq-plugin`: `encrypt`, `excel`, `jackson`, `log`, `mail`, `mybatis`, `oss`, `redis`, `satoken`, `security`, `sensitive`, `sse`, `translation`, `web`, `websocket`, `doc`
  - `infoq-modules`: `system`
  - `infoq-admin`
- Backend entry: `infoq-scaffold-backend/infoq-admin/src/main/java/cc/infoq/admin/SysAdminApplication.java`
- Backend config files:
  - `infoq-scaffold-backend/infoq-admin/src/main/resources/application.yml`
  - `infoq-scaffold-backend/infoq-admin/src/main/resources/application-dev.yml`
  - `infoq-scaffold-backend/infoq-admin/src/main/resources/application-local.yml`
  - `infoq-scaffold-backend/infoq-admin/src/main/resources/application-prod.yml`
  - `infoq-scaffold-backend/infoq-admin/src/main/resources/logback-plus.xml`

## Admin Frontend Reference

### React Admin

- Key directories:
  - `infoq-scaffold-frontend-react/src/pages`
  - `infoq-scaffold-frontend-react/src/components`
  - `infoq-scaffold-frontend-react/src/api`
  - `infoq-scaffold-frontend-react/src/store`
  - `infoq-scaffold-frontend-react/src/router`
  - `infoq-scaffold-frontend-react/src/utils`
  - `infoq-scaffold-frontend-react/tests`
- Key files:
  - `infoq-scaffold-frontend-react/package.json`
  - `infoq-scaffold-frontend-react/vite.config.ts`
  - `infoq-scaffold-frontend-react/eslint.config.js`
  - `infoq-scaffold-frontend-react/tests/setup.ts`
  - `infoq-scaffold-frontend-react/.env.development`

### Vue Admin

- Key directories:
  - `infoq-scaffold-frontend-vue/src/views`
  - `infoq-scaffold-frontend-vue/src/components`
  - `infoq-scaffold-frontend-vue/src/api`
  - `infoq-scaffold-frontend-vue/src/store`
  - `infoq-scaffold-frontend-vue/src/router`
  - `infoq-scaffold-frontend-vue/src/utils`
  - `infoq-scaffold-frontend-vue/src/plugins`
  - `infoq-scaffold-frontend-vue/tests`
- Key files:
  - `infoq-scaffold-frontend-vue/package.json`
  - `infoq-scaffold-frontend-vue/vite.config.ts`
  - `infoq-scaffold-frontend-vue/eslint.config.ts`
  - `infoq-scaffold-frontend-vue/.env.development`
  - `infoq-scaffold-frontend-vue/tests/setup.ts`

## Mini Program Frontend Reference

### React Weapp

- Key directories:
  - `infoq-scaffold-frontend-weapp-react/src/pages`
  - `infoq-scaffold-frontend-weapp-react/src/components`
  - `infoq-scaffold-frontend-weapp-react/src/api`
  - `infoq-scaffold-frontend-weapp-react/src/store`
  - `infoq-scaffold-frontend-weapp-react/src/utils`
  - `infoq-scaffold-frontend-weapp-react/src/styles`
  - `infoq-scaffold-frontend-weapp-react/tests`
- Key files:
  - `infoq-scaffold-frontend-weapp-react/package.json`
  - `infoq-scaffold-frontend-weapp-react/config/index.ts`
  - `infoq-scaffold-frontend-weapp-react/.env.development`
  - `infoq-scaffold-frontend-weapp-react/project.config.json`

### Vue Weapp

- Key directories:
  - `infoq-scaffold-frontend-weapp-vue/src/pages`
  - `infoq-scaffold-frontend-weapp-vue/src/components`
  - `infoq-scaffold-frontend-weapp-vue/src/api`
  - `infoq-scaffold-frontend-weapp-vue/src/store`
  - `infoq-scaffold-frontend-weapp-vue/src/utils`
  - `infoq-scaffold-frontend-weapp-vue/src/styles`
  - `infoq-scaffold-frontend-weapp-vue/tests`
- Key files:
  - `infoq-scaffold-frontend-weapp-vue/package.json`
  - `infoq-scaffold-frontend-weapp-vue/vite.config.ts`
  - `infoq-scaffold-frontend-weapp-vue/.env.development`
  - `infoq-scaffold-frontend-weapp-vue/manifest.json`
  - `infoq-scaffold-frontend-weapp-vue/pages.json`

## Infrastructure And Operations

- Scripts:
  - `script/generate-app-icon.js`
  - `script/build-open-wechat-devtools.mjs`
  - `script/bin/infoq.sh`
  - `script/bin/deploy-frontend.sh`
- Compose and gateway:
  - `script/docker/docker-compose.yml`
  - `script/docker/nginx/conf/nginx.conf`
  - `script/docker/redis/conf/redis.conf`
- SQL bootstrap:
  - `sql/infoq_scaffold_2.0.0.sql`

## Conventions

- Architecture: `Controller -> Service -> Mapper -> Entity`
- Java package convention: `cc.infoq.{module}.{layer}`
- Java entities and mappers commonly use `Sys*`
- Vue and React components use PascalCase
- TypeScript utils and hooks use camelCase
- All project files use UTF-8
- Backend `.editorconfig` uses 4 spaces; frontend uses 2 spaces
- Frontend package manager policy: prefer `pnpm`; if unavailable, fall back to equivalent `npm` commands

## Commands

### Backend

- Build: `cd infoq-scaffold-backend && mvn clean package -P dev`
- Run: `cd infoq-scaffold-backend && mvn spring-boot:run -pl infoq-admin`
- Targeted test: `cd infoq-scaffold-backend && mvn -pl infoq-modules/infoq-system -am -DskipTests=false test`

### React Admin

- Install: `cd infoq-scaffold-frontend-react && pnpm install`
- Dev: `cd infoq-scaffold-frontend-react && pnpm run dev`
- Test: `cd infoq-scaffold-frontend-react && pnpm run test`
- Coverage: `cd infoq-scaffold-frontend-react && pnpm run test:coverage`
- Lint: `cd infoq-scaffold-frontend-react && pnpm run lint`
- Build: `cd infoq-scaffold-frontend-react && pnpm run build:prod`

### Vue Admin

- Install: `cd infoq-scaffold-frontend-vue && pnpm install`
- Dev: `cd infoq-scaffold-frontend-vue && pnpm run dev`
- Test: `cd infoq-scaffold-frontend-vue && pnpm run test:unit`
- Coverage: `cd infoq-scaffold-frontend-vue && pnpm run test:unit:coverage`
- Lint: `cd infoq-scaffold-frontend-vue && pnpm run lint:eslint`
- Build: `cd infoq-scaffold-frontend-vue && pnpm run build:prod`

### React Weapp

- Install: `cd infoq-scaffold-frontend-weapp-react && pnpm install`
- Unit tests: `cd infoq-scaffold-frontend-weapp-react && pnpm run test`
- Coverage: `cd infoq-scaffold-frontend-weapp-react && pnpm run test:coverage`
- Lint: `cd infoq-scaffold-frontend-weapp-react && pnpm run lint`
- Build dev bundle: `cd infoq-scaffold-frontend-weapp-react && pnpm run build:weapp:dev`
- Open WeChat DevTools dev bundle: `pnpm --dir infoq-scaffold-frontend-weapp-react build-open:weapp:dev`
- Local runtime gate: `cd infoq-scaffold-frontend-weapp-react && pnpm run verify:local`

Before `build-open:weapp:dev`, update `infoq-scaffold-frontend-weapp-react/.env.development` `TARO_APP_ID` to your own AppID.

### Vue Weapp

- Install: `cd infoq-scaffold-frontend-weapp-vue && pnpm install`
- Typecheck: `cd infoq-scaffold-frontend-weapp-vue && pnpm run typecheck`
- Unit tests: `cd infoq-scaffold-frontend-weapp-vue && pnpm run test`
- Coverage: `cd infoq-scaffold-frontend-weapp-vue && pnpm run test:coverage`
- Build dev bundle: `cd infoq-scaffold-frontend-weapp-vue && pnpm run build:weapp:dev`
- Open WeChat DevTools dev bundle: `pnpm --dir infoq-scaffold-frontend-weapp-vue build-open:weapp:dev`
- Local runtime gate: `cd infoq-scaffold-frontend-weapp-vue && pnpm run verify:local`

Before `build-open:weapp:dev`, update `infoq-scaffold-frontend-weapp-vue/.env.development` `TARO_APP_ID` to your own AppID.

## Validation And Delivery

- Default execution loop: `main-flow verification -> targeted tests -> lint/build -> diff review`
- Delivery planning should define one acceptance contract covering functional scope, non-goals, exception handling, required logs or observability, and rollback conditions
- Releasable changes must verify environment/config prerequisites and external dependencies before deployment
- Destructive or high-risk operations affecting shared environments, data, or deployment state require explicit confirmation
- Backend runtime/login changes should use `infoq-login-success-check` and `infoq-backend-smoke-test`
- Admin runtime verification belongs to `infoq-react-runtime-verification` or `infoq-vue-runtime-verification`
- Weapp runtime verification belongs to the same React or Vue family runtime skill via `references/weapp/*`
