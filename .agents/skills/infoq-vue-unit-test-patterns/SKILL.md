---
name: infoq-vue-unit-test-patterns
description: Build and scale unit tests for the Vue family in this repository, covering both `infoq-scaffold-frontend-vue` admin and `infoq-scaffold-frontend-weapp-vue` mini-program code. Use when users request Vue-family unit tests, coverage backfill, regression tests, deterministic bug reproduction by tests, or test-first fixes. Choose `admin` vs `weapp` through this skill's client-specific references and keep runtime follow-up inside `infoq-vue-runtime-verification`.
---

# InfoQ Vue Unit Test Patterns

This skill owns one job only: Vue-family unit-test work.
It covers two clients:

- `admin`: `infoq-scaffold-frontend-vue`
- `weapp`: `infoq-scaffold-frontend-weapp-vue`

## Client Selection

1. Use the `admin` references for Vue 3 + Element Plus + Pinia + Vue Router pages and utilities.
2. Use the `weapp` references for uni-app Vue mini-program pages, request wrappers, stores, and API contracts.
3. If the task is runtime verification instead of unit testing, switch to `infoq-vue-runtime-verification`.

## Workflow

1. Identify the client and load only the matching `references/admin/*` or `references/weapp/*` material.
2. Reuse the existing test baseline before adding new helpers or mocks.
3. Start with user-observable behavior and boundary cases instead of implementation details.
4. Run targeted tests first; if source defects are exposed, fix product code before widening the suite.
5. When runtime behavior changed, finish with `infoq-vue-runtime-verification`.
6. Close with the client-specific quality gate.

## Finish Criteria

### Admin

```bash
cd infoq-scaffold-frontend-vue
pnpm run test:unit
pnpm run test:unit:coverage
pnpm run lint:eslint
pnpm run build:prod
```

### Weapp

```bash
cd infoq-scaffold-frontend-weapp-vue
pnpm run typecheck
pnpm run test
pnpm run test:coverage
pnpm run build:weapp:dev
pnpm run build:weapp
```

Use `pnpm run verify:local` when the change also affects the mini-program runtime path.

## Guardrails

- Do not split Vue admin tests and Vue weapp tests into separate skills again unless the workflows truly diverge.
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
- `references/weapp/coverage-fastpath.md`
