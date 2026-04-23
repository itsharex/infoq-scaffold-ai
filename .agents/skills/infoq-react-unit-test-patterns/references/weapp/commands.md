# Weapp Commands

## Full Validation

```bash
cd infoq-scaffold-frontend-weapp-react
pnpm run test
pnpm run test:coverage
pnpm run lint
pnpm run build:weapp:dev
pnpm run build:weapp
```

## Targeted Test

```bash
cd infoq-scaffold-frontend-weapp-react
pnpm exec vitest --run --config vitest.config.ts tests/core/request.test.ts
```

## Local Runtime Follow-Up

```bash
cd infoq-scaffold-frontend-weapp-react
pnpm run verify:local
```

## Exact DevTools Open Command

```bash
pnpm --dir infoq-scaffold-frontend-weapp-react build-open:weapp:dev
```

Before this command, update `infoq-scaffold-frontend-weapp-react/.env.development` `TARO_APP_ID` to your own AppID.

## Runtime Smoke Skill Entry

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/run_weapp_smoke.sh --suite core
```
