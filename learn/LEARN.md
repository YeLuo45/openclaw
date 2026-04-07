# OpenClaw 学习地图

基于 `openclaw` 仓库当前源码整理的一份面向新手的学习路线。目标不是一次读完整个 monorepo，而是先抓住最关键的主链路：`CLI 入口 -> Gateway 控制面 -> Agent 请求链 -> 配置与插件扩展`。

## 先给结论

OpenClaw 不是单一的“聊天机器人脚本”，而是一个以 **Gateway 为控制平面** 的个人 AI 助手平台：

- CLI 用来做启动、配置、诊断、发送消息、运行 agent
- Gateway 负责承载控制面、WebSocket 协议、Control UI、会话、插件、通道与节点接入
- Agent 既可以经由 Gateway 运行，也可以在失败时回退到本地嵌入式执行
- 配置系统和插件系统决定了这个平台如何适配不同模型、不同通道和不同部署方式

## 项目形态

- 运行时：Node.js `>=22.12.0`
- 包管理：`pnpm`
- 仓库形态：多包 monorepo
- 核心入口：`openclaw.mjs` + `src/entry.ts`
- 主要产物：CLI、Gateway、Control UI、插件 SDK、移动端与桌面端外围应用
- 当前更适合先把它理解成：**“一个本地优先的 AI 助手平台 + 一个 CLI 驱动的 Gateway 服务器”**

## 推荐阅读顺序

### 第一阶段：CLI 启动与命令分发

回答两个问题：

- `openclaw` 命令到底从哪里开始执行
- CLI 是如何决定走快速路由、Commander 解析、还是子命令分发的

文档：[`phase-1-cli-startup.md`](phase-1-cli-startup.md)

### 第二阶段：Gateway 启动与控制平面

回答两个问题：

- `openclaw gateway` 是如何把一个控制面服务真正拉起来的
- Gateway 在启动时装配了哪些关键子系统

文档：[`phase-2-gateway-startup.md`](phase-2-gateway-startup.md)

### 第三阶段：Agent 经由 Gateway 的执行链路

回答两个问题：

- `openclaw agent --message "..."`
  到底如何变成一次 Gateway 请求
- Gateway 收到 `agent` 请求后，如何绑定会话、分配 session、再把事件流回推给客户端

文档：[`phase-3-agent-via-gateway.md`](phase-3-agent-via-gateway.md)

### 第四阶段：配置、状态与插件扩展

回答两个问题：

- OpenClaw 的配置从哪里读、如何校验、如何注入环境变量
- 插件和扩展是如何被发现、加载、注册并接入 Gateway 的

文档：[`phase-4-config-and-plugins.md`](phase-4-config-and-plugins.md)

## 最适合先读的文件

1. `README.md`
2. `package.json`
3. `openclaw.mjs`
4. `src/entry.ts`
5. `src/cli/run-main.ts`
6. `src/cli/program/command-registry.ts`
7. `src/cli/gateway-cli/run.ts`
8. `src/gateway/server.impl.ts`
9. `src/commands/agent-via-gateway.ts`
10. `src/config/io.ts`
11. `src/plugins/loader.ts`
12. `src/plugin-sdk/index.ts`

## 推荐理解框架

读这个仓库时，尽量把具体实现映射到下面这 4 层：

- 入口层：`openclaw.mjs`、`src/entry.ts`、Commander 子命令注册
- 控制层：Gateway 启动、WebSocket 控制面、HTTP/UI 暴露、运行时状态
- 执行层：agent 请求、消息发送、会话路由、工具与事件流
- 扩展层：配置、插件、通道适配器、外部 extensions、技能系统

## 当前最重要的主链路

### 主链路 1：CLI 启动

`openclaw.mjs` -> `dist/entry.js` -> `src/entry.ts` -> `runCli()` -> `tryRouteCli()` / `buildProgram()` -> 子命令

### 主链路 2：Gateway 启动

`openclaw gateway` -> `src/cli/gateway-cli/run.ts` -> `startGatewayServer()` -> 配置迁移/插件装配/运行时状态创建/WS 处理器挂载

### 主链路 3：Agent 请求

`openclaw agent` -> `src/commands/agent-via-gateway.ts` -> `callGateway({ method: "agent" })` -> `src/gateway/server-methods/agent.ts`

### 主链路 4：插件装配

`loadConfig()` -> `loadOpenClawPlugins()` -> `discoverOpenClawPlugins()` -> manifest/registry/runtime -> Gateway methods / CLI commands / services

## 读源码时先忽略什么

- `apps/ios`、`apps/android`、`apps/macos`
  这些目录先知道它们是外围客户端即可，第一轮不用深挖
- `ui/`
  先把它理解成 Gateway 服务出来的控制 UI，等 Gateway 主链路清楚后再读
- 大量 channel 扩展
  第一轮不要并行读所有 `extensions/*`
- 各类 e2e/test 文件
  只有在验证某条链路时再回头看测试

## 已验证事实

- 仓库根 `package.json` 暴露了 `openclaw` CLI，入口是 `openclaw.mjs`
- `README.md` 明确把 Gateway 定义为 control plane
- `src/entry.ts` 做了环境修正、Windows 参数清洗、再动态加载 `cli/run-main.js`
- `src/cli/run-main.ts` 先尝试 route-first 快速路径，再回退到完整 Commander
- `src/cli/gateway-cli/run.ts` 负责网关参数解析与启动前保护
- `src/gateway/server.impl.ts` 是 Gateway 运行时装配中心
- `src/commands/agent-via-gateway.ts` 默认优先走 Gateway；失败时回退 embedded agent
- `src/config/io.ts` 是配置加载、include、环境变量替换、校验和默认值应用的核心入口
- `src/plugins/loader.ts` 是插件发现与加载主入口

## 待确认项

- 当前工作区是否已完整 `pnpm install` / `pnpm build`
- `dist/` 是否和源码保持同步
- 纯 Windows 环境下的完整运行体验是否与 README 推荐的 WSL2 一致
- 某些移动端、桌面端节点与 Gateway 的组合路径，是否需要单独开专题文档
