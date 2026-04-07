# 第二阶段：Gateway 启动与控制平面

> 理解 `openclaw gateway` 如何把一个“控制平面”真正装配成可运行的服务

## 启动链路总览

```text
openclaw gateway ...
  -> register gateway command
  -> src/cli/gateway-cli/run.ts
    -> 解析参数 / 保护性检查 / 读取配置
    -> startGatewayServer(port, opts)
      -> src/gateway/server.impl.ts
        -> 配置迁移与校验
        -> 插件与通道方法装配
        -> 运行时配置解析
        -> createGatewayRuntimeState()
        -> attachGatewayWsHandlers()
        -> startGatewaySidecars() / timers / discovery / tailscale / heartbeat
```

## 1. `src/cli/gateway-cli/run.ts`：网关命令入口

这个文件的职责不是“真正实现 Gateway”，而是 **把 CLI 参数变成一个可安全启动的 Gateway 运行上下文**。

### 它做的几件关键事

- 打开时间戳日志和 verbose
- 处理 `--ws-log`、`--raw-stream`、`--raw-stream-path`
- dev 模式下准备专用网关配置
- 读取配置并决定实际 port
- 如有 `--force`，先清掉占用端口的进程
- 校验 auth、bind、tailscale 组合是否合法
- 检查配置文件是否存在，以及 `gateway.mode` 是否允许本地启动

### 为什么这个文件值得重点读

因为它暴露了 OpenClaw 在启动 Gateway 前最重视的那些约束：

- **网关暴露面必须与认证策略一致**
- **绑定到非 loopback 地址必须携带共享密钥**
- **配置错误要在服务真正启动前失败**

换句话说，`run.ts` 体现的是“运维与安全边界”，不是业务边界。

## 2. `startGatewayServer()`：Gateway 的真正装配中心

`src/gateway/server.impl.ts` 是整个仓库里最关键的文件之一。可以把它看成 OpenClaw 的“控制平面装配工厂”。

它的大致职责是：

1. 修正和校验配置
2. 装配插件、通道、方法表
3. 构造运行时状态
4. 启动 HTTP / WS / Canvas / UI / sidecars
5. 挂上事件广播、会话、节点、诊断、重载等外围能力

## 3. 启动前半段：先把配置问题解决

`startGatewayServer()` 一开始就做了很重的配置相关工作：

- 读取配置快照
- 检测 legacy 配置项
- 必要时自动迁移旧配置并写回
- 如果配置无效，直接抛错并提示运行 `openclaw doctor`
- 自动启用部分插件并尝试持久化这些变更

这说明 Gateway 并不是“拿到配置就直接跑”，而是先做一轮 **启动前的配置收敛**。

这一点非常重要，因为后面的大量运行时状态都依赖这份配置：

- 默认 agent
- workspace
- auth
- Tailscale
- 控制 UI
- 各类 channel plugin
- diagnostics

## 4. Gateway 装配的第一批关键对象

在配置可用后，`server.impl.ts` 会继续装配以下核心对象：

### 默认 agent 与工作区

- `resolveDefaultAgentId()`
- `resolveAgentWorkspaceDir()`

这说明 Gateway 启动时就已经在思考“默认由哪个 agent 工作、它的 workspace 在哪里”。

### 插件注册与方法表

- `loadGatewayPlugins()`
- `listChannelPlugins()`
- `listGatewayMethods()`

这里有一个关键设计：

- **Gateway 的方法集合不是纯内建写死的**
- 它会把 core methods、plugin methods、channel methods 合并成最终的 `gatewayMethods`

这也是为什么 OpenClaw 更像一个平台，而不是单体脚本：很多能力是通过插件和通道适配器接入的。

### 运行时配置解析

- `resolveGatewayRuntimeConfig()`

它会统一决定：

- bind host
- control UI 是否开启
- OpenAI Chat Completions / Responses HTTP 端点是否开启
- auth 与 tailscale 的最终配置
- hooks / canvas 等开关结果

这一层很像“把静态配置翻译成可执行运行策略”的步骤。

## 5. `createGatewayRuntimeState()`：真正创建服务运行时

这是 Gateway 装配中最关键的一步之一。

从返回值可以看出，它一口气建立了很多核心运行时对象：

- `httpServer`
- `httpServers`
- `wss`
- `clients`
- `broadcast`
- `agentRunSeq`
- `dedupe`
- `chatRunState`
- `chatAbortControllers`
- `canvasHost`

这说明 Gateway 的本质不是“只监听一个端口”，而是维护一整套控制面状态机：

- 客户端连接
- 请求去重
- agent 流式输出序号
- chat 流缓冲
- 中断控制
- UI / Canvas 宿主

## 6. 事件与附属系统接线

在主运行时创建完成后，`server.impl.ts` 还会继续挂载很多外围能力：

- `NodeRegistry`
- `createNodeSubscriptionManager()`
- `attachGatewayWsHandlers()`
- `createAgentEventHandler()`
- `startGatewaySidecars()`
- `startGatewayDiscovery()`
- `startGatewayMaintenanceTimers()`
- `buildGatewayCronService()`
- `startGatewayTailscaleExposure()`
- `startHeartbeatRunner()`
- `startGatewayConfigReloader()`

### 这透露出的架构事实

Gateway 并不是一个单纯的“请求进来，响应出去”的 HTTP 服务，而是同时扮演：

- WebSocket 控制总线
- 节点与客户端连接中心
- agent 事件转发中心
- cron / maintenance / discovery 的宿主
- Control UI 与 Canvas 的服务端

所以 README 把它称为 control plane 是非常准确的。

## 7. `server-chat.ts`：Agent 事件如何变成广播消息

虽然这个文件不负责启动 Gateway，但它揭示了一个非常重要的事实：

- agent 运行中的 delta/final/error 事件，会被转换成 Gateway 对外广播的 `chat` 事件
- 同时还能发给订阅该 session 的 node

其中最关键的对象有：

- `chatRunState.registry`
- `buffers`
- `deltaSentAt`
- `agentRunSeq`

这说明 OpenClaw 在 Gateway 层维护了 **agent 事件流到 chat 广播流的映射关系**。

这也是为什么后面的 `openclaw agent` 命令并不是简单的“一次 RPC 返回一个字符串”，而更像一条有状态的执行流。

## 8. 这一阶段最重要的认识

### Gateway 启动不是单步动作

它至少分成几层：

1. CLI 参数与安全边界校验
2. 配置迁移与配置合法化
3. 插件/通道/方法表装配
4. HTTP/WS/Canvas/UI 运行时创建
5. 事件、节点、定时器、发现、重载等外围系统接线

### `server.impl.ts` 是二次阅读价值最高的文件

如果你只想抓主框架，不必通读所有子模块，先看它如何：

- 读配置
- 组装 methods
- 创建设备/节点/会话状态
- 挂 WS handlers
- 启动 sidecars

就足够建立全局心智模型。

## 推荐下一步

看完 Gateway 启动后，进入 `phase-3-agent-via-gateway.md`。因为 Gateway 的价值最终要落到一条真实业务链路上，而 `openclaw agent` 正是最好的样本。
