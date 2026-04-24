# 性能分析

在浏览器自动化过程中采集 Chrome DevTools 性能 profile，用于性能分析。

**关联文档**：[commands.md](commands.md)（完整命令参考），[SKILL.md](../SKILL.md)（快速入口）。

## 目录

- 基础采样
- Profiler 命令
- 分类说明
- 使用场景
- 输出格式
- 查看 Profile
- 限制说明

## 基础采样

```bash
# 开始采样
agent-browser profiler start

# 执行动作
agent-browser navigate https://example.com
agent-browser click "#button"
agent-browser wait 1000

# 停止并保存
agent-browser profiler stop ./trace.json
```

## Profiler 命令

```bash
# 使用默认 categories 启动采样
agent-browser profiler start

# 使用自定义 trace categories 启动采样
agent-browser profiler start --categories "devtools.timeline,v8.execute,blink.user_timing"

# 停止采样并保存到文件
agent-browser profiler stop ./trace.json
```

## 分类说明

`--categories` 参数接受逗号分隔的 Chrome trace 分类列表。默认包括：

- `devtools.timeline` -- 标准 DevTools 性能 trace
- `v8.execute` -- JavaScript 执行耗时
- `blink` -- 渲染器事件
- `blink.user_timing` -- `performance.mark()` / `performance.measure()` 调用
- `latencyInfo` -- 输入到延迟链路追踪
- `renderer.scheduler` -- 任务调度与执行
- `toplevel` -- 广谱基础事件

同时包含若干 `disabled-by-default-*` 分类，用于更细粒度的 timeline、调用栈与 V8 CPU 采样数据。

## 使用场景

### 诊断页面加载缓慢

```bash
agent-browser profiler start
agent-browser navigate https://app.example.com
agent-browser wait --load networkidle
agent-browser profiler stop ./page-load-profile.json
```

### 分析用户交互性能

```bash
agent-browser navigate https://app.example.com
agent-browser profiler start
agent-browser click "#submit"
agent-browser wait 2000
agent-browser profiler stop ./interaction-profile.json
```

### CI 性能回归检查

```bash
#!/bin/bash
agent-browser profiler start
agent-browser navigate https://app.example.com
agent-browser wait --load networkidle
agent-browser profiler stop "./profiles/build-${BUILD_ID}.json"
```

## 输出格式

输出是 Chrome Trace Event 格式的 JSON 文件：

```json
{
  "traceEvents": [
    { "cat": "devtools.timeline", "name": "RunTask", "ph": "X", "ts": 12345, "dur": 100, ... },
    ...
  ],
  "metadata": {
    "clock-domain": "LINUX_CLOCK_MONOTONIC"
  }
}
```

`metadata.clock-domain` 字段会按宿主平台（Linux/macOS）设置；Windows 下会省略。

## 查看 Profile

可通过以下工具加载输出 JSON：

- **Chrome DevTools**：Performance panel > Load profile（Ctrl+Shift+I > Performance）
- **Perfetto UI**：https://ui.perfetto.dev/ -- 将 JSON 文件拖入
- **Trace Viewer**：任意 Chromium 浏览器中的 `chrome://tracing`

## 限制说明

- 仅支持 Chromium 内核浏览器（Chrome、Edge），不支持 Firefox/WebKit。
- 采样期间 trace 数据会在内存累积（上限 500 万 events），完成目标区间后应及时停止。
- 停止时的数据采集有 30 秒超时；浏览器无响应时，stop 命令可能失败。
