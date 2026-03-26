# Priority Matrix

## P0 (must first)

- `src/utils/request.ts`
- `src/utils/auth.ts`
- `src/utils/crypto.ts`
- `src/store/modules/user.ts`
- `src/store/modules/permission.ts`
- `src/store/modules/app.ts`
- `src/store/modules/settings.ts`
- `src/store/modules/tagsView.ts`
- `src/router/AuthGuard.tsx`
- `src/router/BackendRouteView.tsx`
- `src/router/pathToComponent.ts`
- `src/router/routeTransform.tsx`

## P1

- Shared components: `ScreenFull`, `SvgIcon`, `Editor`, `FileUpload`, `ImageUpload`
- Layout pieces: `MainLayout`, `TagsViewBar`, keep-alive behavior
- Bridge or shell components that connect router/layout/runtime state

## P2

- Authentication and entry pages: `pages/login`, `pages/home`
- Representative monitored pages: `pages/monitor/cache`
- Then grouped domain pages with stable mocks: `pages/system/*`, `pages/monitor/*`

## P3

- Dense CRUD and authorization pages covered by grouped suites:
  - `tests/pages/system-pages.test.tsx`
  - `tests/pages/ops-pages.test.tsx`
  - `tests/pages/monitor-auth-profile.test.tsx`
- Prefer extending an existing grouped suite before creating a fragmented one-off file unless the page has unique runtime requirements.

### Current Coverage Shape

- Foundations already covered: utils, stores, router guards, route transforms
- Reusable UI already covered: common components, upload/editor wrappers, layout chrome
- Representative pages already covered: login, cache, system, monitor, auth/profile flows
- Use the matrix to fill business branches and regressions first, not to chase arbitrary percentage bumps

## Definition of Done per file

- Happy path plus at least one meaningful error or guard branch
- User-visible output, redirect, or notification asserted
- Store mutation, router transition, request header, or download side effect asserted when applicable
- Browser-only APIs stubbed exactly, not broadly silenced
