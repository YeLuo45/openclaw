# 记忆：指定记忆目录

执行记忆系统的「指定记忆目录」命令。

1. 若用户在本命令中给出了目标路径（如「设为 xxx」「用 yy 作为记忆根目录」），则：
   - 将 `.cursor/skills/memory-system/config.json` 中的 `memoryRoot` 更新为该路径（相对项目根，如 `my_memory` 或 `docs/memory`）。
   - 若 `config.json` 不存在，先创建该文件，再写入 `{"memoryRoot": "<用户指定的路径>"}`。
   - 回复确认当前记忆根目录已更新。

2. 若用户未给出路径或仅想查询：
   - 读取 `.cursor/skills/memory-system/config.json` 的 `memoryRoot`。
   - 若不存在或未配置，则回答「当前记忆目录：项目根下的 my_memory」。
   - 否则回答「当前记忆目录：<项目根>/<memoryRoot>」。

所有后续记忆的读写均相对于该根目录；根目录下使用 DDD 子目录：`domain/`、`application/`、`infrastructure/conversations/`、`infrastructure/topics/`。
