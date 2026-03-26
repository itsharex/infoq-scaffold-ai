# 项目 MCP Server 说明

本文档说明本仓库使用的项目级 MCP server，配置文件位于 `.codex/config.toml`。

## 1. 配置目标

- 将当前仓库高频需要的 MCP 固化为项目级配置，避免每次本地重复添加。
- 将需要额外软件或凭据的 MCP 标记为待选项，默认不启用。
- 不在仓库中存储任何真实 token、账号或本地私有路径。

## 2. 当前配置总览

| Server | 状态 | 传输方式 | 主要用途 | 是否需要额外配置 |
| --- | --- | --- | --- | --- |
| `playwright` | 已启用 | STDIO | 浏览器自动化、页面流程验证、截图、控制台检查 | 否 |
| `context7` | 已启用 | STDIO | 获取最新版第三方库文档和 API 示例 | 可选 `CONTEXT7_API_KEY` |
| `openai-docs` | 已启用 | HTTP | 查询 OpenAI / Codex / API 官方文档 | 否 |
| `chrome-devtools` | 已启用 | STDIO | 前端调试、Network/Console/Performance 分析 | 否 |
| `figma-desktop` | 待选，默认禁用 | HTTP | 从本地 Figma 桌面端读取设计上下文 | 需要安装 Figma 桌面端并启用本地 MCP |
| `github` | 待选，默认禁用 | HTTP | 读取仓库、PR、Issue、Actions 等 GitHub 上下文 | 需要配置 `GITHUB_MCP_PAT` |

## 3. 每个 MCP 是做什么的

### 3.1 `playwright`

用途：
- 驱动浏览器执行真实页面操作。
- 用于登录、点击、输入、页面跳转、截图、渲染态提取、控制台错误检查。
- 适合做 Vue/React 本地联调后的运行态验证。

为什么本项目需要：
- 本仓库已有前端运行态 skill 明确依赖 Playwright MCP。
- 适合验证 `infoq-scaffold-frontend-vue` 与 `infoq-scaffold-frontend-react` 的 `/login`、路由守卫、表单、截图、console 等场景。

对应仓库 skill：
- `.agents/skills/infoq-vue-browser-automation/SKILL.md`
- `.agents/skills/infoq-react-browser-automation/SKILL.md`
- `.agents/skills/agent-browser/SKILL.md`

配置方式：
- `STDIO`
- `npx @playwright/mcp@latest`

适用场景：
- 页面联调验证
- 截图留档
- 登录后路由验证
- 表单交互验证
- 前端改动后的 smoke 检查

### 3.2 `context7`

用途：
- 为编码代理提供最新、带版本语义的第三方库文档和代码示例。
- 适合查 React、Vue、Vite、Vitest、Element Plus、Ant Design、Spring 生态相关库的最新 API。

为什么本项目需要：
- 本仓库横跨 Spring Boot、MyBatis-Plus、Vue 3、React 19、Vite、Vitest、Element Plus、Ant Design。
- 单靠模型预训练记忆，命中错误 API 或旧版本行为的概率较高。

配置方式：
- `STDIO`
- `npx -y @upstash/context7-mcp@latest`
- 可选透传环境变量：`CONTEXT7_API_KEY`

适用场景：
- 查最新组件 API
- 查库升级后的行为变化
- 查某个版本的官方用法
- 写新页面或修测试时需要快速核对第三方文档

说明：
- `CONTEXT7_API_KEY` 不是必需，但官方建议配置以获得更高的限额。

### 3.3 `openai-docs`

用途：
- 查询 OpenAI 开发者官方文档。
- 适用于 OpenAI API、Responses API、Codex、skills、AGENTS、MCP、subagents 等相关问题。

为什么本项目需要：
- 本仓库本身就包含大量 Codex 规约、skills、AGENTS、subagent 工作流。
- 后续维护这套代理协作体系时，需要一个稳定的 OpenAI 官方文档入口。

配置方式：
- `HTTP`
- `https://developers.openai.com/mcp`

适用场景：
- 查 Codex 配置
- 查 MCP 官方格式
- 查 AGENTS / skills 官方要求
- 查 OpenAI API 或 Responses schema

