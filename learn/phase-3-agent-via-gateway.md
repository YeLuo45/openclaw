# 第三阶段：Agent 经由 Gateway 的执行链路

> 理解 `openclaw agent --message "..."` 如何从 CLI 请求变成一次带会话语义的 Gateway agent 执行

## 主链路总览

```text
openclaw agent --message "..."
  -> src/cli/program/register.agent.ts
    -> agentCliCommand()
      -> 默认走 agentViaGatewayCommand()
        -> loadConfig()
        -> resolveSessionKeyForRequest()
        -> callGateway({ method: "agent" })
          -> GatewayClient 连接 Gateway
            -> Gateway method: "agent"
              -> src/gateway/server-methods/agent.ts
                -> 参数校验 / 会话解析 / 去重 / 交付计划
                -> agentCommand(...)
                -> 事件流由 createAgentEventHandler() 转换成 chat/agent 广播
```

## 1. `register.agent.ts`：命令面的真实定位

这个文件最值得注意的一句话是：

```text
Run an agent turn via the Gateway (use --local for embedded)
```

这意味着：

- 默认模式：**通过 Gateway 跑 agent**
- 显式 `--local`：才走嵌入式本地执行

这和很多人的第一直觉不同。OpenClaw 并不是默认“本地 CLI 直接调模型”，而是默认把 Gateway 当成控制面入口。

## 2. `agentCliCommand()`：默认先远程，失败再回退

`src/commands/agent-via-gateway.ts` 最关键的逻辑在 `agentCliCommand()`：

```text
if (--local) {
  agentCommand(...)
} else {
  try {
    agentViaGatewayCommand(...)
  } catch {
    提示 Gateway 失败
    回退到 embedded agentCommand(...)
  }
}
```

这体现了一个很实用的设计取舍：

- 优先保持与 Gateway 体系一致
- 但不要把 CLI 可用性完全绑定在 Gateway 在线状态上

也就是说，Gateway 是首选控制面，但不是唯一出路。

## 3. `agentViaGatewayCommand()`：CLI 侧的请求装配

这个函数负责把用户命令行参数整理成一个真正可发送的 Gateway 请求。

### 它先做的事情

- 检查 `--message` 是否存在
- 要求用户至少提供 `--to`、`--session-id` 或 `--agent`
- 读取配置 `loadConfig()`
- 如果显式指定 `agent`，会先验证该 agent 是否存在
- 解析 timeout
- 计算 `sessionKey`
- 归一化 `channel`
- 生成 `idempotencyKey`

### 然后真正调用 Gateway

它会发起：

```text
callGateway({
  method: "agent",
  params: {
    message,
    agentId,
    to,
    sessionId,
    sessionKey,
    thinking,
    deliver,
    channel,
    replyChannel,
    replyAccountId,
    timeout,
    lane,
    extraSystemPrompt,
    idempotencyKey
  },
  expectFinal: true
})
```

从这里可以读出 3 个非常重要的事实：

1. OpenClaw 的 agent 调用不是“裸 prompt”，而是强绑定会话与路由上下文  
2. `deliver`、`replyChannel`、`replyAccountId` 表明执行结果可以重新投递回消息通道  
3. `idempotencyKey` 说明 Gateway 层把 agent 请求当成一个需要去重和可重试管理的任务

## 4. `callGateway()`：CLI 到 Gateway 的控制面 RPC

`src/gateway/call.ts` 是 CLI 侧的 Gateway 连接抽象。

它负责解决几个问题：

- Gateway 目标 URL 到底是什么
- 当前是在 local mode 还是 remote mode
- token/password 从哪里取
- 本地 TLS 指纹如何处理
- 连接超时与关闭错误如何解释

### 一条重要线索

`buildGatewayConnectionDetails()` 会把连接目标推导成：

- 本地 loopback
- 本地 tailnet
- 远程 URL
- 或配置错误提示

这说明 OpenClaw 的 CLI 从设计上就支持多种 Gateway 部署形态，而不是把 Gateway 写死为“永远本机回环地址”。

### `GatewayClient`

