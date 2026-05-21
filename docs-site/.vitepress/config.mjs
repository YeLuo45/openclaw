import { defineConfig } from "vitepress";

export default defineConfig({
  title: "OpenClaw 文档",
  description: "OpenClaw - 多渠道 AI Agent 网关中文文档",
  lang: "zh-CN",
  base: "/openclaw/",
  ignoreDeadLinks: true,

  head: [
    ["link", { rel: "icon", type: "image/svg+xml", href: "/openclaw/logo.svg" }],
  ],

  themeConfig: {
    logo: "/openclaw/logo.svg",

    nav: [
      { text: "首页", link: "/openclaw/" },
      { text: "快速开始", link: "/openclaw/start/getting-started" },
      { text: "架构", link: "/openclaw/architecture" },
      { text: "渠道", link: "/openclaw/channels" },
      { text: "API", link: "/openclaw/api" },
    ],

    sidebar: [
      {
        text: "文档",
        items: [
          { text: "首页", link: "/openclaw/" },
          { text: "快速开始", link: "/openclaw/start/getting-started" },
          { text: "快速入门", link: "/openclaw/start/quickstart" },
          { text: "架构概述", link: "/openclaw/architecture" },
          { text: "渠道", link: "/openclaw/channels" },
          { text: "模型提供商", link: "/openclaw/providers" },
          { text: "工具系统", link: "/openclaw/tools" },
          { text: "内存与会话", link: "/openclaw/memory" },
          { text: "API 参考", link: "/openclaw/api" },
          { text: "入门指南", link: "/openclaw/getting-started" },
        ],
      },
    ],

    socialLinks: [
      { icon: "github", link: "https://github.com/YeLuo45/openclaw" },
    ],

    footer: {
      message: "基于 OpenClaw - 多渠道 AI Agent 网关",
      copyright: "Copyright © 2024-present OpenClaw Contributors",
    },
  },
});
