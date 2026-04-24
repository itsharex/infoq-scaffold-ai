# Admin 命令

## 启动 Backend + React Admin

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/start_admin_dev_stack.sh
```

## 仅停止本技能启动的进程

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/stop_admin_dev_stack.sh
```

## 打印 Token 注入片段

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/print_admin_login_inject_snippet.sh
```

## 从后端抓取真实路由路径

```bash
bash .agents/skills/infoq-react-runtime-verification/scripts/fetch_admin_routes_with_token.sh
```

## 默认 Admin URL

- 登录页：`http://127.0.0.1:5174/login`
- 首页壳：`http://127.0.0.1:5174/index`
- 后端验证码探针：`http://127.0.0.1:8080/auth/code`

## 浏览器验证模式

1. 启动本地栈。
2. 运行 `print_admin_login_inject_snippet.sh` 获取精确的 localStorage 注入表达式。
3. 使用 `infoq-browser-automation` 或 Playwright MCP 打开 `/login`，注入 token，并按 `fetch_admin_routes_with_token.sh` 返回的路由逐个验证。
