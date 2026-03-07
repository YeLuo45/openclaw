# 记忆系统 (Memory System) — DDD 模块说明

本 skill 用于在 **Cursor 对话**中归档关键信息，并按 **DDD** 将「对应的信息保存在对应的模块」。**实际记忆数据**存放在**记忆根目录**（默认：当前项目下的 `my_memory`）；本目录（`.cursor/skills/memory-system/`）仅存放 skill 说明与配置。

## 记忆根目录与配置

- **默认记忆根目录**：当前项目根下的 `my_memory`（即 `<项目根>/my_memory`）。
- **配置**：`.cursor/skills/memory-system/config.json` 中的 `memoryRoot` 可覆盖默认值（相对项目根或绝对路径）。
- 所有「记忆」的读写都在该根目录下进行；根目录内使用与下面一致的 DDD 子目录结构。

## 本 skill 目录结构（说明与配置）

```
.cursor/skills/memory-system/
├── SKILL.md              # 本 skill 的说明与记忆命令（Agent 入口）
├── README.md             # 本说明
├── config.json           # 记忆根目录配置（memoryRoot，默认 my_memory）
├── domain/               # 领域层说明（仅文档，不存数据）
├── application/          # 应用层说明（仅文档，不存数据）
└── infrastructure/       # 基础设施层说明（仅文档，不存数据）
```

## 记忆根目录下的 DDD 结构（实际数据）

在 `my_memory/`（或当前配置的 memoryRoot）下保持：

```
<memoryRoot>/
├── domain/               # 领域层：概念、术语、实体（仅文档）
├── application/          # 应用层：决策、会话摘要、索引
└── infrastructure/
    ├── conversations/   # 按会话/日期的归档
    └── topics/          # 按主题/模块的归档
```

## 记忆命令摘要

- **指定记忆目录**：如「记忆目录设为 xxx」→ 更新 `config.json` 的 `memoryRoot`；「当前记忆目录是哪里」→ 展示当前 memoryRoot。
- **展示记忆内容**：如「展示记忆」「列出记忆」「看看 application 的记忆」→ 列出并展示对应目录下的文件与内容摘要。
- **列出记忆**：如「记忆有哪些文件」→ 仅输出目录树或文件列表。
- **写入记忆**：如「记住」「归档」「保存到记忆」→ 按模块写入记忆根目录。

详见 `SKILL.md`。

## 信息与模块对应关系

| 要归档的内容类型 | 建议存放模块 | 路径示例（相对记忆根） |
|------------------|--------------|--------------------------|
| 领域术语、实体定义 | 领域层 | `domain/glossary.md`、`domain/entities.md` |
| 决策、流程、会话摘要、索引 | 应用层 | `application/decisions-YYYY-MM-DD.md`、`application/session-index.md` |
| 完整或摘要会话、按日期的记录 | 基础设施 · 会话 | `infrastructure/conversations/YYYY-MM-DD-*.md` |
| 按主题的片段、配置、代码结论 | 基础设施 · 主题 | `infrastructure/topics/<主题名>.md` |

详细约定见各层目录下的 `README.md` 以及根目录 `SKILL.md`。
