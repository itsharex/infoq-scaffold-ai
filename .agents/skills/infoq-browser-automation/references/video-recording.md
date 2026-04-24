# 录屏

将浏览器自动化过程录制为视频，用于调试、文档与验证留档。

**关联文档**：[commands.md](commands.md)（完整命令参考），[SKILL.md](../SKILL.md)（快速入口）。

## 目录

- 基础录制
- 录制命令
- 使用场景
- 最佳实践
- 输出格式
- 限制说明

## 基础录制

```bash
# 开始录制
agent-browser record start ./demo.webm

# 执行动作
agent-browser open https://example.com
agent-browser snapshot -i
agent-browser click @e1
agent-browser fill @e2 "test input"

# 停止并保存
agent-browser record stop
```

## 录制命令

```bash
# 开始录制到文件
agent-browser record start ./output.webm

# 停止当前录制
agent-browser record stop

# 使用新文件重启录制（先停当前，再开启新录制）
agent-browser record restart ./take2.webm
```

## 使用场景

### 调试自动化失败

```bash
#!/bin/bash
# 录制自动化过程用于调试

agent-browser record start ./debug-$(date +%Y%m%d-%H%M%S).webm

# 执行自动化步骤
agent-browser open https://app.example.com
agent-browser snapshot -i
agent-browser click @e1 || {
    echo "点击失败，请检查录屏"
    agent-browser record stop
    exit 1
}

agent-browser record stop
```

### 文档素材生成

```bash
#!/bin/bash
# 录制流程用于文档素材

agent-browser record start ./docs/how-to-login.webm

agent-browser open https://app.example.com/login
agent-browser wait 1000  # 停顿便于观看

agent-browser snapshot -i
agent-browser fill @e1 "demo@example.com"
agent-browser wait 500

agent-browser fill @e2 "password"
agent-browser wait 500

agent-browser click @e3
agent-browser wait --load networkidle
agent-browser wait 1000  # 展示结果

agent-browser record stop
```

### CI/CD 测试证据

```bash
#!/bin/bash
# 录制 E2E 测试过程，作为 CI 产物

TEST_NAME="${1:-e2e-test}"
RECORDING_DIR="./test-recordings"
mkdir -p "$RECORDING_DIR"

agent-browser record start "$RECORDING_DIR/$TEST_NAME-$(date +%s).webm"

# 执行测试
if run_e2e_test; then
    echo "测试通过"
else
    echo "测试失败，已保存录屏"
fi

agent-browser record stop
```

## 最佳实践

### 1. 为可读性增加停顿

```bash
# 降速便于人工回看
agent-browser click @e1
agent-browser wait 500  # 让观看者看清结果
```

### 2. 使用可读文件名

```bash
# 文件名带上上下文信息
agent-browser record start ./recordings/login-flow-2024-01-15.webm
agent-browser record start ./recordings/checkout-test-run-42.webm
```

### 3. 在错误场景处理录制

```bash
#!/bin/bash
set -e

cleanup() {
    agent-browser record stop 2>/dev/null || true
    agent-browser close 2>/dev/null || true
}
trap cleanup EXIT

agent-browser record start ./automation.webm
# ... automation steps ...
```

### 4. 与截图结合使用

```bash
# 同时录视频并截关键帧
agent-browser record start ./flow.webm

agent-browser open https://example.com
agent-browser screenshot ./screenshots/step1-homepage.png

agent-browser click @e1
agent-browser screenshot ./screenshots/step2-after-click.png

agent-browser record stop
```

## 输出格式

- 默认格式：WebM（VP8/VP9 编码）
- 兼容主流浏览器与视频播放器
- 压缩率高且画质可用

## 限制说明

- 录屏会给自动化流程增加少量开销
- 长时间录制可能占用较多磁盘空间
- 部分 headless 环境可能存在编解码限制
