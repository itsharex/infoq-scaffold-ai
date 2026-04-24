---
name: infoq-vue-runtime-verification
description: 执行本项目 Vue 家族的仓库专用运行态验证，覆盖 `infoq-scaffold-frontend-vue` 管理端与 `infoq-scaffold-frontend-weapp-vue` 小程序流程。适用于 Vue 登录校验、路由校验、本地栈启动/重启、截图、控制台诊断与小程序 smoke/e2e；按 `admin`/`weapp` 参考与脚本分流，通用站点浏览器任务优先使用 `infoq-browser-automation`。
---

# InfoQ Vue 运行态验证

本技能只负责一件事：本仓库 Vue 家族的运行态验证。
它依赖本地后端和相应 Vue 客户端运行时。Admin 验证依赖浏览器自动化；小程序验证依赖微信开发者工具与工作区 `build-open` 脚本。
覆盖两个客户端：

- `admin`: `infoq-scaffold-frontend-vue`
- `weapp`: `infoq-scaffold-frontend-weapp-vue`

不要把这项工作再次拆成 run-dev-stack 技能和 weapp smoke 技能。流程统一放在这里，并按任务选择对应客户端参考文档。

## 客户端选择

1. 若任务涉及浏览器登录、路由守卫、页面截图、控制台诊断、后端+admin 启动，使用 `admin` 路径。
2. 若任务涉及微信开发者工具打开流程、小程序登录、路由遍历、API 契约覆盖或 e2e 冒烟，使用 `weapp` 路径。
3. 若是非仓库特定启动流程的通用网站自动化，改用 `infoq-browser-automation`。

## Admin 工作流

1. 使用 `scripts/start_admin_dev_stack.sh` 启动或重启 backend + Vue admin 栈。
2. 使用 `scripts/print_admin_login_inject_snippet.sh` 获取可复现登录 token。
3. 通过 `scripts/fetch_admin_routes_with_token.sh` 枚举真实后端路由，禁止猜测路径。
4. 使用 `infoq-browser-automation` 或 Playwright MCP 打开 `http://127.0.0.1:5173/login`，注入 token、跳转目标路由、截图并检查控制台错误。
5. 使用 `scripts/stop_admin_dev_stack.sh` 仅停止本技能启动的进程。

## Weapp 工作流

1. 在任何 `build-open:weapp` 命令前，将 `infoq-scaffold-frontend-weapp-vue/.env.development` 中的 `TARO_APP_ID` 替换为你自己的小程序 AppID。空值和 `touristappid` 会被启动脚本拒绝。
2. 当任务是“自动化启动小程序”或“打开微信开发者工具联调”时，使用以下精确本地命令：
   - `pnpm --dir infoq-scaffold-frontend-weapp-vue build-open:weapp:dev`
3. 进行可复现的 smoke/e2e 验证时，使用 `scripts/run_weapp_smoke.sh`，并根据范围选择 `--suite smoke|core|full`。
4. 若 smoke 流程需要后端登录，确保后端 `http://127.0.0.1:8080` 可达并关闭验证码。
5. 将 smoke 日志中的 `[object Object]` 视为产品缺陷，而非可容忍测试现象。

## 护栏

- 不要在 `.agents/skills` 下为 Vue 运行态工作重新引入共享底座 helper skill。
- 当后端路由 API 可查询时，禁止猜测 admin 路由。
- 本地验证时不要把小程序 AppID 硬编码进源码，保留在 `.env.*` 或 shell 环境变量中。
- 当浏览器或开发者工具启动失败时，禁止标记运行态验证通过。

## 参考

按需加载：

- `references/admin/commands.md`
- `references/weapp/commands.md`
- `references/weapp/endpoints.md`
