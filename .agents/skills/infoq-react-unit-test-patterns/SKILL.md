---
name: infoq-react-unit-test-patterns
description: Build and scale unit tests for the React family in this repository, covering both `infoq-scaffold-frontend-react` admin and `infoq-scaffold-frontend-weapp-react` mini-program code. Use when users request React-family unit tests, coverage backfill, regression tests, deterministic bug reproduction by tests, or test-first fixes. Choose `admin` vs `weapp` through this skill's client-specific references and keep runtime follow-up inside `infoq-react-runtime-verification`.
---

# InfoQ React Unit Test Patterns

This skill owns one job only: React-family unit-test work.
It covers two clients:

- `admin`: `infoq-scaffold-frontend-react`
- `weapp`: `infoq-scaffold-frontend-weapp-react`

## Client Selection

1. Use the `admin` references for React 19 + Ant Design + React Router + Zustand pages and utilities.
2. Use the `weapp` references for Taro React mini-program pages, request wrappers, stores, and API contracts.
3. If the task is runtime verification instead of unit testing, switch to `infoq-react-runtime-verification`.

## Workflow

1. Identify the client and load only the matching `references/admin/*` or `references/weapp/*` material.
2. Reuse the existing test baseline before adding new helpers or mocks.
3. Start with user-observable behavior and boundary cases instead of implementation details.
4. Run targeted tests first; if source defects are exposed, fix product code before widening the suite.
5. When runtime behavior changed, finish with `infoq-react-runtime-verification`.
6. Close with the client-specific quality gate.

## Finish Criteria

### Admin

```bash
cd infoq-scaffold-frontend-react
pnpm run test
pnpm run test:coverage
pnpm run lint
pnpm run build:prod
```

### Weapp

```bash
cd infoq-scaffold-frontend-weapp-react
pnpm run test
pnpm run test:coverage
pnpm run lint
pnpm run build:weapp:dev
pnpm run build:weapp
```

Use `pnpm run verify:local` when the change also affects the mini-program runtime path.

## Guardrails

- Do not split React admin tests and React weapp tests into separate skills again unless the workflows truly diverge.
- Do not weaken assertions, broaden mocks, or add fake-success paths to force coverage.
- Do not use runtime smoke as a substitute for missing unit coverage.

## References

- `references/admin/commands.md`
- `references/admin/setup-baseline.md`
- `references/admin/priority-matrix.md`
- `references/admin/mock-patterns.md`
- `references/weapp/commands.md`
- `references/weapp/priority-matrix.md`
- `references/weapp/mock-patterns.md`
