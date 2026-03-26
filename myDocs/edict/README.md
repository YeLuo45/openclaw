# Edict（三省六部）与本仓库的集成说明

[Edict](https://github.com/YeLuo45/edict) 是基于 OpenClaw 的多 Agent 编排与军机处看板项目（太子 → 三省 → 六部）。本仓库将其作为 **第三方源码** 放在：

`openclaw/third_party/edict/`

## 快速路径

| 内容 | 路径 |
|------|------|
| 上游仓库 | [YeLuo45/edict](https://github.com/YeLuo45/edict) |
| 本地克隆 | `openclaw/third_party/edict/` |
| 用户待办清单 | [user-todolist.md](./user-todolist.md) |
| Windows 一键安装 | `third_party/edict/install.ps1` |
| 看板服务 | `python dashboard/server.py`（在 `third_party/edict` 目录下执行） |
| 数据刷新循环 | Windows：`scripts/run_loop.ps1`；Linux/macOS：`scripts/run_loop.sh` |

## 更新上游代码

在 `openclaw/third_party/edict` 中执行：

```powershell
git pull origin main
```

若尚未克隆，可在仓库根目录执行：

```powershell
git clone --depth 1 https://github.com/YeLuo45/edict.git openclaw/third_party/edict
```

## 本仓库内的 Windows 适配

上游 `scripts/file_lock.py` 依赖 Unix 的 `fcntl`，在 Windows 上会导致 `dashboard/server.py` 无法启动。本集成目录中已加入 **`msvcrt.locking` 分支**，使看板与脚本可在 Windows 本机运行。

## 与 OpenClaw 文档的关系

更通用的多 Agent 概念与部署思路见：[openclaw-multi-agent-readme.md](../openclaw-multi-agent-readme.md)。
