# 主题：记忆系统与 Cursor 命令

**归档日期**：2026-02-13（按模块从前期聊天整理）

---

## 记忆系统

- **Skill 位置**：`.cursor/skills/memory-system/`（SKILL.md、config.json、各层 README）。
- **记忆根目录**：默认 `my_memory`，由 config.json 的 `memoryRoot` 配置。
- **DDD 结构**：domain、application、infrastructure/conversations、infrastructure/topics。

## Cursor 命令（`.cursor/commands/`）

| 文件 | 作用 |
|------|------|
| memory-set-dir.md | 指定/查询记忆根目录 |
| memory-show.md | 展示记忆内容（可指定子模块或文件） |
| memory-list.md | 仅列出目录/文件列表 |
| memory-save.md | 将当前对话要点按模块写入记忆 |

使用：在 Cursor 输入 `/` 选择对应命令。

## 何时会写入 my_memory

- 用户说「记住」「归档」「保存到记忆」「把这段存进记忆」等；或  
- Agent 在当次对话中**主动归档**（有可复用结论时在回复结束前执行归档）。  
未触发上述任一则不会自动保存该轮聊天。

**关联**：`application/decisions-and-workflows.md` §3、`infrastructure/conversations/2026-02-12-cursor-commands-and-session-archive.md`。
