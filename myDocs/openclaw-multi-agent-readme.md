# OpenClaw 多智能体协作系统 — 完整指南

> 从单兵到军团：基于 OpenClaw 构建企业级多 Agent 协作系统

---

## 一、什么是 OpenClaw

OpenClaw（原名 Clawdbot，昵称"龙虾"）是 2026 年最热门的开源 AI Agent 网关项目之一，凭借原生多 Agent 支持、独立工作区隔离、灵活路由机制，成为搭建多智能体协作系统的首选框架。

其核心能力在于 **MultiAgent 架构**——让多个智能体分工协作，像真人团队一样拆解任务、并行执行、汇总结果，真正实现"一句话启动复杂项目"。

---

## 二、核心架构设计

### 2.1 智能体（Agent）核心组成

每个 Agent 都是独立的"大脑"，拥有专属配置与工作空间：

| 组成部分 | 说明 |
|---------|------|
| **独立工作区（workspace）** | 存储该 Agent 的文件、人设规则（AGENTS.md / SOUL.md / USER.md 等）、本地笔记，不同 Agent 工作区相互隔离 |
| **状态目录（agentDir）** | 存放认证配置文件（auth-profiles.json）、模型注册表（models.json），确保 Agent 独立调用模型与工具 |
| **会话存储** | 聊天历史与路由状态保存在 `~/.openclaw/agents/<agentId>/sessions`，支持多轮对话记忆与任务上下文传递 |

默认部署后会自动创建 `main` 智能体作为初始入口，用户可按需创建子 Agent 形成协作架构。

### 2.2 多 Agent 架构设计原则

1. **单 Gateway 多 Workspace**：所有智能体共用一个网关进程降低运维成本，同时每个智能体拥有独立工作区避免文件覆盖与配置冲突
2. **路由与身份双隔离**：消息精准路由到对应智能体，且智能体以自己的身份对外响应
3. **记忆分层管理**：区分每日流水、长期记忆、语义检索，按需加载信息节省 Token 资源
4. **模型混搭策略**：关键任务用顶级模型，日常任务用经济型模型，平衡效果与成本
5. **双轨治理机制**：配置层（硬约束）+ 规则层（软引导），确保智能体协作有序

### 2.3 为什么需要多 Agent

单智能体"包揽所有任务"存在三大问题：

| 问题 | 说明 |
|------|------|
| **上下文污染** | 写文章中途切换技术咨询，代码讨论会打断写作状态，导致文风突变 |
| **人设混乱** | 写作的口语化风格渗透到技术调试场景，或技术文档风格让文案失去温度 |
| **记忆爆炸** | 对话历史无限累积，上下文窗口被占满，旧信息干扰新任务，Token 消耗飙升 |

多 Agent 架构通过专业分工解决上述问题：写作的归写作、编码的归编码，各智能体独立工作区、独立记忆、独立人设，互不干扰。

---

## 三、多智能体协同的核心价值

1. **任务并行处理**：复杂任务拆分为多个子任务，子 Agent 同时执行，大幅提升效率
2. **角色专业化分工**：每个 Agent 专注单一领域，避免功能冗余
3. **权限精细化控制**：子 Agent 可配置不同权限（如仅开放文档编辑权限，不授予系统命令权限）
4. **灵活扩展与迭代**：按需新增/删除 Agent，调整协作规则，适配不同场景

---

## 四、部署方案

### 4.1 部署方案对比

| 维度 | 阿里云部署 | 本地部署（Windows/Mac） |
|------|-----------|----------------------|
| **核心优势** | 7×24 小时稳定运行、多端访问、支持大规模协作 | 零成本、调试便捷、配置即时生效、数据本地存储 |
| **适用场景** | 团队协作、多智能体无人值守运行、长期自动化任务 | 个人体验、架构测试、本地文件协作 |
| **操作难度** | 极低（预置镜像，一键部署） | 低（脚本自动化） |
| **多 Agent 适配** | 支持 5+ 智能体同时运行 | 支持 3-5 个智能体 |

