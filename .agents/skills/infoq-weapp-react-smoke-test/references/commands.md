# Commands

## Backend Pre-Step (Recommended)

```bash
cd infoq-scaffold-backend
mvn -pl infoq-admin -am -DskipTests clean package
java -jar infoq-admin/target/infoq-admin.jar \
  --spring.profiles.active=local \
  --captcha.enable=false \
  --server.port=8080
```

## Default Full Smoke

```bash
bash .agents/skills/infoq-weapp-react-smoke-test/scripts/run_smoke.sh
```

## Core Smoke

```bash
bash .agents/skills/infoq-weapp-react-smoke-test/scripts/run_smoke.sh --suite core
```

## Reuse Existing Session (Manual Login Once)

```bash
bash .agents/skills/infoq-weapp-react-smoke-test/scripts/run_smoke.sh --keep-existing-session
```

## Keep Legal-Domain Check Enabled

```bash
bash .agents/skills/infoq-weapp-react-smoke-test/scripts/run_smoke.sh --url-check
```

## Explicit Backend Login Target

```bash
bash .agents/skills/infoq-weapp-react-smoke-test/scripts/run_smoke.sh \
  --base-url http://127.0.0.1:8080 \
  --username admin \
  --password admin123
```

## Login Success -> Home Only

```bash
bash .agents/skills/infoq-weapp-react-smoke-test/scripts/run_smoke.sh \
  --suite smoke \
  --skip-build \
  --base-url http://127.0.0.1:8080 \
  --login-home-only
```

This mode validates login token injection and `/pages/home/index` pass, and tolerates known `/pages/login/index` authenticated redirect mismatch.
