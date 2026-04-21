---
name: infoq-weapp-unit-test-fastpath
description: Accelerate unit-test delivery for infoq-scaffold-frontend-weapp-react and infoq-scaffold-frontend-weapp-vue by proving one test type first and reusing deterministic templates for request/store/utils/api-contract. Use this skill whenever users request 小程序单测提速, weapp unit-test fastpath, 覆盖率补齐但要先打通一个类型, or ask to fix failing tests with product-code-first discipline. Never mask defects by weakening tests.
---

# Infoq Weapp Unit Test FastPath

## Scope

Use this skill for:
- `infoq-scaffold-frontend-weapp-react`
- `infoq-scaffold-frontend-weapp-vue`

Goal:
- Reduce token/time cost by reusing proven test patterns across test types.
- Keep correctness strict: unit tests are the source of truth.

Hard rule:
- If unit tests fail due to a real defect, fix product code first.
- Do not weaken assertions, delete failing cases, or rewrite tests to hide defects.

## Workflow

1. Freeze baseline
- Run `pnpm run test`.
- Run `pnpm run test:coverage`.
- Record uncovered files/lines.

2. Pick one type and fully prove it first
- Candidate types: `request`, `store`, `utils`, `api-contract`.
- Complete one type end-to-end:
  - targeted tests pass
  - corresponding coverage gap cleared
  - no flaky behavior

3. Extract reusable template from the proven type
- Keep:
  - setup/mocking strategy
  - naming convention
  - assertion style (behavior + side effects)
  - cleanup/reset pattern
- Reuse this template for the remaining types.

4. Expand type-by-type with deterministic mocks
- `request`: error normalization, auth flow, nested payload branches.
- `store`: state transitions, force-refresh paths, failure propagation.
- `utils`: runtime/env branches, edge-value handling.
- `api-contract`: wrapper signatures and route-method contract guards.

5. Validate in fixed order
- targeted test file(s)
- full unit tests
- coverage
- weapp build dev
- weapp build prod

## Reusable patterns

## Request type
- Use module-level setup function with `vi.resetModules()` + `vi.doMock(...)`.
- Test one error shape per branch family (direct/nested/response/response.data).
- Assert:
  - thrown error class
  - message text
  - side effects (e.g. token cleanup on 401)

## Store type
- React: reset Zustand state before each case.
- Vue: `createPinia()` + `setActivePinia()` before each case.
- Assert state snapshots after each action, not implementation details.

## Utils type
- Drive branches with explicit runtime fixtures.
- For module-init env logic, use `resetModules -> set env -> import module`.

## API-contract type
- Keep wrappers thin and deterministic.
- Guard against untested new wrappers by central contract tests.

## Definition of done

- All required unit tests pass.
- Coverage meets workspace threshold.
- Build checks pass.
- No test-only workaround that masks product defects.
