# Snapshot 与 Refs

为 AI agent 提供紧凑元素引用，可显著降低上下文消耗。

**关联文档**：[commands.md](commands.md)（完整命令参考），[SKILL.md](../SKILL.md)（快速入口）。

## 目录

- Refs 工作原理
- Snapshot 命令
- 使用 Refs
- Ref 生命周期
- 最佳实践
- Ref 标记细节
- 故障排查

## Refs 工作原理

传统方式：
```
Full DOM/HTML → AI parses → CSS selector → Action (~3000-5000 tokens)
```

agent-browser 方式：
```
Compact snapshot → @refs assigned → Direct interaction (~200-400 tokens)
```

## Snapshot 命令

```bash
# 基础 snapshot（展示页面结构）
agent-browser snapshot

# 交互 snapshot（-i 参数，推荐）
agent-browser snapshot -i
```

### Snapshot 输出格式

```
Page: Example Site - Home
URL: https://example.com

@e1 [header]
  @e2 [nav]
    @e3 [a] "Home"
    @e4 [a] "Products"
    @e5 [a] "About"
  @e6 [button] "Sign In"

@e7 [main]
  @e8 [h1] "Welcome"
  @e9 [form]
    @e10 [input type="email"] placeholder="Email"
    @e11 [input type="password"] placeholder="Password"
    @e12 [button type="submit"] "Log In"

@e13 [footer]
  @e14 [a] "Privacy Policy"
```

## 使用 Refs

获取 refs 后可直接交互：

```bash
# 点击 "Sign In" 按钮
agent-browser click @e6

# 填写邮箱输入框
agent-browser fill @e10 "user@example.com"

# 填写密码
agent-browser fill @e11 "password123"

# 提交表单
agent-browser click @e12
```

## Ref 生命周期

**重要**：页面发生变化后，旧 refs 会失效。

```bash
# 获取初始 snapshot
agent-browser snapshot -i
# @e1 [button] "Next"

# 点击后页面变化
agent-browser click @e1

# 必须重新 snapshot 获取新 refs！
agent-browser snapshot -i
# @e1 [h1] "Page 2"  ← Different element now!
```

## 最佳实践

### 1. 交互前始终先 snapshot

```bash
# 正确示例
agent-browser open https://example.com
agent-browser snapshot -i          # 先获取 refs
agent-browser click @e1            # 使用 ref

# 错误示例
agent-browser open https://example.com
agent-browser click @e1            # 此时 ref 尚不存在
```

### 2. 导航后重新 snapshot

```bash
agent-browser click @e5            # 导航到新页面
agent-browser snapshot -i          # 获取新 refs
agent-browser click @e1            # 使用新 refs
```

### 3. 动态变化后重新 snapshot

```bash
agent-browser click @e1            # 打开下拉
agent-browser snapshot -i          # 查看下拉项 refs
agent-browser click @e7            # 选择项
```

### 4. 对特定区域 snapshot

复杂页面可只 snapshot 特定区域：

```bash
# 仅扫描表单区域
agent-browser snapshot @e9
```

## Ref 标记细节

```
@e1 [tag type="value"] "text content" placeholder="hint"
│    │   │             │               │
│    │   │             │               └─ Additional attributes
│    │   │             └─ Visible text
│    │   └─ Key attributes shown
│    └─ HTML tag name
└─ Unique ref ID
```

### 常见模式

```
@e1 [button] "Submit"                    # 含文本按钮
@e2 [input type="email"]                 # 邮箱输入框
@e3 [input type="password"]              # 密码输入框
@e4 [a href="/page"] "Link Text"         # 链接
@e5 [select]                             # 下拉框
@e6 [textarea] placeholder="Message"     # 文本域
@e7 [div class="modal"]                  # 容器（有语义时）
@e8 [img alt="Logo"]                     # 图片
@e9 [checkbox] checked                   # 已勾选复选框
@e10 [radio] selected                    # 已选中单选项
```

## 故障排查

### “Ref not found” 错误

```bash
# ref 可能已变化，重新 snapshot
agent-browser snapshot -i
```

### 元素未在 Snapshot 中显示

```bash
# 先滚动使元素进入可视区
agent-browser scroll down 1000
agent-browser snapshot -i

# 或等待动态内容加载
agent-browser wait 1000
agent-browser snapshot -i
```

### 元素过多

```bash
# 仅 snapshot 指定容器
agent-browser snapshot @e5

# 或使用 get text 仅提取文本
agent-browser get text @e5
```
