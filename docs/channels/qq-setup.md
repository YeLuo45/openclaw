# QQ 通道配置说明（需先安装插件）

OpenClaw 主仓库**不包含** QQ 通道，需先安装社区 QQ 插件后，配置中的 `channels.qq` 才会被识别。

参考：[阿里云 - 接入 QQ 机器人配置教程](https://developer.aliyun.com/article/1710195)

## 1. 安装 QQ 插件

在项目或 OpenClaw 目录下执行（需已安装 Git）：

```powershell
# 进入 OpenClaw 配置/扩展目录（二选一）
cd $env:USERPROFILE\.openclaw
# 或从源码：cd D:\WS\opensource\openclaw-main\openclaw

# 克隆 QQ 插件（来源见社区/阿里云教程）
git clone https://github.com/sliverp/qqbot.git

# 安装插件（若 openclaw 在 PATH）
openclaw plugins install ./qqbot
```

若使用项目内运行方式：

```powershell
cd D:\WS\opensource\openclaw-main\openclaw
node scripts/run-node.mjs plugins install ..\qqbot
```

安装后执行 `openclaw plugins list`，确认列表中有 `qqbot`。

## 2. 在 openclaw.json 中添加 QQ 配置

编辑 `%USERPROFILE%\.openclaw\openclaw.json`，在 `channels` 中增加 `qq` 段（替换为你的凭证）：

```json
"channels": {
  "telegram": { ... },
  "feishu": { ... },
  "qq": {
    "enabled": true,
    "appId": "102854896",
    "appSecret": "7ADHMRXelt2BLWht5IWkzFVm4MfzJezL",
    "token": "102854896:7ADHMRXelt2BLWht5IWkzFVm4MfzJezL",
    "sandbox": true,
    "allowPrivateChat": true,
    "allowGroupAt": true
  }
}
```

- **token**：多数实现为 `AppID:AppSecret`，请以插件文档为准。
- **sandbox**：沙箱模式仅沙箱成员可测。
- 在 QQ 开放平台「开发管理 → IP 白名单」中填写运行 OpenClaw 的服务器/本机公网 IP。

## 3. 启用插件并重启

在 `plugins.entries` 中启用 qqbot（若插件名为 `qqbot`）：

```json
"plugins": {
  "entries": {
    "qwen-portal-auth": { "enabled": true },
    "telegram": { "enabled": true },
    "feishu": { "enabled": true },
    "qqbot": { "enabled": true }
  }
}
```

保存后重启网关：

```powershell
openclaw gateway restart
# 或
node scripts/run-node.mjs gateway run --bind loopback --port 18789
```

## 4. 若仍报错 "unknown channel id: qq"

说明当前运行环境中未加载到 QQ 渠道插件，请确认：

1. 已执行 `openclaw plugins install <qq插件路径>` 且 `openclaw plugins list` 中有该插件；
2. `plugins.entries` 中已启用对应插件名；
3. 重启过 gateway。

未安装或未启用插件时，请**不要**在 `channels` 中保留 `qq`，否则会报错并导致配置校验失败。
