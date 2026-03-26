# Codex Subagent Roadmap

## Phase 1

目标：先完成仓库内 Codex 协作能力闭环。

范围：

- `.codex/config.toml` 中的 subagent 全局配置
- `.codex/agents/` 自定义专家定义
- `doc/agents/` 模板体系
- `doc/plan/` 真实任务文档落点
- `infoq-subagent-delivery` skill 统一入口
- `AGENTS.md` 路由规则

不在本期范围：

- 业务系统页面中可视化创建/执行/追踪 agent 任务
- 业务系统 API 化的任务编排、持久化和任务中心

## Phase 2

目标：把仓库内 subagent 协作能力外放到业务系统中，以页面/API 方式触发。

建议拆分：

1. 任务创建接口
2. 任务状态流转与运行记录
3. 文档产物归档与查看
4. 手动重试、人工接管、再次验收
5. 页面化查看 `PRD / DESIGN / TRS / MATERIAL / DELIVERY`

前置条件：

- Phase 1 的仓库内流程已经稳定
- 文档模板与命名规范已经定稿
- 至少有一轮真实需求闭环可复用
