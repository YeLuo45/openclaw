# Edict（三省六部）用户待办清单

按顺序勾选。详细说明见上游 [README](https://github.com/YeLuo45/edict/blob/main/README.md) 与本地 `openclaw/third_party/edict/docs/getting-started.md`。

---

## 一、环境与仓库

- [ ] **Node.js**：OpenClaw 官方推荐 ≥22；Edict 前端构建需 Node 18+（未安装则 `install.ps1` 会跳过构建，看板仍可用内嵌/静态页）。
- [ ] **Python**：3.9+，`python` 或 `python3` 在 PATH 中可用。
- [ ] **Edict 源码**：已位于 `openclaw/third_party/edict/`（若缺失则执行  
  `git clone --depth 1 https://github.com/YeLuo45/edict.git openclaw/third_party/edict`）。

---

## 二、OpenClaw 本体

- [ ] 已安装 **openclaw** CLI（`openclaw --version` 可用）。
- [ ] 已完成初始化，存在 **`%USERPROFILE%\.openclaw\openclaw.json`**（未配置时请先按 [OpenClaw 入门](https://docs.openclaw.ai/start/getting-started) 完成向导）。
- [ ] （可选）官方建议在 Windows 上优先使用 **WSL2** 跑 Gateway；若坚持用原生 Windows，请自行验证网关与渠道稳定性。

---

## 三、安装 Edict（写入 Agent 与目录联接）

在 PowerShell 中（**以管理员身份**运行更易成功创建目录联接 `mklink /J`）：

```powershell
cd <本仓库根目录>\openclaw\third_party\edict
.\install.ps1
```

- [ ] `install.ps1` 无报错执行完成。
- [ ] 已为 **太子** 等 Agent 配置 **API Key**（示例：`openclaw agents add taizi`），然后 **再运行一次** `.\install.ps1` 同步到各部（见安装脚本末尾说明）。
- [ ] 若需确认 Agent 状态，可看板或文档中的 `curl http://127.0.0.1:7891/api/agents-status`（需先启动看板）。

---

## 四、日常运行（两个进程）

**终端 1 — 数据刷新**（约每 15 秒同步 OpenClaw 运行时数据到看板）：

```powershell
cd <本仓库根目录>\openclaw\third_party\edict
.\scripts\run_loop.ps1
```

- [ ] 刷新循环已启动（日志在 `%TEMP%\sansheng_liubu_refresh.log`）。

**终端 2 — 看板 HTTP 服务**：

```powershell
cd <本仓库根目录>\openclaw\third_party\edict
python dashboard\server.py
```

- [ ] 浏览器打开 <http://127.0.0.1:7891> 可看军机处看板。

---

## 五、可选与排错

- [ ] **仅体验 UI、无 OpenClaw**：可用上游提供的 Docker Demo（见 [YeLuo45/edict README](https://github.com/YeLuo45/edict#-30-秒快速体验)），与本仓库 `third_party` 路径无关。
- [ ] **前端构建**：若需最新 React 看板，安装 Node 后按 `install.ps1` 提示在 `edict/frontend` 执行 `npm install` 与 `npm run build`。
- [ ] **任务超时 / 回报不到太子**：按上游 README「常见问题排查」检查 `taizi` 存活、Gateway 日志、`tools.sessions.visibility` 等。
- [ ] **Skill 拉取失败**：检查访问 GitHub raw 的网络或代理。
- [ ] **自 `git pull` 上游后看板又报 `fcntl`**：本仓库已对 `third_party/edict/scripts/file_lock.py` 做 Windows 适配；若与上游冲突，需保留其中的 `msvcrt` 分支或自行合并。

---

## 六、本仓库文档索引

| 文档 | 说明 |
|------|------|
| [README.md](./README.md) | 集成路径与更新方式 |
| 本文 | 个人安装与运行勾选清单 |

完成「二 + 三 + 四」后，即可在本地完整使用三省六部编排与看板。
