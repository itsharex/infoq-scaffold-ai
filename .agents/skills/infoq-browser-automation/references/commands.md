# 命令参考

本文件提供 `agent-browser` 全量命令参考。快速入门与常见流程请先看 `SKILL.md`。

## 目录

- 导航
- Snapshot（页面分析）
- 交互（使用 snapshot 的 @refs）
- 获取信息
- 检查状态
- 截图与 PDF
- 录屏
- 等待
- 鼠标控制
- 语义定位器（refs 替代方案）
- 浏览器设置
- Cookies 与存储
- 网络
- 标签页与窗口
- Frame（帧上下文）
- 对话框
- JavaScript
- 状态管理
- 全局选项
- 调试
- 环境变量

## 导航

```bash
agent-browser open <url>      # 打开 URL（别名：goto, navigate）
                              # 支持：https://, http://, file://, about:, data://
                              # 若未提供协议，会自动补全 https://
agent-browser back            # 后退
agent-browser forward         # 前进
agent-browser reload          # 刷新页面
agent-browser close           # 关闭浏览器（别名：quit, exit）
agent-browser connect 9222    # 通过 CDP 端口连接浏览器
```

## Snapshot（页面分析）

```bash
agent-browser snapshot            # 完整可访问性树
agent-browser snapshot -i         # 仅交互元素（推荐）
agent-browser snapshot -c         # 紧凑输出
agent-browser snapshot -d 3       # 深度限制为 3
agent-browser snapshot -s "#main" # 仅扫描指定 CSS 选择器范围
```

## 交互（使用 snapshot 的 @refs）

```bash
agent-browser click @e1           # 单击
agent-browser click @e1 --new-tab # 单击并在新标签页打开
agent-browser dblclick @e1        # 双击
agent-browser focus @e1           # 聚焦元素
agent-browser fill @e2 "text"     # 清空并输入
agent-browser type @e2 "text"     # 不清空直接输入
agent-browser press Enter         # 按键（别名：key）
agent-browser press Control+a     # 组合键
agent-browser keydown Shift       # 按住按键
agent-browser keyup Shift         # 释放按键
agent-browser hover @e1           # 悬停
agent-browser check @e1           # 勾选复选框
agent-browser uncheck @e1         # 取消勾选复选框
agent-browser select @e1 "value"  # 选择下拉项
agent-browser select @e1 "a" "b"  # 选择多个下拉项
agent-browser scroll down 500     # 滚动页面（默认：向下 300px）
agent-browser scrollintoview @e1  # 滚动到元素可见（别名：scrollinto）
agent-browser drag @e1 @e2        # 拖拽
agent-browser upload @e1 file.pdf # 上传文件
```

## 获取信息

```bash
agent-browser get text @e1        # 获取元素文本
agent-browser get html @e1        # 获取 innerHTML
agent-browser get value @e1       # 获取输入值
agent-browser get attr @e1 href   # 获取属性
agent-browser get title           # 获取页面标题
agent-browser get url             # 获取当前 URL
agent-browser get count ".item"   # 统计匹配元素数量
agent-browser get box @e1         # 获取边界框
agent-browser get styles @e1      # 获取计算样式（字体、颜色、背景等）
```

## 检查状态

```bash
agent-browser is visible @e1      # 检查是否可见
agent-browser is enabled @e1      # 检查是否可用
agent-browser is checked @e1      # 检查是否已勾选
```

## 截图与 PDF

```bash
agent-browser screenshot          # 保存到临时目录
agent-browser screenshot path.png # 保存到指定路径
agent-browser screenshot --full   # 整页截图
agent-browser pdf output.pdf      # 导出 PDF
```

## 录屏

```bash
agent-browser record start ./demo.webm    # 开始录制
agent-browser click @e1                   # 执行动作
agent-browser record stop                 # 停止并保存视频
agent-browser record restart ./take2.webm # 停止当前并开始新录制
```

## 等待

```bash
agent-browser wait @e1                     # 等待元素出现
agent-browser wait 2000                    # 等待毫秒数
agent-browser wait --text "Success"        # 等待文本（或 -t）
agent-browser wait --url "**/dashboard"    # 等待 URL 模式（或 -u）
agent-browser wait --load networkidle      # 等待网络空闲（或 -l）
agent-browser wait --fn "window.ready"     # 等待 JS 条件（或 -f）
```

## 鼠标控制

```bash
agent-browser mouse move 100 200      # 移动鼠标
agent-browser mouse down left         # 按下按键
agent-browser mouse up left           # 释放按键
agent-browser mouse wheel 100         # 滚轮滚动
```

## 语义定位器（refs 替代方案）

```bash
agent-browser find role button click --name "Submit"
agent-browser find text "Sign In" click
agent-browser find text "Sign In" click --exact      # 仅精确匹配
agent-browser find label "Email" fill "user@test.com"
agent-browser find placeholder "Search" type "query"
agent-browser find alt "Logo" click
agent-browser find title "Close" click
agent-browser find testid "submit-btn" click
agent-browser find first ".item" click
agent-browser find last ".item" click
agent-browser find nth 2 "a" hover
```

## 浏览器设置

