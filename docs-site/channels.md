---
title: 渠道
---

# 渠道 💬

OpenClaw 支持通过多种聊天应用与 AI 助手交互。

## 支持的渠道

### 内置渠道

| 渠道 | 配置难度 | 说明 |
|------|----------|------|
| Telegram | ⭐ 简单 | 最快设置，仅需 Bot Token |
| Discord | ⭐ 简单 | 通过 Webhook 连接 |
| WhatsApp | ⭐⭐ 中等 | 扫描二维码连接 |
| Slack | ⭐⭐ 中等 | 需要 Bot Token |
| Microsoft Teams | ⭐⭐ 中等 | 通过 Bot Framework |
| Feishu | ⭐⭐ 中等 | 通过飞书 Bot API |

### 插件渠道

| 渠道 | 说明 |
|------|------|
| Signal | 第三方插件支持 |
| iMessage | macOS 上通过插件 |
| Matrix | 第三方插件 |
| QQ | 第三方插件 |
| WeChat | 第三方插件 |
| Nostr | 第三方插件 |
| Twitch | 第三方插件 |
| Zalo | 第三方插件 |

## 快速配置：Telegram

<Steps>
  <Step title="创建 Telegram Bot">
    1. 在 Telegram 中搜索 @BotFather
    2. 发送 `/newbot` 创建新机器人
    3. 复制获得的 Bot Token
  </Step>
  <Step title="配置 OpenClaw">
    在 `~/.openclaw/openclaw.json` 中添加：
    ```json
    {
      "channels": {
        "telegram": {
          "enabled": true,
          "botToken": "YOUR_BOT_TOKEN"
        }
      }
    }
    ```
  </Step>
  <Step title="启动网关">
    ```bash
    openclaw gateway restart
    ```
  </Step>
  <Step title="开始聊天">
    在 Telegram 中向您的机器人发送消息即可
  </Step>
</Steps>

## WhatsApp 配置

<Steps>
  <Step title="启用 WhatsApp 渠道">
    ```json
    {
      "channels": {
        "whatsapp": {
          "enabled": true,
          "allowFrom": ["+155****0123"]
        }
      }
    }
    ```
  </Step>
  <Step title="扫码连接">
    运行 `openclaw dashboard` 打开控制面板
    在渠道设置中进行 WhatsApp 扫码绑定
  </Step>
</Steps>

## 安全设置

### 允许列表

```json5
{
  channels: {
    whatsapp: {
      allowFrom: ["+155****0123", "+155****0456"],
    },
    telegram: {
      allowFrom: [123456789], // 用户 ID
    },
  },
}
```

### 群组设置

```json5
{
  channels: {
    whatsapp: {
      groups: {
        "*": {
          requireMention: true, // 需要 @机器人
        },
      },
    },
  },
}
```

## 更多信息

- [Telegram 详细配置](/openclaw/channels/telegram)
- [Discord 配置](/openclaw/channels/discord)
- [安全设置](/openclaw/security)