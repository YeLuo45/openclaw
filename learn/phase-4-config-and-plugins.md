# 第四阶段：配置、状态与插件扩展

> 理解 OpenClaw 如何把“静态配置 + 环境变量 + 插件发现 + 扩展注册”转换成运行时能力

## 本阶段要回答的问题

1. 配置文件从哪里找、怎么读、怎么校验、怎么应用默认值？
2. Gateway 和 CLI 的很多行为是在哪里被配置驱动的？
3. 插件与 extensions 是如何被发现、加载并接入系统的？
4. `plugin-sdk` 暴露的是什么层级的能力？

## 1. `src/config/io.ts`：配置系统的真实入口

如果说 `server.impl.ts` 是 Gateway 的装配中心，那么 `src/config/io.ts` 就是配置系统的装配中心。

它做的事情非常多，但可以压缩成下面几步：

```text
resolve config path
  -> 读取 JSON5
  -> 解析 $include
  -> 把 config.env 注入 process.env
  -> 做 ${VAR} 环境变量替换
  -> 路径归一化
  -> 应用默认值
  -> 结合插件 schema 做校验
  -> 必要时发出配置告警
```

## 2. 配置文件的定位方式

`createConfigIO()` 会根据：

- 显式传入的 `configPath`
- 环境变量
- 默认状态目录
- 默认候选文件路径

来决定最终应该读取哪个配置文件。

这说明 OpenClaw 的配置不是“只有一个固定绝对路径”，而是支持多来源解析。

再结合 `openclaw.mjs` 对 `OPENCLAW_STATE_DIR` 的提前设置，就能串起来：

- 入口先固定状态目录
- 配置系统再基于状态目录推导配置路径

## 3. 配置解析中的几个关键设计

### JSON5 而不是纯 JSON

配置读取是用 `JSON5`，这意味着用户配置拥有更好的可写性，例如注释和更宽松的语法。

### `$include`

配置支持 include 机制：

- 主配置可以拆分
- 子配置会在正式校验前被合并进来

这很适合大型配置或多环境配置。

### `config.env` 先注入环境

一个非常值得注意的步骤是：

- 如果配置里定义了 `env`
- 会先把这些值注入 `process.env`
- 再做 `${VAR}` 替换

这意味着 OpenClaw 支持一种“配置中定义环境，再被配置其他部分引用”的模式。

### 默认值与校验不是分离散落的

文件顶部能直接看到大量默认值应用函数：

- `applyAgentDefaults`
- `applyLoggingDefaults`
- `applyMessageDefaults`
- `applyModelDefaults`
- `applySessionDefaults`
- `applyCompactionDefaults`
- `applyContextPruningDefaults`

这意味着 OpenClaw 的配置不是“读到什么就原样给业务”，而是会被系统加工成一份更稳定的运行时配置。

## 4. 配置系统为什么对整个项目这么重要

前面几阶段看到的很多关键行为，都依赖配置层：

- Gateway 绑定方式
- 认证模式
- Tailscale 暴露策略
- 默认 agent
- 各类 channel 配置
- 发送策略与 session 行为
- 插件启用状态
- 模型和 provider 默认值

所以如果你以后要改 OpenClaw 行为边界，很多时候第一站不是 `server.impl.ts`，而是先回到配置层看这个行为是否已被配置化。

## 5. `src/plugins/loader.ts`：插件系统主入口

这个文件是插件系统的核心装配器。

它的大致流程是：

```text
loadOpenClawPlugins()
  -> 归一化 plugins 配置
  -> 构造缓存 key
  -> 清理旧插件命令
  -> createPluginRuntime()
  -> createPluginRegistry()
  -> discoverOpenClawPlugins()
  -> loadPluginManifestRegistry()
  -> 解析 openclaw/plugin-sdk 别名
  -> 用 jiti 加载插件模块
  -> 生成 registry/plugin records
  -> 注册工具、命令、gateway methods、services 等能力
```

