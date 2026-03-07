# 记忆：写入/归档

执行记忆系统的「写入记忆」命令，将当前对话中的关键信息归档到记忆根目录下，按 DDD 模块存放。

1. 解析记忆根目录：读取 `.cursor/skills/memory-system/config.json` 的 `memoryRoot`，缺省为 `my_memory`（相对项目根）。若目录不存在则创建（含 domain、application、infrastructure/conversations、infrastructure/topics）。

2. 根据要归档的内容类型选择模块：
   - 领域概念、术语、实体定义 → `domain/`（如 domain/glossary.md、domain/entities.md）
   - 决策、流程、会话摘要、索引 → `application/`（如 application/decisions-YYYY-MM-DD.md、application/session-index.md）
   - 按日期或会话的完整/摘要归档 → `infrastructure/conversations/`
   - 按主题的片段、配置、代码结论 → `infrastructure/topics/`（如 infrastructure/topics/主题名.md）

3. 在对应路径下创建或追加文件；内容需自解释（含日期、会话上下文或主题）。同一主题多次归档时优先追加到已有文件，文首注明日期与来源。

4. 可选：在 `application/session-index.md` 中维护简要索引（日期、主题、文件路径）。

5. 不归档敏感信息（密钥、密码、个人身份信息）；若必须提及，用占位符并说明由用户自行管理。归档前可简要总结将要写入的模块与文件名，待用户确认后再写入。

若用户未明确指定「要归档的内容」，则归纳当前对话中的关键结论、配置或代码片段，并写入合适模块；必要时先列出计划再执行。
