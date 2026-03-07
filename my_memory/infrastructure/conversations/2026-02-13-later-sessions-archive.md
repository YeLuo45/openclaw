# 后续多轮会话补档：2026-02-12 至 2026-02-13

**归档日期**：2026-02-13  
**说明**：因当时未触发「归档」指令且 Agent 未主动归档，这几轮对话此前未写入 my_memory。此处补录要点，便于日后检索。

---

## 1. OpenClaw 模型优先级与 config 设置

- **用户需求**：优先使用 qwen-portal/coder-model，其次 zai/glm-4.6v-flash、zai/glm-4.6v、deepseek/deepseek-v3.2-exp、zai/glm-4.7-flashx、zai/glm-4.7。
- **操作**：在 `C:\Users\14663\.openclaw\openclaw.json` 的 `agents.defaults.model` 下设置 `primary` 与 `fallbacks`。
- **注意**：PowerShell 下用 `config set agents.defaults.model.fallbacks` 传 JSON 数组易报错（引号/方括号解析），推荐直接编辑 JSON 或使用项目内 `scripts/config-fallbacks.json` 用变量传入。
- **详细**：见 `application/model-priority-2026-02-12.md`。

---

## 2. Gateway 状态与「没有响应」

- **现象**：`gateway status` 显示 Service: Scheduled Task (missing)、Runtime: unknown、RPC probe: failed；访问 http://127.0.0.1:18789/ 没有响应。
- **原因**：Windows 下未安装计划任务时 Gateway 未以服务形式运行；根路径 `/` 由 Control UI 提供，若未构建或路径不对会 503。
- **处理**：
  - **前台运行**：`node .\scripts\run-node.mjs gateway run --port 18789 --bind loopback --force`（保持终端不关）。
  - **安装为计划任务**：`node .\scripts\run-node.mjs gateway install`，然后 `schtasks /Run /TN "OpenClaw Gateway"`。
  - **Dashboard**：Control UI 需已构建（`pnpm ui:build`）；若 503 可先 `curl -v http://127.0.0.1:18789/` 看状态码。
- **QQ 机器人 401**：错误「接口访问源IP不在白名单」需在 QQ 开放平台将网关出口 IP 加入白名单。

---

## 3. ClawHub 技能安装

- **已安装**：web-scraper；capability-evolver、playwright-crawler、blogwatcher（已存在）、senior-fullstack、neural-memory、agentic-browser-0-1-2（后五个用 `clawhub install <slug> --force`，因被标记为可疑）。
- **位置**：`skills/` 下各子目录；安装后需重启 Gateway 才能加载。
- **命令**：`clawhub search "关键词"`、`clawhub install <slug>`、`clawhub list`、`clawhub update --all`。
- **详细**：见 `infrastructure/topics/clawhub-skills-install-2026-02-12.md`。

---

## 4. 为何后续多次聊天未记录到 my_memory

- 记忆系统**不会自动保存每轮聊天**，只有在以下情况会写入：
  - 用户明确说「记住」「归档」「保存到记忆」「把这段存进记忆」等；或
  - Agent 在当次对话中**主动执行归档**（如本文件即补档）。
- 上述几轮对话中用户未要求归档，且当时未在 SKILL 中约定「有可复用结论时主动归档」，故未写入。已在 `.cursor/skills/memory-system/SKILL.md` 中增加**主动归档**约定与「为何部分会话未出现」说明，并补写本文件与 `application/session-index.md`。
