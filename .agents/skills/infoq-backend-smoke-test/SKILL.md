---
name: infoq-backend-smoke-test
description: 在后端改动后为本项目执行可重复的后端冒烟测试。适用于冒烟测试、接口验证、运行态验证或“继续执行验证”类请求，尤其在 MyBatis Mapper/XML 迁移、权限鉴权重构或构建成功确认之后。
---

# Infoq 后端冒烟测试

## 概览

为 `infoq-scaffold-backend` 执行确定性的后端冒烟流程：
- 在隔离端口启动后端，并关闭验证码。
- 默认使用 `application-local.yml` 对应的 `local` profile 启动后端。
- 就绪探活优先检查 `/actuator/health`；若该端点被 Basic Auth 保护，收到 `401` 也视为服务已启动，再由后续公开接口校验业务可用性。
- 校验公开接口。
- 执行加密 `/auth/login`。
- 校验受保护接口，覆盖 menu/dept/dict/user-export 链路。
- 停止服务并输出通过/失败报告。

## 执行

执行：

```bash
bash .agents/skills/infoq-backend-smoke-test/scripts/run_smoke.sh
```

常用参数：

```bash
# Build first, then run smoke tests
bash .agents/skills/infoq-backend-smoke-test/scripts/run_smoke.sh --build

# Use a different account or port
bash .agents/skills/infoq-backend-smoke-test/scripts/run_smoke.sh \
  --username admin \
  --password 'your-password' \
  --port 18081

# Override the Spring profile when needed
bash .agents/skills/infoq-backend-smoke-test/scripts/run_smoke.sh \
  --profile dev

# Keep server alive for manual debugging after smoke tests
bash .agents/skills/infoq-backend-smoke-test/scripts/run_smoke.sh --keep-server
```

## 默认值

- 项目根目录：由脚本位置自动探测。
- Jar 路径：`infoq-scaffold-backend/infoq-admin/target/infoq-admin.jar`
- 端口：`18080`
- 验证码：通过 `--captcha.enable=false` 强制关闭。
- Spring profile：默认 `local`，也可通过 `--profile` 或 `SMOKE_SPRING_PROFILES_ACTIVE` 覆盖。
- Client ID：`e5cd7e4891bf95d1d19206ce24a7b32e`
- 优先登录候选：
  - `dept / 666666`
  - `owner / 666666`
  - `admin / 123456`

## 通过标准

仅当以下检查全部通过时，才判定冒烟测试通过：
- `GET /` 返回 HTTP 200。
- `GET /auth/code` 返回 `{ code: 200 }`。
- 登录成功并返回 token。
- `GET /system/menu/getRouters` 返回 `{ code: 200 }`。
- `GET /system/menu/roleMenuTreeselect/{roleId}` 返回 `{ code: 200 }`。
- `GET /system/role/deptTree/{roleId}` 返回 `{ code: 200 }`。
- `GET /system/dict/data/type/{dictType}` 返回 `{ code: 200 }`。
- `POST /system/user/export` 返回 Excel 二进制内容。

## 失败处理

- 若某个账号登录失败，自动尝试后备账号。
- 若服务启动失败，输出生成的临时日志文件尾部内容。
- 若任一检查失败，以非零码退出，并包含失败接口与响应预览。

## 参考资源

- 脚本入口：`scripts/run_smoke.sh`
- API 校验逻辑：`scripts/smoke_checks.mjs`
- 接口检查清单：`references/endpoints.md`
