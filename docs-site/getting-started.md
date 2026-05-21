---
title: 入门指南
---

# 入门指南 🦞

OpenClaw 是一个自托管的多渠道 AI Agent 网关，让您可以通过常用的聊天应用与 AI 助手进行交互。

## 什么是 OpenClaw？

OpenClaw 是一个**自托管网关**，连接您喜爱的聊天应用和渠道平台（包括内置渠道以及 Discord、Telegram、WhatsApp、Signal、Slack、Teams、iMessage、Matrix 等插件渠道）到 AI 编程代理。您在自己的机器上运行一个单一的网关进程，它就成为了您的消息应用和随时可用的 AI 助手之间的桥梁。

**OpenClaw 适用于：** 希望拥有个人 AI 助手的开发者和高级用户，可以从任何地方发送消息——无需放弃对数据的控制或依赖托管服务。

## 主要特性

- **自托管**：运行在您的硬件上，由您做主
- **多渠道**：一个网关同时服务内置渠道和插件渠道
- **Agent 原生设计**：为编程代理构建，支持工具调用、会话、记忆和多 Agent 路由
- **开源**：MIT 许可证，社区驱动

## 系统要求

- **Node.js** — 推荐 Node 24（或 Node 22.19+）
- **API 密钥** — 来自模型提供商的密钥（Anthropic、OpenAI、Google 等）

## 快速安装

<Steps>
  <Step title="安装 OpenClaw">
    ```bash
    npm install -g openclaw@latest
    ```
  </Step>
  <Step title="运行引导">
    ```bash
    openclaw onboard --install-daemon
    ```
    向导会引导您选择模型提供商、设置 API 密钥和配置网关。
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
</Steps>

## 下一步

<Columns>
  <Card title="连接渠道" href="/openclaw/channels" icon="message-square">
    Discord、Feishu、Telegram、WhatsApp、Signal 等多种渠道。
  </Card>
  <Card title="配置网关" href="/openclaw/architecture" icon="settings">
    模型、工具、沙箱和高级设置。
  </Card>
  <Card title="浏览工具" href="/openclaw/tools" icon="wrench">
    浏览器、执行、网络搜索、技能和插件。
  </Card>
</Columns>

## 更多信息

- [快速入门](/openclaw/start/quickstart) — 5 分钟快速上手
- [架构概述](/openclaw/architecture) — 了解 OpenClaw 的系统架构
- [API 参考](/openclaw/api) — 完整的 API 文档
