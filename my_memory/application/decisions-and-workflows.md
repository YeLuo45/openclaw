# 决策与流程汇总（按模块归档）

**日期**：2026-02-13  
**说明**：从前期聊天中提炼的决策与操作流程，按主题归类。

---

## 1. OpenClaw 模型与配置

- **决策**：默认模型顺序为 qwen-portal/coder-model → zai/glm-4.6v-flash → zai/glm-4.6v → deepseek/deepseek-v3.2-exp → zai/glm-4.7-flashx → zai/glm-4.7。
- **流程**：直接编辑 `~/.openclaw/openclaw.json` 的 `agents.defaults.model.primary` 与 `agents.defaults.model.fallbacks`；PowerShell 下避免用 `config set ... fallbacks` 传 JSON 数组（易解析错误），可改用 `scripts/config-fallbacks.json` 或手改 JSON。
- **详见**：`application/model-priority-2026-02-12.md`。

---

## 2. Gateway（Windows）与 Dashboard

- **决策**：Windows 下未安装计划任务时，Gateway 不自动运行；Dashboard 依赖 Control UI 构建。
- **流程**：  
  - 前台运行：`node .\scripts\run-node.mjs gateway run --port 18789 --bind loopback --force`。  
  - 安装为计划任务：`node .\scripts\run-node.mjs gateway install`，再 `schtasks /Run /TN "OpenClaw Gateway"`。  
  - 排查 Dashboard 无响应：`pnpm ui:build`、`curl -v http://127.0.0.1:18789/` 看 200/503。
- **QQ 机器人 401**：在 QQ 开放平台将网关出口 IP 加入白名单。

---

## 3. 记忆系统与 Cursor 命令

- **决策**：记忆不自动保存每轮聊天；仅当用户说「归档」或 Agent 主动归档时写入。
- **流程**：用户可说「把这段对话归档」或使用 Cursor 命令「记忆：指定记忆目录」「记忆：展示记忆内容」「记忆：列出记忆」「记忆：写入/归档」；Agent 在产生可复用结论时应主动归档。
- **路径**：记忆命令在 `.cursor/commands/`，skill 在 `.cursor/skills/memory-system/`，数据在 `my_memory/`（或 config 中的 memoryRoot）。

---

## 4. ClawHub 技能安装

- **决策**：被 VirusTotal 标记为可疑的 skill 需用 `clawhub install <slug> --force` 安装；安装后需重启 Gateway。
- **流程**：`clawhub search "关键词"` → `clawhub install <slug>`（必要时 `--force`）→ `clawhub list` / `clawhub update --all`。
- **详见**：`infrastructure/topics/clawhub-skills-install-2026-02-12.md`。
