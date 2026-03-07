# 记忆：列出记忆（目录/文件列表）

执行记忆系统的「列出记忆」命令，仅输出目录树或文件列表，不展开文件正文。

1. 解析记忆根目录：读取 `.cursor/skills/memory-system/config.json` 的 `memoryRoot`，缺省为 `my_memory`（相对项目根）。

2. 若用户说「列出最近存的记忆」：
   - 按修改时间列出 `infrastructure/conversations` 与 `application` 下的最近文件（如最近 10 个），并注明路径与修改时间。

3. 否则：
   - 输出记忆根目录的目录树或扁平文件列表（domain、application、infrastructure/conversations、infrastructure/topics 及其下文件）。
   - 不展开文件内容，仅路径与文件名。

若记忆根目录不存在，回复「记忆目录尚未创建或为空」，并提示可先使用「记忆：写入/归档」保存内容。