```bash
agent-browser set viewport 1920 1080          # 设置视口大小
agent-browser set viewport 1920 1080 2        # 2x retina（CSS 尺寸不变，截图更清晰）
agent-browser set device "iPhone 14"          # 设备模拟
agent-browser set geo 37.7749 -122.4194       # 设置地理位置（别名：geolocation）
agent-browser set offline on                  # 切换离线模式
agent-browser set headers '{"X-Key":"v"}'     # 追加 HTTP 请求头
agent-browser set credentials user pass       # HTTP basic auth（别名：auth）
agent-browser set media dark                  # 模拟深色模式
agent-browser set media light reduced-motion  # 浅色模式 + 减少动效
```

## Cookies 与存储

```bash
agent-browser cookies                     # 获取全部 cookies
agent-browser cookies set name value      # 设置 cookie
agent-browser cookies clear               # 清空 cookies
agent-browser storage local               # 获取全部 localStorage
agent-browser storage local key           # 获取指定 key
agent-browser storage local set k v       # 设置值
agent-browser storage local clear         # 全部清空
```

## 网络

```bash
agent-browser network route <url>              # 拦截请求
agent-browser network route <url> --abort      # 阻断请求
agent-browser network route <url> --body '{}'  # Mock 响应
agent-browser network unroute [url]            # 移除路由规则
agent-browser network requests                 # 查看已跟踪请求
agent-browser network requests --filter api    # 按条件过滤请求
```

## 标签页与窗口

```bash
agent-browser tab                 # 列出标签页
agent-browser tab new [url]       # 新建标签页
agent-browser tab 2               # 按索引切换标签页
agent-browser tab close           # 关闭当前标签页
agent-browser tab close 2         # 按索引关闭标签页
agent-browser window new          # 新建窗口
```

## Frame（框架上下文）

```bash
agent-browser frame "#iframe"     # 切换到 iframe
agent-browser frame main          # 回到主 frame
```

## 对话框

```bash
agent-browser dialog accept [text]  # 接受对话框
agent-browser dialog dismiss        # 关闭对话框
```

## JavaScript

```bash
agent-browser eval "document.title"          # 仅简单表达式
agent-browser eval -b "<base64>"             # 任意 JavaScript（base64 编码）
agent-browser eval --stdin                   # 从 stdin 读取脚本
```

推荐使用 `-b`/`--base64` 或 `--stdin` 以保证执行稳定。带嵌套引号与特殊字符的 shell 转义很容易出错。

```bash
# 先把脚本做 Base64 编码，然后：
agent-browser eval -b "ZG9jdW1lbnQucXVlcnlTZWxlY3RvcignW3NyYyo9Il9uZXh0Il0nKQ=="

# 或使用 stdin + heredoc 执行多行脚本：
cat <<'EOF' | agent-browser eval --stdin
const links = document.querySelectorAll('a');
Array.from(links).map(a => a.href);
EOF
```

## 状态管理

```bash
agent-browser state save auth.json    # 保存 cookies、storage、鉴权状态
agent-browser state load auth.json    # 恢复保存状态
```

## 全局选项

```bash
agent-browser --session <name> ...    # 隔离浏览器会话
agent-browser --json ...              # 输出 JSON（便于解析）
agent-browser --headed ...            # 显示浏览器窗口（非 headless）
agent-browser --full ...              # 整页截图（-f）
agent-browser --cdp <port> ...        # 通过 Chrome DevTools Protocol 连接
agent-browser -p <provider> ...       # 云浏览器 provider（--provider）
agent-browser --proxy <url> ...       # 使用代理服务器
agent-browser --proxy-bypass <hosts>  # 代理绕过主机
agent-browser --headers <json> ...    # 按 URL origin 作用域附加 HTTP headers
agent-browser --executable-path <p>   # 自定义浏览器可执行文件路径
agent-browser --extension <path> ...  # 加载浏览器扩展（可重复）
agent-browser --ignore-https-errors   # 忽略 SSL 证书错误
agent-browser --help                  # 查看帮助（-h）
agent-browser --version               # 查看版本（-V）
agent-browser <command> --help        # 查看子命令详细帮助
```

## 调试

```bash
agent-browser --headed open example.com   # 显示浏览器窗口
agent-browser --cdp 9222 snapshot         # 通过 CDP 端口连接
agent-browser connect 9222                # 等价连接命令
agent-browser console                     # 查看控制台消息
agent-browser console --clear             # 清空控制台消息
agent-browser errors                      # 查看页面错误
agent-browser errors --clear              # 清空页面错误
agent-browser highlight @e1               # 高亮元素
agent-browser trace start                 # 开始录制 trace
agent-browser trace stop trace.zip        # 停止并保存 trace
agent-browser profiler start              # 启动 Chrome DevTools 性能采样
agent-browser profiler stop trace.json    # 停止并保存 profile
```

## 环境变量

```bash
AGENT_BROWSER_SESSION="mysession"            # 默认会话名
AGENT_BROWSER_EXECUTABLE_PATH="/path/chrome" # 自定义浏览器路径
AGENT_BROWSER_EXTENSIONS="/ext1,/ext2"       # 逗号分隔的扩展路径
AGENT_BROWSER_PROVIDER="browserbase"         # 云浏览器 provider
AGENT_BROWSER_STREAM_PORT="9223"             # WebSocket 流式端口
AGENT_BROWSER_HOME="/path/to/agent-browser"  # 自定义安装位置
```
