---
summary: "在 OpenClaw 中使用千问（Qwen）OAuth（免费版）"
read_when:
  - 你想在 OpenClaw 中使用千问
  - 你想要免费版的 OAuth 访问千问 Coder
title: "千问（Qwen）"
---

# 千问（Qwen）

千问提供免费版的 OAuth 流程来访问 Qwen Coder 和 Qwen Vision 模型（每天 2,000 次请求，受千问速率限制）。

## 启用插件

```bash
openclaw plugins enable qwen-portal-auth
```

启用后需要重启 Gateway。

## 认证方式

### 方式一：OAuth 设备码认证（推荐，免费）

这是推荐的免费认证方式，使用 OAuth 设备码流程：

```bash
openclaw models auth login --provider qwen-portal --set-default
```

这个命令会：
1. 启动千问设备码 OAuth 流程
2. 显示一个验证 URL 和用户代码
3. 在浏览器中打开验证页面（或手动访问）
4. 输入用户代码完成授权
5. 自动将凭证保存到 `models.json`（并创建一个 `qwen` 别名用于快速切换）

**注意**：此命令需要在交互式终端中运行，不能在非交互式环境中执行。

### 方式二：环境变量配置

如果你已经有千问的 OAuth Token 或 API Key，可以通过环境变量配置：

**Windows PowerShell:**
```powershell
$env:QWEN_OAUTH_TOKEN = "your-oauth-token-here"
# 或者
$env:QWEN_PORTAL_API_KEY = "your-api-key-here"
```

**Linux/macOS:**
```bash
export QWEN_OAUTH_TOKEN="your-oauth-token-here"
# 或者
export QWEN_PORTAL_API_KEY="your-api-key-here"
```

**永久配置（添加到配置文件）：**

在 `~/.openclaw/openclaw.json` 中添加：

```json5
{
  env: {
    QWEN_OAUTH_TOKEN: "your-oauth-token-here",
    // 或者
    QWEN_PORTAL_API_KEY: "your-api-key-here",
  },
}
```

### 方式三：复用 Qwen Code CLI 登录

如果你已经使用 Qwen Code CLI 登录过，OpenClaw 会自动从 `~/.qwen/oauth_creds.json` 同步凭证。你仍然需要在配置中添加 `models.providers.qwen-portal` 条目（使用上面的登录命令创建）。

## 模型 ID

- `qwen-portal/coder-model` - 千问 Coder 模型
- `qwen-portal/vision-model` - 千问 Vision 模型

切换模型：

```bash
openclaw models set qwen-portal/coder-model
```

## 如何获取千问 API Key

### 免费 OAuth 方式（推荐）

1. 访问千问官网：https://chat.qwen.ai 或 https://portal.qwen.ai
2. 注册/登录账号
3. 使用上面的 OAuth 设备码认证命令完成授权

### 付费 API Key 方式

如果你需要付费的 API Key：

1. 访问千问云服务：https://dashscope.aliyun.com/
2. 注册/登录阿里云账号
3. 开通千问服务
4. 在控制台创建 API Key
5. 使用环境变量 `QWEN_PORTAL_API_KEY` 配置

**注意**：目前 OpenClaw 主要支持通过 OAuth 方式访问千问 Portal（免费版）。如果你有付费的 DashScope API Key，可能需要手动配置 API 端点。

## 配置示例

在 `~/.openclaw/openclaw.json` 中配置：

```json5
{
  models: {
    providers: {
      "qwen-portal": {
        baseUrl: "https://portal.qwen.ai/v1",
        apiKey: "${QWEN_OAUTH_TOKEN}", // 或直接使用 OAuth placeholder
        models: [
          {
            id: "coder-model",
            name: "Qwen Coder",
          },
          {
            id: "vision-model",
            name: "Qwen Vision",
          },
        ],
      },
    },
  },
  agents: {
    defaults: {
      model: {
        primary: "qwen-portal/coder-model",
      },
    },
  },
}
```

## 注意事项

- Token 会自动刷新；如果刷新失败或访问被撤销，重新运行登录命令
- 默认 base URL：`https://portal.qwen.ai/v1`（如果千问提供不同的端点，可以通过 `models.providers.qwen-portal.baseUrl` 覆盖）
- 免费版限制：每天约 2,000 次请求（受千问速率限制）
- 查看 [模型提供商](/concepts/model-providers) 了解提供商范围的规则

## 故障排除

### OAuth 认证失败

如果 OAuth 认证失败：

1. 确保插件已启用：`openclaw plugins list`
2. 重启 Gateway
3. 重新运行登录命令：`openclaw models auth login --provider qwen-portal`
4. 检查网络连接，确保可以访问 `https://chat.qwen.ai`

### Token 过期

如果 Token 过期：

1. 重新运行登录命令：`openclaw models auth login --provider qwen-portal`
2. 或者检查环境变量是否正确设置

### 无法使用 API Key

如果使用付费 API Key 遇到问题：

1. 确认 API Key 格式正确
2. 检查 API Key 是否有足够的权限
3. 确认 API 端点 URL 是否正确（可能需要使用 DashScope 的端点而非 Portal 端点）

## 相关文档

- [模型提供商概念](/concepts/model-providers)
- [模型认证](/gateway/authentication)
- [环境变量配置](/environment)
