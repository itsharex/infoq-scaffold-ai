# Weapp Commands

## AppID Prerequisite

Before any DevTools open command, replace `TARO_APP_ID` in `infoq-scaffold-frontend-weapp-vue/.env.development` with your own WeChat mini-program AppID.
The launcher script rejects empty values and `touristappid`.

## Exact DevTools Open Command

```bash
pnpm --dir infoq-scaffold-frontend-weapp-vue build-open:weapp:dev
```

## Optional Shell Override

```bash
TARO_APP_ID=wx_your_appid pnpm --dir infoq-scaffold-frontend-weapp-vue build-open:weapp:dev
```

## Default Full Smoke

```bash
bash .agents/skills/infoq-vue-runtime-verification/scripts/run_weapp_smoke.sh
```

## Core Smoke

```bash
bash .agents/skills/infoq-vue-runtime-verification/scripts/run_weapp_smoke.sh --suite core
```

## Reuse Existing Session

```bash
bash .agents/skills/infoq-vue-runtime-verification/scripts/run_weapp_smoke.sh --keep-existing-session
```

## Enable WeChat Legal-Domain Check

```bash
bash .agents/skills/infoq-vue-runtime-verification/scripts/run_weapp_smoke.sh --url-check
```

## Explicit Backend Login Target

```bash
bash .agents/skills/infoq-vue-runtime-verification/scripts/run_weapp_smoke.sh \
  --base-url http://127.0.0.1:8080 \
  --username admin \
  --password admin123
```
