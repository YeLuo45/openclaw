# OpenClaw 配置与部署经验总结 (Windows 环境)

本文档记录了在 Windows 环境下配置 OpenClaw、接入通义千问模型、配置多 Agent 工作空间、集成飞书插件以及注册后台服务时遇到的常见问题及解决方案。

## 1. 模型与 Agent 基础配置

### 1.1 核心配置文件
用户级的核心配置文件位于：`~/.openclaw/openclaw.json` (对应 Windows 下的 `%USERPROFILE%\.openclaw\openclaw.json`)。

### 1.2 配置通义千问 (Qwen) 作为默认模型
为了使用通义千问，需要在配置中定义 `qwen-portal` 提供商，并在 `agents.defaults` 中将其设为默认模型：

```json
{
  "models": {
    "providers": {
      "qwen-portal": {
        "baseUrl": "https://portal.qwen.ai/v1",
        "apiKey": "qwen-oauth",
        "api": "openai-completions",
        "models": [
          { "id": "coder-model", "name": "Qwen Coder", "contextWindow": 128000, "maxTokens": 8192 }
        ]
      }
    }
  },
  "agents": {
    "defaults": {
      "model": { "primary": "qwen-portal/coder-model" }
    }
  }
}
```
**登录授权**：在终端运行 `pnpm openclaw models auth login --provider qwen-portal` 获取授权，授权后可正常调用 API。

### 1.3 设定 Agent 工作空间
为 `main` Agent 设置独立工作空间，便于存储其专有的 `AGENTS.md`, `IDENTITY.md`, `TOOLS.md` 等。

```json
"agents": {
  "list": [
    {
      "id": "main",
      "name": "Main Agent",
      "workspace": "~/.openclaw/workspace"
    }
  ]
}
```

---

## 2. 飞书 (Feishu) 插件接入避坑指南

### 2.1 配置文件格式（极其重要）
旧版本的文档或缓存可能会导致配置格式混淆，正确的 `channels` 和 `bindings` (路由匹配) 格式如下：

**通道配置**（提供认证信息）：
```json
"channels": {
  "openclaw-feishu": {
    "enabled": true,
    "appId": "cli_xxxxxx",
    "appSecret": "xxxxxx"
  }
}
```

**绑定配置**（建立 Agent 与通道的联系，**注意 `match` 对象是必填的，不能省略**）：
```json
"bindings": [
  {
    "agentId": "main",
    "match": {
      "channel": "openclaw-feishu",
      "accountId": "default"
    }
  }
]
```
*(注意：旧版本的 `routing.bindings` 已经被废弃，应直接使用顶层的 `bindings` 键。如果运行时报错提示 `bindings.0.match: Invalid input: expected object`，请检查是否漏写了 `match` 包裹层。)*

### 2.2 开启插件
必须在 `plugins.entries` 中显式开启飞书插件：
```json
"plugins": {
  "entries": {
    "openclaw-feishu": { "enabled": true }
  }
}
```

### 2.3 飞书插件依赖安装失败 (Cannot find module '@larksuiteoapi/node-sdk')
在 Windows 下，插件目录的依赖有时无法自动安装成功，导致 Gateway 启动时找不到飞书 SDK。

**解决方案**：手动进入插件目录安装依赖。
1. 打开终端进入插件目录：
   ```powershell
   cd ~/.openclaw/extensions/openclaw-feishu
   ```
2. 删除可能损坏的缓存：
   ```powershell
   rmdir /S /Q node_modules
   ```
3. 使用 npm 手动安装并忽略依赖冲突：
   ```powershell
   npm install @larksuiteoapi/node-sdk zod --save --legacy-peer-deps
   ```
*(注：如果由于国内网络问题导致 npm 安装挂起，可以配置淘宝镜像：`npm install --registry=https://registry.npmmirror.com`)*

---

## 3. Gateway 服务运行与安装

### 3.1 前台启动调试
在配置阶段，建议直接前台启动 Gateway，这样可以直观看到日志报错：
```powershell
cd /d G:\WS\ai-tools\opensource\openclaw
pnpm openclaw gateway
```
看到 `[ws] ws client ready` 等字样说明飞书长连接已成功建立。

### 3.2 诊断与修复配置
如果启动一直报错，可使用自检修复工具（但它只能修复部分结构移位问题，比如 `match` 缺失等逻辑问题仍需手动改 json）：
```powershell
pnpm openclaw doctor --fix
```

### 3.3 解决安装后台任务“拒绝访问” (schtasks create failed)
执行 `pnpm openclaw gateway install` 试图将网关注册为 Windows 后台定时任务时，如果出现乱码报错 `: ܾ`（翻译为：拒绝访问），这是因为权限不足。

**解决方案**：
1. 点击系统“开始”菜单，搜索 `PowerShell`。
2. **右键点击 -> 以管理员身份运行**。
3. 在管理员 PowerShell 窗口中重新执行安装命令：
   ```powershell
   cd /d G:\WS\ai-tools\opensource\openclaw
   pnpm openclaw gateway install
   ```
成功后，就可以使用 `pnpm openclaw gateway start` 在后台守护运行了。
