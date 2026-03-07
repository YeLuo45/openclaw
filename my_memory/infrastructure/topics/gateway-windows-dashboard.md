# 主题：Gateway（Windows）与 Dashboard

**归档日期**：2026-02-13（按模块从前期聊天整理）

---

## 现象与原因

- **gateway status** 显示 Service: Scheduled Task (missing)、Runtime: unknown、RPC probe: failed → Windows 下未安装计划任务，Gateway 未以服务形式运行。
- 访问 http://127.0.0.1:18789/ 无响应 → 根路径由 Control UI 提供；若未构建或路径错误则返回 503。

## 操作

| 目的 | 命令或步骤 |
|------|------------|
| 前台运行 Gateway | `node .\scripts\run-node.mjs gateway run --port 18789 --bind loopback --force` |
| 安装计划任务 | `node .\scripts\run-node.mjs gateway install` |
| 手动运行任务 | `schtasks /Run /TN "OpenClaw Gateway"` |
| 构建 Control UI | `pnpm ui:build` |
| 排查根路径 | `curl -v http://127.0.0.1:18789/` 看状态码 |

## QQ 机器人 401

- 错误信息：`接口访问源IP不在白名单`（code 11298）。  
- 处理：在 QQ 开放平台将**网关出口公网 IP** 加入应用白名单。

**关联**：`application/decisions-and-workflows.md` §2。