## 6. 插件加载的几个关键设计

### 支持缓存

`registryCache` 表示插件注册结果可以缓存，避免每次都全量重新发现与加载。

### 先 discovery，再 manifest，再 runtime

这套分层很清晰：

- discovery：先发现候选插件
- manifest registry：读取插件元信息
- runtime/registry：真正构造插件运行时与注册表

这样的好处是：

- 诊断更容易做
- 只验证插件结构时不必完整激活
- 同一插件既能做“发现/展示”，也能做“实际加载”

### 使用 `jiti` 动态加载

这说明插件不必强依赖单一构建形态：

- TS / JS 插件都更容易接入
- 运行时可以动态 import / execute

### `openclaw/plugin-sdk` 别名解析

加载器会主动寻找 `src/plugin-sdk/index.ts` 或 `dist/plugin-sdk/index.js`，把它作为插件 SDK 别名注入。

这说明插件作者面对的不是仓库内部一堆私有路径，而是一套稳定的 SDK 入口。

## 7. 插件系统给 Gateway 带来的能力

从 `PluginRecord` 的字段就能看出插件能扩展哪些方向：

- `toolNames`
- `hookNames`
- `channelIds`
- `providerIds`
- `gatewayMethods`
- `cliCommands`
- `services`
- `commands`
- `httpHandlers`

这非常关键，因为它说明插件不是只能“加一个工具”。

在 OpenClaw 里，插件理论上可以扩展：

- Gateway 方法
- CLI 命令
- 通道适配器
- hooks
- provider
- HTTP handler
- service

换句话说，**插件系统本身就是平台化设计的一部分**。

## 8. `plugin-sdk/index.ts`：对外暴露的稳定契约

`src/plugin-sdk/index.ts` 不承担复杂逻辑，但它暴露了大量稳定类型与工具：

- channel adapter 相关类型
- plugin API / service 类型
- Gateway request handler 类型
- config schema 相关能力
- routing、group policy、typing、reply、allowlist 等通道基础能力

这告诉我们两件事：

1. OpenClaw 插件不是“野生脚本注入”
2. 仓库作者已经在有意识地把内部平台能力整理成可复用 SDK

也就是说，`plugin-sdk` 是平台外延能力的正式边界。

## 9. `extensions/` 目录该怎么理解

在第一轮学习里，不建议并行阅读所有 `extensions/*`。更好的理解方式是：

- 把 `extensions/` 看成平台能力样本库
- 它们展示了 OpenClaw 如何把不同通道、认证方式、记忆后端、观测能力做成独立扩展

第一轮只需知道：

- 核心平台在 `src/`
- 外延能力样本在 `extensions/`
- 稳定接缝在 `plugin-sdk`

如果要深挖，再挑一个典型 extension 单独开专题。

## 10. 这一阶段最重要的认识

### 配置不是附属品，而是运行时输入

OpenClaw 的很多行为并不硬编码在主逻辑里，而是：

- 先从配置里决定
- 再在 Gateway/CLI 里执行

### 插件系统不是单点补丁，而是平台骨架的一部分

从 loader、registry、runtime、SDK 的配合可以看出：

- OpenClaw 一开始就不是只为内建能力设计
- 它把通道、命令、Gateway 方法、服务都放进了可扩展空间

## 看完四个阶段后，你应该已经能回答

1. `openclaw` 命令是如何启动的
2. Gateway 为什么是 control plane
3. `openclaw agent` 为什么默认走 Gateway 而不是纯本地
4. 配置和插件为什么是 OpenClaw 的能力边界，而不是辅助细节

## 后续专题建议

如果继续深挖，推荐按这个顺序开专题：

1. `extensions/*` 中任选一个真实通道扩展
2. `ui/` 控制 UI 如何与 Gateway 协作
3. `skills/` 与 agent/runtime 的接缝
4. `apps/macos`、`apps/ios`、`apps/android` 如何作为节点接入 Gateway