说明：
- 本仓库把 server 名称写成 `openai-docs`，比官方示例里的 `openaiDeveloperDocs` 更短，便于 agent 选择。

### 3.4 `chrome-devtools`

用途：
- 让代理直接使用 Chrome DevTools 能力。
- 适合查 Network、Console、Performance、Lighthouse、DOM、运行时错误。

为什么本项目需要：
- Playwright 更适合自动化流程。
- Chrome DevTools MCP 更适合前端问题排查和性能分析。
- 对双前端联调、复杂渲染问题、慢页面分析都有价值。

配置方式：
- `STDIO`
- `npx -y chrome-devtools-mcp@latest`

适用场景：
- 看页面报错和 console
- 分析 network 请求
- 跑性能 trace
- 查页面实际 DOM 与渲染状态

说明：
- 默认会由 server 自行拉起浏览器。
- 如果后续需要连接现有 Chrome 实例，可以再扩展 `--autoConnect` 或 `--browser-url` 参数。

连接现有 Chrome 前需要开启的浏览器功能：
- 默认配置下，不需要先改 Chrome 设置，`chrome-devtools-mcp` 会在真正调用浏览器工具时自动拉起一个可调试浏览器实例。
- 如果你希望连接“已经打开的 Chrome”，保留你当前登录态、标签页或本地 profile，则需要先在 Chrome 中开启远程调试能力。

官方推荐步骤：
1. 打开 Chrome 版本 `M144+`。
2. 访问 `chrome://inspect/#remote-debugging`。
3. 在页面中启用 remote debugging。
4. 按 Chrome 弹窗允许或拒绝 incoming debugging connections。

适合什么时候这样做：
- 需要复用你当前已登录的网站会话。
- 需要让 MCP 连接一个已经打开的 Chrome，而不是临时新开浏览器。
- 需要在手动调试和 agent 调试之间共享同一浏览器状态。

可选配置方式 A：自动连接当前运行中的 Chrome
- 将 `chrome-devtools` 的 `args` 改为包含 `--autoConnect`。
- 示例：

```toml
[mcp_servers.chrome-devtools]
command = "npx"
args = ["-y", "chrome-devtools-mcp@latest", "--autoConnect"]
enabled = true
startup_timeout_sec = 20
tool_timeout_sec = 120
```

说明：
- 这种方式要求你先启动 Chrome。
- 如果有多个 profile，server 会连接 Chrome 判定的默认 profile。
- MCP 首次连接时，Chrome 会弹出授权对话框。

可选配置方式 B：显式连接到远程调试端口
- 如果你想精确控制连接目标，可以使用 `--browser-url=http://127.0.0.1:9222`。
- 这种方式要求你用远程调试端口启动 Chrome，并使用非默认 `user-data-dir`。

示例：

```toml
[mcp_servers.chrome-devtools]
command = "npx"
args = ["-y", "chrome-devtools-mcp@latest", "--browser-url=http://127.0.0.1:9222"]
enabled = true
startup_timeout_sec = 20
tool_timeout_sec = 120
```

启动 Chrome 的官方示例：

```bash
/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --user-data-dir=/tmp/chrome-profile-stable
```

补充说明：
- 开启远程调试端口时，不要复用默认浏览器数据目录。
- 如果只是一般页面检查、console、network、performance 分析，保留当前项目里的默认配置就够了，不必额外开启 Chrome 设置。

### 3.5 `figma-desktop`（待选项）

用途：
- 从 Figma 桌面端本地 MCP server 读取设计稿上下文。
- 适合“按设计稿还原页面”、“从 Figma 实现组件”、“联动设计系统”这类任务。

为什么现在是待选项：
- 需要本机安装并运行 Figma 桌面应用。
- 需要在 Figma Dev Mode 中手动启用桌面 MCP server。
- 当前仓库已有双前端实现能力，但不是每次任务都依赖设计稿。

配置方式：
- `HTTP`
- `http://127.0.0.1:3845/mcp`
- 默认 `enabled = false`

