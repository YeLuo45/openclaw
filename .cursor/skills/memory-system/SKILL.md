---
name: memory-system
description: 记忆系统 - 将 Cursor 聊天归档到项目 my_memory（可配置），按 DDD 模块存储；支持指定记忆目录、展示记忆内容等命令
metadata: { "openclaw": { "emoji": "🧠" } }
---

# 记忆系统 (Memory System)

将当前 Cursor 对话中的**关键信息、结论、决策与代码片段**归档到**记忆根目录**下，按 **DDD** 划分的模块存放。**默认记忆根目录**为当前项目下的 `my_memory`，可通过命令或配置文件修改。

## 记忆根目录

- **默认**：当前项目根目录下的 `my_memory`（即 `<项目根>/my_memory`）。
- **配置**：读取 `.cursor/skills/memory-system/config.json` 中的 `memoryRoot`（相对项目根或绝对路径）；若文件不存在或未配置，使用 `my_memory`。
- 所有「记忆」的读写均相对于该根目录；根目录下沿用 DDD 子目录：`domain/`、`application/`、`infrastructure/conversations/`、`infrastructure/topics/`。

---

## 记忆命令

用户说出以下意图时，按对应方式执行。

### 1. 指定记忆目录

| 用户说法示例 | 行为 |
|--------------|------|
| 「记忆目录设为 xxx」「用 yy 作为记忆根目录」「记忆放到 yy」 | 将记忆根目录设为 `xxx`/`yy`（相对项目根）。更新 `.cursor/skills/memory-system/config.json` 的 `memoryRoot` 为该项目内路径，并确认后续读写均使用该目录。 |
| 「当前记忆目录是哪里」「记忆存在哪」 | 读取 config.json 的 `memoryRoot`，若不存在则回答「当前记忆目录：项目根下的 my_memory」。 |

### 2. 展示记忆内容

| 用户说法示例 | 行为 |
|--------------|------|
| 「展示记忆」「列出记忆」「看看记忆里有什么」「记忆内容」 | 列出记忆根目录下的结构（domain、application、infrastructure/conversations、infrastructure/topics），并列出各目录下的文件；对 Markdown 等文本文件可展示摘要或前几行，便于用户浏览。 |
| 「展示 application 的记忆」「只看 topics 下的记忆」 | 仅列出并展示指定子模块下的文件与内容摘要。 |
| 「展示 xxx 这篇记忆」「打开记忆文件 xxx」 | 读取并展示记忆根目录下某文件的完整内容（按相对路径查找）。 |

### 3. 列出记忆（仅目录/文件列表）

| 用户说法示例 | 行为 |
|--------------|------|
| 「列出记忆目录」「记忆有哪些文件」 | 仅输出记忆根目录的目录树或文件列表，不展开文件内容。 |
| 「列出最近存的记忆」 | 可按修改时间列出 infrastructure/conversations 与 application 下的最近文件。 |

### 4. 写入记忆（归档）

| 用户说法示例 | 行为 |
|--------------|------|
| 「记住」「归档」「保存到记忆」「把这段存进记忆」 | 按下方「模块与存储路径」将用户指定或当前对话中的关键信息写入对应模块；若未指定模块，由 Agent 根据内容类型选择 domain/application/infrastructure。 |

---

## 何时使用（触发场景）

- 用户调用上述**记忆命令**（指定目录、展示、列出、写入）。
- 用户明确要求「记住」「归档」「保存到记忆」「写入记忆系统」。
- 对话产生重要结论、配置、代码片段或决策，用户希望持久化。
- 用户说「把这段对话要点存进记忆」「按模块保存」或会话结束前做小结并归档。

**主动归档（必做）：** 当本次对话已产生**可复用结论**（如：配置步骤、问题排查结果、安装/命令记录、决策）时，**在回复结束前主动执行一次归档**：将要点写入 `application/` 或 `infrastructure/conversations/` / `infrastructure/topics/`，无需等用户说「归档」。若用户未明确要求「保存会话全文」，可写摘要而非全文。

**为何部分会话未出现在 my_memory：** 只有以下情况会写入：① 用户说了「记住/归档/保存到记忆」等；② Agent 按上条**主动归档**了当次对话要点。若某次聊天既无用户归档指令、Agent 也未主动归档，则该次不会留下记录。若希望某次对话被记下，可说「把这段对话归档」或使用 `/` 选择「记忆：写入/归档」。

## 模块与存储路径（DDD 划分）

所有路径均相对于**当前记忆根目录**（默认 `my_memory`）。

| 模块 | 相对路径 | 存放内容 |
|------|----------|----------|
| **领域层** | `domain/` | 领域概念说明、术语表、实体与值对象定义（文档形式） |
| **应用层** | `application/` | 用例与流程记录、决策日志、会话摘要索引 |
| **基础设施层** | `infrastructure/conversations/` | 按日期或会话的完整或摘要归档 |
| **基础设施层** | `infrastructure/topics/` | 按主题/功能模块的片段与结论 |

### 具体存放约定

1. **domain/**  
   - 仅放 Markdown 文档，描述本项目的领域概念、实体、值对象。  
   - 例如：`domain/glossary.md`、`domain/entities.md`。

2. **application/**  
   - 会话级摘要、决策记录、用例执行记录。  
   - 建议文件名带日期或会话标识，如：`application/decisions-2026-02-12.md`、`application/session-index.md`。

3. **infrastructure/**  
   - **conversations/**：按日期或会话 ID 的完整或摘要归档。  
   - **topics/**：按主题/功能模块分类的片段与结论。  
   - 格式建议：Markdown 或 JSON，便于检索。

## 操作步骤（写入记忆时）

1. **解析记忆根目录**：读取 `.cursor/skills/memory-system/config.json` 的 `memoryRoot`，缺省为 `my_memory`；路径相对项目根解析。
2. **选择目标模块**：领域概念、术语 → `domain/`；决策、流程、会话摘要 → `application/`；具体会话或按主题片段 → `infrastructure/conversations/` 或 `infrastructure/topics/`。
3. **写入文件**：在记忆根目录下的对应路径创建或追加文件；内容含日期、会话上下文或主题。
4. **可选**：在 `application/session-index.md` 维护简要索引。

## 示例

- 用户：「记忆目录设为 my_memory」→ 确保 config.json 中 `memoryRoot` 为 `my_memory`（已是默认可仅确认）。
- 用户：「展示记忆」→ 列出 `my_memory/domain`、`my_memory/application`、`my_memory/infrastructure/conversations`、`my_memory/infrastructure/topics` 下文件并展示摘要。
- 用户：「把今天关于 QQ 通道配置的结论记下来。」→ 写入 `my_memory/infrastructure/topics/qq-channel-config.md` 或 `my_memory/application/decisions-2026-02-12.md`。

## 依赖与约束

- 记忆数据仅写入**记忆根目录**（默认 `my_memory`）；配置仅写入 `.cursor/skills/memory-system/config.json`。不修改项目其他代码或配置，除非用户明确要求。
- 文件编码使用 UTF-8；若为 JSON，保持合法格式。
- 不归档敏感信息（密钥、密码、个人身份信息）；若必须提及，用占位符并说明存放位置由用户自行管理。

## 注意

- 归档前可简要总结「将要写入的模块与文件名」，待用户确认后再写入，避免覆盖已有重要内容。
- 同一主题多次归档时，优先追加到已有文件并在文首注明日期与来源会话，或按日期新建文件。