`callGateway()` 最终构造 `GatewayClient`，在 `onHelloOk` 后发送真正的 RPC 请求：

```text
client.request(opts.method, opts.params, { expectFinal })
```

这表明 Gateway 协议本质上是 **带握手的 WebSocket RPC**。

## 5. `server-methods/agent.ts`：Gateway 侧真正处理 `agent` 请求

这是第三阶段最重要的文件。

它首先会做严格的参数校验：

- `validateAgentParams()`
- 校验 channel 是否属于已知 Gateway channel
- 校验 agent id 是否存在
- 解析和规范化附件
- 对消息注入 timestamp

### 去重

它会先用：

```text
context.dedupe.get(`agent:${idempotencyKey}`)
```

如果命中过去的结果，就直接返回缓存响应。

这说明 `idempotencyKey` 不只是“留给以后用”，而是 Gateway 端真的拿它做请求去重。

## 6. 会话解析：这是 OpenClaw agent 链路最关键的部分

`agent.ts` 里最值得花时间理解的，不是单纯的调用 `agentCommand()`，而是它前面的 **session 解析与继承逻辑**。

它会处理这些事情：

- `sessionKey` 是否显式给出
- `agentId` 与 `sessionKey` 是否匹配
- 读取已有 session entry
- 如果没有 session，则生成新的 `sessionId`
- 继承 label、spawnedBy、groupId、groupChannel、space 等上下文
- 归一化 delivery fields
- 更新 session store
- 解析 send policy

这说明在 OpenClaw 里，agent 运行不是无状态函数调用，而是依附于：

- agent 身份
- 会话键
- 组上下文
- 交付策略
- 历史会话存储

理解这一点后，很多 OpenClaw 的设计都能串起来：它更像“一个长期存在的个人助手系统”，而不是一次性 prompt 工具。

## 7. 交付计划：执行结果不仅能返回，还能投递

在解析完 session 之后，`agent.ts` 还会继续计算：

- `resolveAgentDeliveryPlan()`
- `resolveAgentOutboundTarget()`

这两步代表的语义是：

- 这次 agent 执行的结果，是否要发回某个消息通道
- 发到哪个 channel、哪个 target、哪个 account

这也解释了为什么 CLI 参数里会有：

- `--deliver`
- `--reply-channel`
- `--reply-to`
- `--reply-account`

OpenClaw 的 agent 不只是“在终端回一段文本”，而是可以回流到真实聊天表面。

## 8. 事件流：Gateway 如何把 agent 进度广播出去

虽然 `agent.ts` 负责请求处理，但真正把 agent 执行过程广播给外部的是 `createAgentEventHandler()`。

这个处理器会把 agent 事件变成两类对外信号：

- `chat` 事件
- `agent` 事件

其中：

- delta 文本会被整理成连续 chat 更新
- final 完成会变成 `state: "final"`
- error 会变成错误广播
- 是否发 tool 事件，还受 session verbose 配置影响

这说明 OpenClaw 的 Gateway 不只是 RPC 入口，也是 **agent 运行期事件总线**。

## 9. 这一阶段最该记住什么

### 从 CLI 视角

- `openclaw agent` 默认不是本地模式，而是 Gateway 模式
- CLI 在发请求前会认真构造 sessionKey、channel、timeout、idempotencyKey

### 从 Gateway 视角

- `agent` 方法是一个强状态、强上下文、可去重的执行入口
- session store 与 delivery plan 是这个链路的核心价值
- agent 结果不是只在当前 CLI 内消费，还会变成 Gateway 广播流

## 建议回看哪些文件

如果第三阶段只允许回看 5 个文件，优先回看这几个：

1. `src/cli/program/register.agent.ts`
2. `src/commands/agent-via-gateway.ts`
3. `src/gateway/call.ts`
4. `src/gateway/server-methods/agent.ts`
5. `src/gateway/server-chat.ts`

## 推荐下一步

进入 `phase-4-config-and-plugins.md`。因为你已经知道主链路怎样跑起来了，接下来就要理解：这些行为到底是如何被配置、扩展和插件化的。
