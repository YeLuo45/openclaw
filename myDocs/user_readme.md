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

### 1.4 大模型的添加与验证（CLI 速查）

在已能运行 OpenClaw CLI 的前提下（全局 `openclaw` 或在本仓库根目录执行 `node .\openclaw.mjs …`），可按下面顺序**接入新提供者 / 换默认模型 / 自测**。

**常用流程**

1. **写入配置与鉴权**（任选）  
   - 交互引导：`openclaw onboard`（例如小米：`openclaw onboard --auth-choice xiaomi-api-key`）  
   - 或编辑 `%USERPROFILE%\.openclaw\openclaw.json` 中 `models.providers` 与 `agents.defaults.model.primary`  

2. **切换默认模型**  

   ```powershell
   openclaw models set <provider>/<model-id>
   openclaw models list [--provider <名>]
   ```

3. **验证（由浅到深）**  

   ```powershell
   openclaw models status
   openclaw models status --json
   openclaw models status --check
   openclaw models status --probe [--probe-provider <名>]
   ```

   注意：`--probe` **不要**与 `--plain` 同时使用。  

4. **端到端一句话自测（嵌入式，不经过 Gateway）**  

   ```powershell
   openclaw agent --local --agent main --message "只回答一个字：OK" --json
   ```

   从输出 JSON 查看 `meta.agentMeta.provider`、`model` 与 `payloads[0].text`。  

5. **修改配置后让已安装的网关任务重新加载**  

   ```powershell
   openclaw gateway restart
   ```

**多 Agent**：为某个 agent 单独检查时加 `--agent <id>`，例如 `openclaw models status --agent dev`。

**小米 MiMo**：常规控制台 API Key 使用默认 `baseUrl` `https://api.xiaomimimo.com/v1`；Token Plan 套餐密钥需改为 `token-plan-cn` / `token-plan-sgp` 等套餐网关，混用会出现 **401**。详见仓库内 `docs/providers/xiaomi.md`。

**更全的命令表与示例**：`myDocs/openclaw_command-zh.md` 顶部 **「大模型：添加与验证（文档导航）」** 与文中 **「大模型：新增凭证、切换默认模型与验证（含小米 MiMo）」** 一节。

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

---

## 4. OpenClawd Agent 协作与使用经验 (基于日志分析)

基于 `openclaw-2026-04-02.log` 的运行日志，总结以下关于优化 Agent 使用、降低成本及多 Agent 协作的经验：

### 4.1 如何减少无效 Token 消耗
* **明确指定操作系统上下文**：日志显示，Agent 默认可能会尝试执行 Linux 风格的 Shell 命令（如 `ls -la` 或 `find . -name "*PRD*" 2>/dev/null`）。在 Windows PowerShell 环境下执行这些命令会导致报错（如 `DirectoryNotFoundException` 或参数绑定异常）。每次执行失败后的重试和报错信息分析都会无谓地消耗大量 Token。因此，**强烈建议在 Agent 的系统提示词（System Prompt）或全局规则中，明确告知其当前处于 Windows PowerShell 环境**，要求其使用兼容的命令（如 `Get-ChildItem`）。
* **直接提供精确路径，避免全局盲搜**：让 Agent 自己使用全局搜索命令去寻找文档（如全盘查找 PRD）不仅耗时，还会因为环境差异而频繁报错。直接将关键文档的绝对路径提供给 Agent，可大幅节省用于“探索环境”和“试错”的 Token。

### 4.2 如何高效完成派发的任务
* **上下文前置（Context First）**：在派发开发任务前，应准备好必要的前置文档。日志中，主 Agent 因为缺少 PRD 主动打断了流程并向用户索要（“老板，我需要先获取AI价值投资应用的PRD文档才能开始开发工作”）。如果在首次派发任务时就将 PRD 内容或文件路径一并提供，即可实现“零打断”的高效自动流转。
* **明确的 Agent 路由与分工**：在多 Agent 架构中，采用“主 Agent 负责沟通收集，专业 Agent 负责执行”的模式最高效。例如，由 `openclaw-feishu` 主 Agent 获取并解析 PRD 摘要，随后主动唤起专业的“全栈开发 Agent（dev）”去专门负责代码编写，这样能保持单一 Agent 的上下文专注度，提高执行效率。

### 4.3 释疑：PRD 与全栈开发 Agent 的关系
根据日志分析，针对您的疑问确认如下：
* **PRD 是否由全栈开发 Agent 实现（编写）？**
  **不是**。根据日志记录，PRD 文档是用户已有或是由主 Agent（openclaw-feishu）负责获取并提炼的。主 Agent 获取到 PRD 后，将其转交并启动了全栈开发 Agent（dev），由该全栈 Agent **基于此 PRD 来实现具体的代码功能**。全栈开发 Agent 扮演的是“根据需求写代码的执行者”，而非“PRD 的编写者”。
* **是否是通过 Cursor CLI 开发（获取）PRD 的？**
  **否**。日志中未发现任何调用 `cursor` 或 `cursor cli` 的记录。PRD 的获取及流转完全是 Agent 在宿主机的 Shell 环境中执行常规工具（如 `exec`）并在内部原生流转完成的，与 Cursor CLI 无关。
