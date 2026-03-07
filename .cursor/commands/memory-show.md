# 记忆：展示记忆内容

执行记忆系统的「展示记忆内容」命令。

1. 解析记忆根目录：读取 `.cursor/skills/memory-system/config.json` 的 `memoryRoot`，缺省为 `my_memory`（相对项目根）。

2. 若用户指定了子模块（如「只看 application」「展示 topics 下的记忆」）：
   - 仅列出并展示该子模块（`domain`、`application`、`infrastructure/conversations` 或 `infrastructure/topics`）下的文件。
   - 对 Markdown/文本文件展示内容摘要或前几行。

3. 若用户指定了具体文件（如「展示 xxx 这篇记忆」「打开记忆文件 xxx」）：
   - 在记忆根目录下按相对路径查找该文件，读取并展示完整内容。

4. 否则（展示全部记忆）：
   - 列出记忆根目录下的结构：domain、application、infrastructure/conversations、infrastructure/topics。
   - 列出各目录下的文件，对文本文件展示摘要或前几行，便于用户浏览。

若记忆根目录或某子目录不存在，先说明「该目录暂无内容」，再按需创建空目录结构（可选）。
