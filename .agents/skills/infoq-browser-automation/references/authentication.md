# 鉴权模式

覆盖登录流程、会话持久化、OAuth、2FA 与带鉴权浏览场景。

**关联文档**：状态持久化细节见 [session-management.md](session-management.md)，快速入口见 [SKILL.md](../SKILL.md)。

## 目录

- 基础登录流程
- 保存鉴权状态
- 恢复鉴权状态
- OAuth / SSO 流程
- 双因素认证
- HTTP Basic Auth
- 基于 Cookie 的鉴权
- Token 刷新处理
- 安全最佳实践

## 基础登录流程

```bash
# 打开登录页
agent-browser open https://app.example.com/login
agent-browser wait --load networkidle

# 获取表单元素
agent-browser snapshot -i
# 输出示例：@e1 [input type="email"], @e2 [input type="password"], @e3 [button] "Sign In"

# 填写凭据
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"

# 提交
agent-browser click @e3
agent-browser wait --load networkidle

# 验证登录成功
agent-browser get url  # 应该是 dashboard，而非 login
```

## 保存鉴权状态

登录成功后保存状态，供后续复用：

```bash
# 先完成登录（见上）
agent-browser open https://app.example.com/login
agent-browser snapshot -i
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait --url "**/dashboard"

# 保存已鉴权状态
agent-browser state save ./auth-state.json
```

## 恢复鉴权状态

通过加载已保存状态跳过登录：

```bash
# 加载已保存鉴权状态
agent-browser state load ./auth-state.json

# 直接访问受保护页面
agent-browser open https://app.example.com/dashboard

# 验证已鉴权
agent-browser snapshot -i
```

## OAuth / SSO 流程

处理 OAuth 重定向时：

```bash
# 发起 OAuth 流程
agent-browser open https://app.example.com/auth/google

# 自动处理重定向
agent-browser wait --url "**/accounts.google.com**"
agent-browser snapshot -i

# 填写 Google 凭据
agent-browser fill @e1 "user@gmail.com"
agent-browser click @e2  # 下一步按钮
agent-browser wait 2000
agent-browser snapshot -i
agent-browser fill @e3 "password"
agent-browser click @e4  # 登录

# 等待跳回业务站点
agent-browser wait --url "**/app.example.com**"
agent-browser state save ./oauth-state.json
```

## 双因素认证

通过人工介入处理 2FA：

```bash
# 使用账号密码登录
agent-browser open https://app.example.com/login --headed  # 显示浏览器窗口
agent-browser snapshot -i
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3

# 等待用户在浏览器中手动完成 2FA
echo "请在浏览器窗口中完成 2FA..."
agent-browser wait --url "**/dashboard" --timeout 120000

# 2FA 完成后保存状态
agent-browser state save ./2fa-state.json
```

## HTTP Basic Auth

对于采用 HTTP Basic 鉴权的网站：

```bash
# 导航前设置凭据
agent-browser set credentials username password

# 访问受保护资源
agent-browser open https://protected.example.com/api
```

## 基于 Cookie 的鉴权

手动设置鉴权 Cookie：

```bash
# 设置鉴权 Cookie
agent-browser cookies set session_token "abc123xyz"

# 访问受保护页面
agent-browser open https://app.example.com/dashboard
```

## Token 刷新处理

适用于 token 会过期的会话：

```bash
#!/bin/bash
# 处理 token 刷新的包装脚本

STATE_FILE="./auth-state.json"

# 优先尝试加载既有状态
if [[ -f "$STATE_FILE" ]]; then
    agent-browser state load "$STATE_FILE"
    agent-browser open https://app.example.com/dashboard

    # 判断会话是否仍然有效
    URL=$(agent-browser get url)
    if [[ "$URL" == *"/login"* ]]; then
        echo "会话已过期，重新鉴权..."
        # 执行重新登录
        agent-browser snapshot -i
        agent-browser fill @e1 "$USERNAME"
        agent-browser fill @e2 "$PASSWORD"
        agent-browser click @e3
        agent-browser wait --url "**/dashboard"
        agent-browser state save "$STATE_FILE"
    fi
else
    # 首次登录
    agent-browser open https://app.example.com/login
    # ... 登录流程 ...
fi
```

## 安全最佳实践

1. **不要提交状态文件**：其中包含会话 token
   ```bash
   echo "*.auth-state.json" >> ../.gitignore
   ```

2. **使用环境变量传递凭据**
   ```bash
   agent-browser fill @e1 "$APP_USERNAME"
   agent-browser fill @e2 "$APP_PASSWORD"
   ```

3. **自动化结束后及时清理**
   ```bash
   agent-browser cookies clear
   rm -f ./auth-state.json
   ```

4. **CI/CD 中使用短生命周期会话**
   ```bash
   # CI 环境不持久化状态
   agent-browser open https://app.example.com/login
   # ... 登录并执行动作 ...
   agent-browser close  # 会话结束，不落盘持久化
   ```
