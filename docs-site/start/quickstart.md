---
summary: "在几分钟内安装 OpenClaw 并运行您的第一个聊天。"
read_when:
  - 首次从零开始设置
  - 想要最快的聊天工作路径
title: "快速开始"
---

# 快速开始 🚀

在约 5 分钟内安装 OpenClaw、运行引导程序并进行第一次聊天。到最后，您将拥有一个运行中的网关、配置好的认证和一个有效的聊天会话。

## 系统要求

- **Node.js** — 推荐 Node 24（也支持 Node 22.19+）
- **API 密钥** — 来自模型提供商的密钥（Anthropic、OpenAI、Google 等）

<Tip>
运行 `node --version` 检查您的 Node 版本。
**Windows 用户：** 支持原生 Windows 和 WSL2。WSL2 更稳定，推荐使用完整体验。
</Tip>

## 快速安装

<Steps>
  <Step title="安装 OpenClaw">
    <Tabs>
      <Tab title="macOS / Linux">
        ```bash
        curl -fsSL https://openclaw.ai/install.sh | bash
        ```
      </Tab>
      <Tab title="Windows (PowerShell)">
        ```powershell
        iwr -useb https://openclaw.ai/install.ps1 | iex
        ```
      </Tab>
    </Tabs>

    <Note>
    其他安装方式（Docker、Nix、npm）：[安装](/openclaw/install)
    </Note>
  </Step>

  <Step title="运行引导">
    ```bash
    openclaw onboard --install-daemon
    ```

    向导会引导您选择模型提供商、设置 API 密钥和配置网关。这个过程大约需要 2 分钟。
  </Step>

  <Step title="验证网关运行状态">
    ```bash
    openclaw gateway status
    ```

    您应该看到网关在端口 18789 上监听。
  </Step>

  <Step title="打开控制面板">
    ```bash
    openclaw dashboard
    ```

    这会在浏览器中打开控制 UI。如果页面正常加载，说明一切正常。
  </Step>

  <Step title="发送第一条消息">
    在控制面板的聊天窗口中输入消息，您应该会收到 AI 回复。

    想要从手机聊天？最快的渠道是 [Telegram](/openclaw/channels)，只需要一个 Bot Token。
  </Step>
</Steps>

## 下一步

<Columns>
  <Card title="连接渠道" href="/openclaw/channels" icon="message-square">
    Discord、Feishu、iMessage、Matrix、Microsoft Teams、Signal、Slack、Telegram、WhatsApp、Zalo 等。
  </Card>
  <Card title="配对和安全" href="/openclaw/channels/pairing" icon="shield">
    控制谁可以向您的 Agent 发送消息。
  </Card>
  <Card title="配置网关" href="/openclaw/architecture" icon="settings">
    模型、工具、沙箱和高级设置。
  </Card>
  <Card title="浏览工具" href="/openclaw/tools" icon="wrench">
    浏览器、执行、网络搜索、技能和插件。
  </Card>
</Columns>
