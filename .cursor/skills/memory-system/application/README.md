# 应用层 (Application)

本目录存放**用例、决策与会话级摘要**，作为检索入口与索引。

## 用途

- **决策记录**：重要技术或产品决策（格式：日期、背景、结论、相关文件）。
- **会话摘要**：某次或某段对话的要点摘要，便于后续「回忆」。
- **索引**：指向 infrastructure 中具体归档文件的索引（如 `session-index.md`），按日期或主题列出。

## 文件约定

- 建议文件名带日期或会话标识，例如：  
  `decisions-2026-02-12.md`、`session-index.md`、`summary-2026-02-12.md`。
- 格式：Markdown，可含表格、列表与相对路径链接到 `../infrastructure/` 下的文件。

## 与其它层的关系

- **读 domain/**：引用领域术语与概念。  
- **写 infrastructure/**：应用层只写索引或摘要；具体会话/主题内容写入 `infrastructure/conversations/` 或 `infrastructure/topics/`。
