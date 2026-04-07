# 第一阶段：CLI 启动与命令分发

> 从 `openclaw` 命令启动，到真正进入具体子命令执行逻辑的主链路

## 启动链路总览

```text
openclaw ...
  -> openclaw.mjs
    -> import("./dist/entry.js")
      -> src/entry.ts
        -> 环境修正 / Windows argv 清洗 / profile 处理
        -> import("./cli/run-main.js")
          -> runCli(argv)
            -> tryRouteCli()      // 部分命令的快速路径
            -> buildProgram()     // Commander 主程序
            -> registerProgramCommands()
            -> program.parseAsync()
```

## 1. `openclaw.mjs`：发布入口

这是 npm 安装后用户真正命中的入口。

它只做两件高价值的事情：

1. **提前固定状态目录**
   - 如果没有设置 `OPENCLAW_STATE_DIR`，就默认把状态目录放到用户主目录下的 `.openclaw`
   - 在 Windows 上优先使用 `USERPROFILE`，避免落到不符合用户直觉的位置

2. **尽可能早地打开 compile cache**
   - 如果 Node 支持 `module.enableCompileCache()` 且没有被显式关闭，就启用它
   - 这类代码的作用不是业务逻辑，而是让 CLI 冷启动成本更低

最后它只做一件关键动作：

```text
await import("./dist/entry.js")
```

这说明发布态真正的业务入口不在 `openclaw.mjs` 本身，而在编译后的 `dist/entry.js`，其源码对应 `src/entry.ts`。

## 2. `src/entry.ts`：真实启动桥梁

`src/entry.ts` 是 CLI 的真正逻辑入口。这个文件可以把它看成“启动前整备层”。

### 它先做的事情

- 设置进程标题：`process.title = "openclaw"`
- 安装 warning filter
- 归一化环境变量
- 处理 `--no-color`

这些不是业务功能，但它们保证后续 CLI 行为更一致。

### 一个很重要的设计：必要时自我重启

`ensureExperimentalWarningSuppressed()` 会检查：

- 是否已经禁止 ExperimentalWarning
- 是否已经做过这一步
- 是否被 `OPENCLAW_NO_RESPAWN` 禁止

如果没有准备好，它会：

- 把 `--disable-warning=ExperimentalWarning` 注入 `NODE_OPTIONS`
- 用当前参数重新 `spawn(process.execPath, ...)`
- 父进程退出，子进程继续执行

这是一种很典型的 CLI 启动技巧：**为了保证全局运行时环境一致，宁可在最前面多做一次轻量 respawn**。

### Windows 参数清洗

`normalizeWindowsArgv()` 说明作者专门处理过 Windows 场景：

- 去掉多余的 `node.exe`
- 去掉控制字符
- 修正奇怪的参数包裹与路径前缀

这意味着 OpenClaw 不是只在类 Unix 环境里考虑运行，它对 Windows CLI 包装层做了额外兼容。

### profile 处理

在真正进入 CLI 主逻辑前，它还会：

- 解析 profile 参数
- 应用 `applyCliProfileEnv()`
- 再把修正后的 `argv` 交给后面的 Commander

这类代码的价值在于：**让 profile 的语义在“早期 ad-hoc 判断”和“后续 Commander 解析”之间保持一致**。

## 3. `src/cli/run-main.ts`：CLI 主调度器

这个文件是理解整个 CLI 命令面的关键。

它的核心流程可以压缩成：

```text
runCli()
  -> loadDotEnv()
  -> normalizeEnv()
  -> ensureOpenClawCliOnPath()
  -> assertSupportedRuntime()
  -> tryRouteCli()
  -> enableConsoleCapture()
  -> buildProgram()
  -> 可选懒加载主子命令
  -> 可选注册插件 CLI 命令
  -> program.parseAsync()
```

### 启动前保护

在进入命令分发前，它先统一做：

- `.env` 加载
- 环境变量归一化
- 确保 `openclaw` CLI 在 PATH 中可见
- Node 版本校验

说明 OpenClaw 的设计偏向“启动前把环境问题尽早暴露”，而不是让命令跑到半路才失败。

## 4. `tryRouteCli()`：快速路径

`src/cli/route.ts` 提供了 route-first 模式。

它的大致逻辑是：

```text
tryRouteCli(argv)
  -> 如果显式禁用快速路由，则跳过
  -> 如果是 --help / --version，则跳过
  -> 提取 command path
  -> findRoutedCommand(path)
  -> prepareRoutedCommand()
  -> route.run(argv)
```

这里的设计思想很重要：

- 某些命令可以绕开完整 Commander 装配，直接走轻量路径
- 这样可以减少不必要的初始化、插件注册和帮助系统负担

这和很多大型 CLI 的做法一致：**把少数高频、结构稳定、输入简单的命令走快速通道**。

## 5. `buildProgram()` 与命令注册表

`src/cli/program/build-program.ts` 很薄，但它把 CLI 的主要骨架串起来了：

```text
new Command()
  -> createProgramContext()
  -> configureProgramHelp()
  -> registerPreActionHooks()
  -> registerProgramCommands()
```

### `command-registry.ts` 是命令全景图

这个文件很适合作为第二阅读入口，因为它能快速回答：

- OpenClaw 提供了哪些一级能力
- 哪些命令有 route-first 快速路径
- 哪些命令会触发插件加载

当前能直接读到的一级命令包括：

- `setup`
- `onboard`
- `configure`
- `config`
- `maintenance`
- `message`
- `memory`
- `agent`
- `browser`
- `status`
- `health`
- `sessions`

其中 `status`、`health`、`sessions`、`agents list`、`memory status` 有明确的 route-first 处理。

## 6. `register.agent.ts`：理解一个真实子命令

读完整个命令注册表后，建议立刻挑一个真实命令看深一点。这里最值得读的是 `agent`。

原因有两个：

1. 它直接连向 Gateway 与 agent 主链路
2. 它同时展示了 OpenClaw 的 CLI 风格：参数声明、帮助示例、runtime 包装、默认依赖装配

这里能看出一个关键定位：

- 默认 `openclaw agent` 是 **经由 Gateway 运行**
- `--local` 才是嵌入式本地执行

这再次印证 README 的说法：**Gateway 是控制平面，CLI 更像是控制面客户端**。

## 7. 这一阶段真正要记住什么

### 核心认识

- `openclaw.mjs` 只是发布入口，不是业务主脑
- `src/entry.ts` 负责运行时环境修正与跨平台兼容
- `src/cli/run-main.ts` 是 CLI 主调度器
- OpenClaw 采用了 **快速路由 + 完整 Commander 回退** 的双路径设计
- 命令注册表是理解整个产品能力面的最佳目录

### 关键设计模式

- 提前固定状态目录
- 启动前统一环境修正
- Windows 特殊参数清洗
- 必要时 respawn 进程以统一 Node 运行参数
- route-first 快速路径
- 子命令与插件命令按需注册

## 推荐下一步

看完本阶段后，直接进入 `phase-2-gateway-startup.md`，因为 CLI 的很多命令最终都会通向 Gateway，而 Gateway 才是 OpenClaw 的真正控制核心。