### 4.2 环境要求

| 依赖 | 最低版本 |
|------|---------|
| Node.js | v22.0.0+ |
| Python | 3.9+ |
| Git | 最新稳定版 |
| 内存 | 4GB+（推荐 2vCPU + 4GiB） |
| 存储 | 40GB ESSD |

### 4.3 方案一：阿里云部署（推荐长期运行）

#### 快速部署

1. 访问 [阿里云 OpenClaw 一键部署专题页](https://www.aliyun.com/activity/ecs/clawdbot)，点击「一键购买并部署」
2. 选购轻量应用服务器，选择 OpenClaw(Moltbot) 镜像，内存 2GiB 及以上
3. 在阿里云百炼控制台创建 API-Key
4. 进入轻量应用服务器「应用详情」放行 18789 端口、配置百炼 API-Key、生成访问 Token

#### 手动部署

```bash
# 1. 更新系统
apt update -y && apt upgrade -y

# 2. 安装核心依赖
apt install -y git nodejs npm python3 python3-pip python3-venv
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt install -y nodejs

# 3. 克隆项目
git clone https://github.com/openclaw/openclaw.git
cd openclaw

# 4. Python 虚拟环境
python3 -m venv venv
source venv/bin/activate

# 5. 安装依赖（国内镜像加速）
pip install -r requirements.txt --index-url=https://pypi.tuna.tsinghua.edu.cn/simple
npm install --registry=https://registry.npmmirror.com

# 6. 初始化配置
npm run onboard
```

#### 配置开机自启（Systemd）

```ini
# /etc/systemd/system/openclaw.service
[Unit]
Description=OpenClaw MultiAgent Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/openclaw
ExecStart=/root/openclaw/venv/bin/python3 /root/openclaw/bin/openclaw gateway start
Restart=always
RestartSec=5s
Environment="NODE_ENV=production"

[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload
systemctl start openclaw
systemctl enable openclaw
```

#### 防火墙放行端口

- 22（SSH）
- 18789（OpenClaw 服务）
- 8080（Web 控制台）

### 4.4 方案二：Windows 本地部署

```powershell
# 1. 安装 WSL2
wsl --install

# 2. 一键安装 OpenClaw
iwr -useb https://clawd.bot/install-windows-multi-agent.ps1 | iex

# 备选：npm 安装
npm install -g openclaw@latest --registry https://registry.npmmirror.com/

# 3. 初始化配置
openclaw onboard

# 4. 启动服务
openclaw service start

# 5. 生成 Web 控制台 Token
openclaw token generate

# 6. 访问 http://127.0.0.1:18789
```

### 4.5 方案三：Mac 本地部署

```bash
# 1. 安装依赖
brew install git node@22 python@3.9
brew link node@22 --force

# 2. 克隆并安装
git clone https://github.com/openclaw/openclaw.git
cd openclaw
python3 -m venv venv
source venv/bin/activate
pip3 install -r requirements.txt --index-url=https://pypi.tuna.tsinghua.edu.cn/simple
npm install --registry=https://registry.npmmirror.com
npm run onboard

# 3. 后台启动
nohup npm run start > ~/.openclaw/logs/start.log 2>&1 &
```

### 4.6 部署避坑指南

| 问题 | 解决方案 |
|------|---------|
| Windows PowerShell 执行脚本权限不足 | 管理员模式运行：`Set-ExecutionPolicy RemoteSigned`，输入 Y 确认 |
| Mac Node.js 命令未找到 | `echo 'export PATH="/usr/local/opt/node@22/bin:$PATH"' >> ~/.zshrc`，重启终端 |
| 端口被占用 | Windows: `netstat -ano \| findstr "18789"`；Mac/Linux: `lsof -i:18789`，终止占用进程 |
| 配置不生效 | 重启服务：`openclaw service restart` 或 `systemctl restart openclaw` |

---

## 五、多智能体创建与配置

### 5.1 方式一：命令行创建（精准控制）

```bash
# 创建智能体
openclaw agents add media-manager
openclaw agents add media-wechat
openclaw agents add media-xhs

# 查看所有智能体
openclaw agents list
```

### 5.2 方式二：自然语言创建（零基础友好）

在 OpenClaw 控制台或终端向 `main` 智能体发送指令：

```
帮我创建一组用于AI自媒体工作的多智能体团队，包含3个Agent：
1. 主Agent（media-manager）：负责拆分任务、分配给子Agent，汇总最终结果；
2. 公众号文案Agent（media-wechat）：负责撰写公众号干货文章；
3. 小红书文案Agent（media-xhs）：负责撰写小红书种草文案。
```

### 5.3 工作空间配置

每个 Agent 的工作空间文件位于：

```
~/.openclaw/workspace/workspace-<agentName>/
```

核心配置文件：

#### IDENTITY.md — 身份定义

```markdown
# 身份定义
- 名称：公众号文案Agent（media-wechat）
- 角色：专业AI自媒体文案创作者
- 擅长领域：科技、AI工具、效率提升类干货文章
- 目标：撰写结构清晰、实用性强、易于传播的公众号文章
```

#### SOUL.md — 人格与行为原则

```markdown
# 个性与行为原则
- 语言风格：专业、简洁、口语化，避免生硬术语
- 行为原则：
  - 严格按用户需求撰写，不偏离主题
  - 文章结构包含引言、核心内容（3-4个二级标题）、总结
  - 不使用夸张营销词汇，基于事实创作
- 界限：不涉及敏感话题、不编造数据
```

#### TOOLS.md — 工具配置

```markdown
# 工具配置
- 飞书云文档：允许编辑、创建、保存文档
- 图片生成工具：允许调用AI生图接口
- 禁止使用：系统命令执行、文件删除操作
```

#### MEMORY.md — 长期记忆

```markdown
# 长期记忆
## 用户偏好
- 偏好高效少废话，不喜欢冗长的铺垫
- 工作时间 9:00-22:00
- 注重实操性，所有建议需附带具体步骤

## 协作规则
- 任务拆解：复杂任务拆分为3-5个小步骤
- 优先级：紧急任务优先分配，非紧急任务按顺序处理
- 汇报机制：完成任务后以"【任务完成】+ 核心结果"格式汇报
```

#### AGENTS.md — 运行手册与群聊规则

```markdown
# 多智能体运行手册
## 群聊规则
1. 专属频道：仅对应智能体响应普通消息，其他需@才回应
2. 统筹频道：主Agent默认响应，其他智能体必须被@才发言
3. 发言原则：被直接@或问问题才回复，能提供有价值信息才回复
4. 协作边界：不在群里跑完整工作流，需复杂操作时引导到专属频道

## 安全规则
- 不执行未授权的系统命令
- 不泄露用户隐私信息
- 遇到无法处理的问题，转交给主Agent统筹
```

---

## 六、多 Agent 配置（openclaw.json）

```jsonc
{
  "agents": {
    "defaults": {
      "llm": {
        "provider": "dashscope",
        "baseUrl": "https://dashscope.aliyuncs.com/compatible-mode/v1"
      },
      "session": {
        "agentToAgent": {
          "maxPingPongTurns": 0  // 禁止智能体自动互怼
        }
      }
    },
    "main": {
      "name": "统筹Agent",
      "description": "统筹全局、任务拆解、日常问答、系统监控",
      "workspace": "~/.openclaw/workspaces/main",
      "llm": { "model": "qwen3-max-2026" }
    },
    "writer": {
      "name": "写作Agent",
      "description": "文章创作、文案优化",
      "workspace": "~/.openclaw/workspaces/writer",
      "llm": { "model": "qwen3-max-2026" }
    },
    "coder": {
      "name": "编码Agent",
      "description": "代码编写、系统调试、运维操作",
      "workspace": "~/.openclaw/workspaces/coder",
      "llm": { "model": "qwen3-coder-2026" }
    }
  },
  "bindings": [
    {
      "agentId": "writer",
      "match": {
        "channel": "discord",
        "peer": { "kind": "channel", "id": "写作频道ID" },
        "guildId": "服务器ID"
      }
    },
    {
      "agentId": "coder",
      "match": {
        "channel": "discord",
        "accountId": "coder"
      }
    }
  ]
}
```

---

## 七、飞书多机器人协同配置

### 7.1 创建飞书机器人

每个 Agent 对应一个飞书机器人：

1. 登录 [飞书开发者后台](https://open.feishu.cn/)，创建企业自建应用
2. 应用类型选择「机器人」，命名与 Agent 名称一致
3. 开通权限：
   - 聊天权限：`im:message:send`、`im:message:read`
   - 云文档权限（按需）：`docs:doc:write`、`docs:doc:read`
4. 复制 `App ID` 和 `App Secret`
5. 事件配置中选择「使用长连接接收事件」，添加事件：
   - `im.chat.access_event.bot_p2p_chat_entered_v1`
   - `im.message.receive_v1`
6. 创建版本并发布

### 7.2 关联 OpenClaw 与飞书

#### 命令行配置

```bash
# 配置每个Agent的飞书机器人凭证
openclaw config set agents.media-manager.channels.feishu.appId "你的App ID"
openclaw config set agents.media-manager.channels.feishu.appSecret "你的App Secret"

openclaw config set agents.media-wechat.channels.feishu.appId "你的App ID"
openclaw config set agents.media-wechat.channels.feishu.appSecret "你的App Secret"

# 重启服务
openclaw gateway restart
```

#### 自然语言配置

```
帮我配置以下Agent与飞书机器人的关联：
1. Agent名称：media-manager，飞书App ID：xxx，App Secret：xxx；
2. Agent名称：media-wechat，飞书App ID：xxx，App Secret：xxx；
配置完成后启用飞书渠道，确保机器人能接收和发送消息。
```

### 7.3 创建飞书协同群

1. 创建群聊（如"AI自媒体协同群"）
2. 邀请所有飞书机器人加入群聊
3. 发送测试消息验证连接

---

## 八、协作模式与典型场景

### 8.1 协作模式

| 模式 | 说明 | 示例 |
|------|------|------|
| **串行协作** | 一个 Agent 的输出作为另一个的输入 | 统筹Agent拆解任务 → 写作Agent执行 |
| **并行协作** | 多个 Agent 同时处理，最终汇总 | 公众号文案 + 小红书文案同时创作 |
| **主从协作** | 一个 Agent 主导，按需调用其他 Agent | 主Agent分配任务，子Agent执行后汇报 |
| **会诊模式** | 复杂问题多 Agent 共同讨论决策 | 多角色联合分析复杂业务场景 |

### 8.2 典型场景：AI 自媒体团队

**架构：** 主 Agent（任务分配）+ 公众号文案 Agent + 小红书文案 Agent + 配图 Agent

**协同流程：**

```
用户 @media-manager：
  "创作一篇关于 OpenClaw 多智能体协同的内容，公众号4000字 + 小红书800字"

  ↓ 主Agent拆分任务

media-manager 群内反馈：
  ✅ 任务拆分完成：
  1. @media-wechat → 公众号文章创作（4000字，干货风格）
  2. @media-xhs → 小红书文案创作（800字，种草风格）

  ↓ 子Agent并行执行

media-wechat / media-xhs 同时创作，实时反馈进度

  ↓ 完成后保存至飞书云文档

media-manager 汇总：
  📊 任务完成报告
  - 公众号文章：[文档链接]（4200字）
  - 小红书文案：[文档链接]（850字）
```

### 8.3 典型场景：项目管理团队

**架构：** 主 Agent（需求拆解）+ 需求分析 Agent + 开发规划 Agent + 进度跟踪 Agent

### 8.4 典型场景：数据处理团队

**架构：** 主 Agent（任务调度）+ 数据抓取 Agent + 数据清洗 Agent + 可视化 Agent

### 8.5 典型场景：全功能个人助手团队

**架构：** 5 个智能体共用 1 台服务器：

| Agent | 角色 | 模型策略 | 职责 |
|-------|------|---------|------|
| 大蔡（main） | 统筹 | 经济型模型 | 任务拆解、日常问答、系统监控 |
| 蔡笔（writer） | 写作 | 顶级模型 | 文章创作、文案优化 |
| 蔡农（coder） | 编码 | 代码专用模型 | 代码编写、系统调试 |
| 小杜（life） | 生活 | 顶级模型 | 生活陪伴、情绪支持 |
| 蔡思（echo） | 思考 | 顶级模型 | 深度思考、观点碰撞 |

---

## 九、常用运维命令

```bash
# 服务管理
openclaw service start       # 启动
openclaw service restart     # 重启
openclaw service status      # 状态

# 智能体管理
openclaw agents list         # 列出所有智能体
openclaw agents add <name>   # 新增智能体

# 配置管理
openclaw config get agents              # 查看多Agent配置
openclaw config get bindings            # 查看路由规则
openclaw config get discord.accounts    # 查看Discord多Bot配置

# 日志查看
openclaw logs --filter agent            # 查看所有智能体日志
openclaw logs --agent writer            # 查看指定智能体日志

# 配置备份
cp ~/.openclaw/openclaw.json ~/.openclaw/config.backup.json

# Token 管理
openclaw token generate                 # 生成Web控制台Token

# 更新版本
curl -fsSL https://gitee.com/openclaw-team/script/raw/main/2026/aliyun_update.sh | bash
```

---

## 十、常见问题排查

### 10.1 Agent 创建失败

| 原因 | 解决方案 |
|------|---------|
| 命令输入错误 | 核对格式：`openclaw agents add <agentName>`，名称不含特殊字符 |
| 权限不足 | Linux 使用 root 用户，Windows 以管理员模式运行终端 |

### 10.2 飞书机器人无法接收消息

| 原因 | 解决方案 |
|------|---------|
| 机器人未通过审核 | 在飞书开发者后台查看审核状态 |
| App ID/App Secret 配置错误 | 核对配置文件中的凭证，重启服务 |
| 长连接未配置 | 在飞书机器人"事件配置"中启用长连接，添加必要事件 |

### 10.3 子 Agent 未执行分配的任务

| 原因 | 解决方案 |
|------|---------|
| 主 Agent 指令不清晰 | 明确任务目标、交付要求、截止时间 |
| Agent 间通信失败 | 检查所有 Agent 是否正常运行，重启服务 |
| 权限不足 | 在 TOOLS.md 中为子 Agent 配置必要权限 |

### 10.4 路由正确但身份错误

| 原因 | 解决方案 |
|------|---------|
| 共用一个 Bot 身份 | 为每个智能体创建独立 Discord/飞书 Bot，获取专属 Token |

### 10.5 智能体之间无限客套循环

| 原因 | 解决方案 |
|------|---------|
| 未设置互怼限制 | 在 `openclaw.json` 中设置 `maxPingPongTurns: 0` |

### 10.6 协同任务超时未完成

| 原因 | 解决方案 |
|------|---------|
| 任务复杂度超出预期 | 拆分更细粒度的子任务，延长截止时间或新增 Agent |
| 模型调用延迟 | 切换更快速的模型，优化网络环境 |

---

## 十一、参考资料

- [用OpenClaw搭建真正"能干活"的AI团队 — 腾讯云开发者社区](https://cloud.tencent.com/developer/article/2633920)
- [保姆级教程：OpenClaw 阿里云/本地多Agent部署+飞书机器人协同 — 阿里云开发者社区](https://developer.aliyun.com/article/1714518)
- [2026年OpenClaw多Agent实战指南：阿里云+Windows部署 — 阿里云开发者社区](https://developer.aliyun.com/article/1713689)
- [阿里云 OpenClaw 一键部署专题页](https://www.aliyun.com/activity/ecs/clawdbot)

---

*文档版本：v1.0 | 创建日期：2026-03-07 | 适用平台：OpenClaw 多智能体协作框架*
