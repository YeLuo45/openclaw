# 会话归档索引

## 按模块查看（DDD）

| 模块 | 路径 | 文件与说明 |
|------|------|------------|
| **领域层** | `domain/` | `glossary.md` — 术语表（记忆系统、OpenClaw、Gateway、ClawHub、Skill 等） |
| **应用层** | `application/` | `model-priority-2026-02-12.md` — 模型优先级配置；`decisions-and-workflows.md` — 决策与流程汇总；`session-index.md` — 本索引 |
| **基础设施·会话** | `infrastructure/conversations/` | `2026-02-12-cursor-commands-and-session-archive.md` — 记忆命令与会话归档；`2026-02-13-later-sessions-archive.md` — 后续多轮补档 |
| **基础设施·主题** | `infrastructure/topics/` | `openclaw-model-config.md` — 模型配置；`gateway-windows-dashboard.md` — Gateway 与 Dashboard；`memory-system-and-cursor-commands.md` — 记忆系统与命令；`clawhub-skills-install-2026-02-12.md` — ClawHub 技能安装 |

## 按时间倒序（会话级）

| 日期 | 主题 | 存放位置 |
|------|------|----------|
| 2026-02-13 | 后续多轮会话补档：Gateway、Dashboard、模型、技能、记忆未记录原因 | `infrastructure/conversations/2026-02-13-later-sessions-archive.md` |
| 2026-02-12 | ClawHub 技能安装（web-scraper、wechat 未装、命令说明） | `infrastructure/topics/clawhub-skills-install-2026-02-12.md` |
| 2026-02-12 | OpenClaw 模型优先级（primary + fallbacks，config 编辑方式） | `application/model-priority-2026-02-12.md` |
| 2026-02-12 | 记忆命令生成到 .cursor/commands + 该会话全文归档 | `infrastructure/conversations/2026-02-12-cursor-commands-and-session-archive.md` |

**说明：** 只有「用户明确要求归档」或「Agent 主动归档当次要点」的会话会写入 my_memory。若希望某次对话被记录，可说「把这段对话归档」或使用命令「记忆：写入/归档」。