启用前提：
1. 安装并更新 Figma desktop app。
2. 打开设计文件，切到 Dev Mode。
3. 在 Figma 中启用 desktop MCP server。
4. 确认本地地址 `http://127.0.0.1:3845/mcp` 可用。
5. 将 `.codex/config.toml` 中的 `enabled = false` 改为 `enabled = true`。

适用场景：
- 设计稿到 Vue 页面
- 设计稿到 React 页面
- 读取 Figma 节点结构、布局、资源信息

### 3.6 `github`（待选项）

用途：
- 让代理直接访问 GitHub 平台能力，而不只是本地 `git`。
- 可用于读仓库文件、PR、Issue、Actions、讨论区、组织信息等。

为什么现在是待选项：
- 需要配置 GitHub Personal Access Token。
- 当前大部分仓库内开发任务仅靠本地文件和 `git` 已够用。
- 只有在 PR / issue / workflow / 远程仓库上下文强依赖时才值得启用。

配置方式：
- `HTTP`
- `https://api.githubcopilot.com/mcp/`
- 使用 `bearer_token_env_var = "GITHUB_MCP_PAT"`
- 默认 `enabled = false`

启用前提：
1. 创建 GitHub PAT。
2. 在本机环境变量中导出 token，例如：

```bash
export GITHUB_MCP_PAT=your_personal_access_token
```

3. 将 `.codex/config.toml` 中的 `enabled = false` 改为 `enabled = true`。

适用场景：
- 读取远程 PR / Issue / Actions
- 需要 GitHub 平台上下文的自动化任务
- 需要跨仓库读取 GitHub 远程信息

安全要求：
- 不要把真实 token 写进仓库。
- 建议使用最小权限 PAT。

## 4. 为什么是这 6 个

项目当前最强相关的需求有三类：

### 4.1 前端运行态验证

对应 MCP：
- `playwright`
- `chrome-devtools`

原因：
- 仓库有两个前端工作区，并且已有本地浏览器自动化 skill。
- 一个负责流程自动化，一个负责调试与性能分析，能力互补。

### 4.2 最新外部文档检索

对应 MCP：
- `context7`
- `openai-docs`

原因：
- `context7` 解决第三方开发库文档问题。
- `openai-docs` 解决 Codex / OpenAI 官方文档问题。

### 4.3 设计稿和远程协作上下文

对应 MCP：
- `figma-desktop`
- `github`

原因：
- 这两类场景不是每次开发都需要，但一旦需要就很有价值。
- 由于依赖额外软件或凭据，所以默认不启用，只保留待选配置。

## 5. 当前项目配置内容

当前 `.codex/config.toml` 中已包含：

- 已启用：`playwright`、`context7`、`openai-docs`、`chrome-devtools`
- 已预留但默认禁用：`figma-desktop`、`github`

这意味着：
- 普通代码和联调任务可以直接使用前四个 MCP。
- 设计稿或 GitHub 平台协作需求出现时，只需补齐本地条件并启用对应 server。

## 6. 后续维护建议

- 新增 MCP 前，先确认它是否真的被当前仓库 workflow 使用。
- 需要账号、token、桌面客户端、浏览器远程调试之类前置条件的 MCP，一律默认禁用。
- 项目级 `.codex/config.toml` 只保留“仓库公共需要”的 MCP，不把个人临时 server 混进来。
- 不要在配置文件里写死任何真实密钥。

## 7. 参考来源

- OpenAI Codex MCP 官方文档: https://developers.openai.com/codex/mcp
- OpenAI Docs MCP 官方文档: https://developers.openai.com/learn/docs-mcp
- Playwright MCP 官方仓库: https://github.com/microsoft/playwright-mcp
- Chrome DevTools MCP 官方仓库: https://github.com/ChromeDevTools/chrome-devtools-mcp
- Context7 官方页面: https://context7.com/upstash/context7
- Context7 MCP Registry 页面: https://github.com/mcp/io.github.upstash/context7
- Figma Desktop MCP 官方文档: https://developers.figma.com/docs/figma-mcp-server/local-server-installation/
- GitHub 官方 MCP Server 仓库: https://github.com/github/github-mcp-server
