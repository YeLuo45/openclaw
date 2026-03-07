# 术语表（来自前期聊天归档）

**维护日期**：2026-02-13  
**用途**：统一本项目中与记忆系统、OpenClaw、Gateway、ClawHub 相关的术语，便于 application / infrastructure 引用。

| 术语 | 含义 |
|------|------|
| **记忆系统** | 将 Cursor 聊天关键信息按 DDD 模块写入 `my_memory` 的 skill，位于 `.cursor/skills/memory-system/`。 |
| **记忆根目录** | 实际存放记忆的根路径，默认 `<项目根>/my_memory`，由 `.cursor/skills/memory-system/config.json` 的 `memoryRoot` 配置。 |
| **DDD 模块** | 领域层(domain)、应用层(application)、基础设施层(infrastructure/conversations、infrastructure/topics)。 |
| **归档** | 把对话要点或会话内容写入记忆根目录下对应模块的文件。 |
| **OpenClaw** | 本仓库的 AI 助手/网关项目；配置在 `~/.openclaw/openclaw.json`（Windows：`%USERPROFILE%\.openclaw\openclaw.json`）。 |
| **Gateway** | OpenClaw 的网关进程，默认端口 18789；Windows 下可通过计划任务(Scheduled Task)或前台 `gateway run` 运行。 |
| **Control UI / Dashboard** | Gateway 提供的 Web 控制台，根路径 `/` 或配置的 `gateway.controlUi.basePath`；需先 `pnpm ui:build` 构建。 |
| **ClawHub** | OpenClaw 的公共 skill 仓库（https://clawhub.ai）；通过 `clawhub` CLI 搜索、安装、更新 skill。 |
| **Skill** | 以 `SKILL.md` 为核心的能力包，放在 `skills/<name>/`，Gateway 加载后 Agent 可调用。 |
