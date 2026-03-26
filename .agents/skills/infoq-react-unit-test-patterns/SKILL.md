---
name: infoq-react-unit-test-patterns
description: Build and scale React frontend unit tests for infoq-scaffold-frontend-react (React 19 + Vite7 + TypeScript + Ant Design) using Vitest, Testing Library, jsdom, deterministic router/store/browser mocks, and strict validation with test+coverage+lint+build. Use when users request React unit tests, React coverage backfill, regression tests, bug reproduction by tests, or test-first fixes in infoq-scaffold-frontend-react. Do not use this skill for Vue test work.
---

# Infoq React Unit Test Patterns

## Scope

Use this skill only for `infoq-scaffold-frontend-react` test coverage expansion and regression-proof refactors.
Vue-side test work belongs to `infoq-vue-unit-test-patterns`.
Primary targets in order: `src/utils` -> `src/store` -> `src/router` -> `src/components` -> `src/layouts` -> `src/pages`.

Current repository signals:
- Vitest is configured in `vite.config.ts` under the `test` key.
- Shared browser and storage mocks live in `tests/setup.ts`.
- Existing tests already cover utils, stores, router guards, reusable components, layouts, and representative pages such as `/login`.

Package manager rule:
- Prefer `pnpm` for all frontend validation commands.
- If `pnpm` is unavailable in the current environment, use the equivalent `npm` commands.

## Workflow

1. Reuse existing React test infra first. If the baseline is broken or missing, restore it from `references/setup-baseline.md`.
2. Keep test env deterministic: use jsdom, memory `localStorage` and `sessionStorage`, `matchMedia`, and `ResizeObserver` from `tests/setup.ts`.
3. Add tests by priority:
   - P0: `utils/request`, `utils/auth`, `utils/crypto`, `store/modules/*`, `router/*`
   - P1: shared components and layouts such as `Pagination`, `RightToolbar`, `ScreenFull`, `TagsViewBar`, `MainLayout`
   - P2: authentication and monitor/system pages such as `pages/login`, `pages/system/*`, `pages/monitor/*`
4. Prefer Testing Library behavior assertions with user-visible output and navigation results.
5. For router and guard tests, render with `MemoryRouter` and set Zustand store state directly with `useXxxStore.setState(...)`.
6. For request and API-adjacent tests, mock modules with `vi.mock(...)` or override axios adapters directly instead of hitting network.
7. If tests expose business bugs, patch source immediately and add regression assertions.
8. Run React smoke verification on `/login` or affected guarded routes with `infoq-react-browser-automation` when runtime behavior changed.
9. Run targeted tests first, then the full unit suite, then coverage, lint, and production build.

## Guardrails

- Prefer user-observable behavior assertions over implementation details or snapshots of large DOM trees.
- Reuse `tests/helpers/renderWithRouter.tsx` when route context is needed.
- Mock Ant Design or browser-only APIs only as far as needed for deterministic behavior; do not silence real rendering or state bugs with broad no-op stubs.
- For fullscreen, resize, or other document APIs, use `Object.defineProperty(...)` to stub exact browser methods used by the component.
- For login and auth flows, mock `@/api/login` and manipulate Zustand store methods directly instead of booting the whole app.
- For request helpers, override `service.defaults.adapter` to assert headers, encryption, blobs, and relogin behavior without network traffic.
- Do not weaken assertions, broaden mocks, mute warnings, raise thresholds, or add fake-success paths merely to make tests/build pass; fix the real issue or stop and document a user-approved exception.
- If a source or test change is identified as wrong, revert the incorrect code immediately before continuing and do not leave dead, unreachable, or uncalled code behind.

## Known Project Patterns

- `tests/setup.ts` already installs `@testing-library/jest-dom/vitest`, storage mocks, `matchMedia`, `ResizeObserver`, and loads `@/lang`.
- Router guard tests should set up `useUserStore` and `usePermissionStore` explicitly before render.
- Component tests often succeed with direct button clicks and assertions on callbacks instead of deep Ant Design internals.
- Request tests can verify encrypted payloads and download behavior by swapping the axios adapter.
- Login page tests should fill rendered form controls, submit through the visible button, and assert on local storage or mocked store actions.

## Finish Criteria

All must pass:

```bash
cd infoq-scaffold-frontend-react
pnpm run test
pnpm run test:coverage
pnpm run lint:fix
pnpm run build:prod
```

## References

- Commands: `references/commands.md`
- Setup baseline: `references/setup-baseline.md`
- Priority matrix: `references/priority-matrix.md`
- Mock patterns: `references/mock-patterns.md`
