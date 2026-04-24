---
name: infoq-browser-automation
description: 本仓库通用浏览器自动化技能。凡涉及网页交互或浏览器状态验证（打开页面、填表、点击、登录、截图、抓取渲染内容、检查控制台错误、验证 Web 流程）均应使用，即使用户未显式提及“浏览器自动化”。执行后端为 `agent-browser` CLI。
allowed-tools: Bash(npx agent-browser:*), Bash(agent-browser:*)
---

# InfoQ 浏览器自动化

将 `infoq-browser-automation` 作为本仓库真实浏览器交互的默认技能。
执行后端仍是 `agent-browser` CLI，但仓库技能名遵循本地 `infoq-` 命名约定。
它依赖 `agent-browser` CLI 和本地 Playwright 兼容浏览器运行时。若需要自定义浏览器二进制或持久化会话，请使用文档化参数，避免临时 shell 绕行。

## 快速路径

大多数任务应遵循以下顺序：

1. 打开目标页面。
2. 等待加载完成或稳定元素出现。
3. 获取可交互元素快照。
4. 使用 `@e` 引用或语义定位器进行交互。
5. 导航或 DOM 变化后重新快照。
6. 采集结果：文本、截图、PDF、控制台信息或错误。

基线流程：

```bash
agent-browser open https://example.com
agent-browser wait --load networkidle
agent-browser snapshot -i
```

然后基于返回的 refs 执行交互：

```bash
agent-browser fill @e1 "user@example.com"
agent-browser fill @e2 "password123"
agent-browser click @e3
agent-browser wait --load networkidle
agent-browser snapshot -i
```

## 核心规则

- 任意导航、弹窗打开、DOM 刷新或重大前端重渲染后，都要重新快照。
- 常规流程优先 `snapshot -i`；当 ref 列表缺少可点击容器时，使用 `snapshot -i -C`。
- 当 refs 不稳定时，优先使用 `find role`、`find text`、`find label`、`find placeholder` 等语义定位器。
- 优先使用 `wait --load networkidle`、`wait --url` 或 `wait <selector>`，避免盲等。
- 优先使用保存的认证状态或 `auth` 命令，避免在 shell 历史暴露明文密码。
- 修改 `--executable-path`、`--session-name`、有头/无头模式等运行参数时，先关闭浏览器，再用新参数重启。

## 引用加载指引

只加载当前任务所需的文档。

- 完整命令面与参数：`references/commands.md`
- ref 生命周期与定位稳定性：`references/snapshot-refs.md`
- 登录流程与凭证处理：`references/authentication.md`
- 会话、cookies、存储与清理：`references/session-management.md`
- trace、性能分析、控制台与错误：`references/profiling.md`
- 代理与自定义浏览器配置：`references/proxy-support.md`
- 录屏流程：`references/video-recording.md`

## 资产

- `assets/templates/authenticated-session.sh`
- `assets/templates/capture-workflow.sh`
- `assets/templates/form-automation.sh`

## 护栏

- 将 `eval` 视为末端工具（用于检查或状态注入），而不是默认交互方式。
- 若 shell 转义变脆弱，改用 `eval --stdin` 或专用模板/参考流程，不要强行叠加嵌套引号。
- 当任务对视觉效果或时序敏感时，使用 `--headed`、标注截图、trace 或 profiler 输出。
