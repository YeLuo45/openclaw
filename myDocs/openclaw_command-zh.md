# OpenClaw CLI 命令参考

本文档由本仓库 CLI 的 `--help` / `-h` 输出整理而成，便于离线查阅。在线文档：[https://docs.openclaw.ai/cli](https://docs.openclaw.ai/cli)。

## 在 Windows 上查看帮助

在仓库根目录执行（按你的实际路径调整）：

```powershell
cd G:\WS\ai-tools\opensource\openclaw
node .\openclaw.mjs --help
node .\openclaw.mjs gateway -h
node .\openclaw.mjs message send -h
```

说明：若 PowerShell/控制台代码页不是 UTF-8，帮助里自带的表情等装饰字符可能显示为乱码，不影响命令名与选项阅读。

## 顶层命令一览

以附录 A 中 `Commands:` 列表为准（与 `node openclaw.mjs --help` 一致）。

---

## 附录 A：根命令 `openclaw --help`

```text
馃 OpenClaw 2026.2.1 (bdaf1ee) 鈥?Ship fast, log faster.

Usage: openclaw [options] [command]

Options:
  -V, --version     输出版本号
  --dev             开发配置文件：将状态隔离在 ~/.openclaw-dev 下，默认
                    网关端口 19001，并偏移派生端口（browser/canvas）
  --profile <name>  使用命名的配置文件（将
                    OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH 隔离在
                    ~/.openclaw-<name> 下）
  --no-color        禁用 ANSI 颜色
  -h, --help        显示命令帮助

Commands:
  setup             初始化 ~/.openclaw/openclaw.json 和代理工作区
  onboard           设置网关、工作区和
                    技能的交互式向导
  configure         设置凭据、设备和代理
                    默认值的交互式提示
  config            配置辅助工具（get/set/unset）。不带子命令运行将
                    启动向导。
  doctor            网关和通道的健康检查 + 快速修复
  dashboard         使用当前令牌打开控制 UI
  reset             重置本地配置/状态（保留 CLI 安装）
  uninstall         卸载网关服务 + 本地数据（保留 CLI）
  message           发送消息和通道操作
  memory            内存搜索工具
  agent             通过网关运行一次代理（使用 --local 进行嵌入式运行）
  agents            管理隔离的代理（工作区 + 认证 + 路由）
  acp               Agent Control Protocol 工具
  gateway           网关控制
  daemon            网关服务（旧别名）
  logs              网关日志
  system            系统事件、心跳和在线状态
  models            模型配置
  approvals         执行审批
  nodes             节点命令
  devices           设备配对 + 令牌管理
  node              节点控制
  sandbox           沙盒工具
  tui               终端 UI
  cron              Cron 调度程序
  dns               DNS 辅助工具
  docs              文档辅助工具
  hooks             钩子工具
  webhooks          Webhook 辅助工具
  pairing           配对辅助工具
  plugins           插件管理
  channels          通道管理
  directory         目录命令
  security          安全辅助工具
  skills            技能管理
  update            CLI 更新辅助工具
  completion        生成 shell 自动补全脚本
  status            显示通道健康状态和最近会话收件人
  health            从运行中的网关获取健康状态
  sessions          列出存储的对话会话
  browser           管理 OpenClaw 的专用浏览器 (Chrome/Chromium)
  help              显示命令帮助

Examples:
  openclaw channels login --verbose
    链接个人 WhatsApp Web 并显示二维码 + 连接日志。
  openclaw message send --target +15555550123 --message "Hi" --json
    通过您的 web 会话发送并打印 JSON 结果。
  openclaw gateway --port 18789
    在本地运行 WebSocket 网关。
  openclaw --dev gateway
    在 ws://127.0.0.1:19001 上运行开发网关（隔离的状态/配置）。
  openclaw gateway --force
    终止绑定到默认网关端口的任何进程，然后启动它。
  openclaw gateway ...
    通过 WebSocket 进行网关控制。
  openclaw agent --to +15555550123 --message "Run summary" --deliver
    使用网关直接与代理对话；可选择发送 WhatsApp 回复。
  openclaw message send --channel telegram --target @mychat --message "Hi"
    通过您的 Telegram 机器人发送。

Docs: https://docs.openclaw.ai/cli
```

---

## 附录 B：子命令帮助树（`setup` … `browser` 等）

以下片段来自一次性递归 `helpInformation()`（设置环境变量 `OPENCLAW_DISABLE_LAZY_SUBCOMMANDS=1` 时构建；因注册过程异步，**未包含** `gateway`/`plugins` 等懒加载顶层命令，其完整 `-h` 见附录 C）。**根命令列表若与附录 A 不一致，以附录 A 为准。**

```text
========================================================================
openclaw
========================================================================

Usage: openclaw [options] [command]

Options:
  -V, --version     输出版本号
  --dev             开发配置文件：将状态隔离在 ~/.openclaw-dev 下，默认
                    网关端口 19001，并偏移派生端口（browser/canvas）
  --profile <name>  使用命名的配置文件（将
                    OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH 隔离在
                    ~/.openclaw-<name> 下）
  --no-color        禁用 ANSI 颜色
  -h, --help        显示命令帮助

Commands:
  setup             初始化 ~/.openclaw/openclaw.json 和代理工作区
  onboard           设置网关、工作区和
                    技能的交互式向导
  configure         设置凭据、设备和代理
                    默认值的交互式提示
  config            配置辅助工具（get/set/unset）。不带子命令运行将
                    启动向导。
  doctor            网关和通道的健康检查 + 快速修复
  dashboard         使用当前令牌打开控制 UI
  reset             重置本地配置/状态（保留 CLI 安装）
  uninstall         卸载网关服务 + 本地数据（保留 CLI）
  message           发送消息和通道操作
  memory            内存搜索工具
  agent             通过网关运行一次代理（使用 --local 进行嵌入式运行）
  agents            管理隔离的代理（工作区 + 认证 + 路由）
  status            显示通道健康状态和最近会话收件人
  health            从运行中的网关获取健康状态
  sessions          列出存储的对话会话
  browser           管理 OpenClaw 的专用浏览器 (Chrome/Chromium)
  help              显示命令帮助


========================================================================
openclaw setup
========================================================================

Usage: openclaw setup [options]

初始化 ~/.openclaw/openclaw.json 和代理工作区

Options:
  --workspace <dir>       代理工作区目录 (默认:
                          ~/.openclaw/workspace; 存储为
                          agents.defaults.workspace)
  --wizard                运行交互式引导向导 (默认: false)
  --non-interactive       在无提示情况下运行向导 (默认: false)
  --mode <mode>           向导模式: local|remote
  --remote-url <url>      远程网关 WebSocket URL
  --remote-token <token>  远程网关令牌 (可选)
  -h, --help              显示命令帮助


========================================================================
openclaw onboard
========================================================================

Usage: openclaw onboard [options]

设置网关、工作区和技能的交互式向导

Options:
  --workspace <dir>              代理工作区目录 (默认:
                                 ~/.openclaw/workspace)
  --reset                        重置配置 + 凭据 + 会话 +
                                 工作区，然后再运行向导
  --non-interactive              无提示运行 (默认: false)
  --accept-risk                  承认代理功能强大且拥有完整
                                 系统访问权限存在风险 (使用 --non-interactive
                                 时必需) (默认: false)
  --flow <flow>                  向导流程: quickstart|advanced|manual
  --mode <mode>                  向导模式: local|remote
  --auth-choice <choice>         认证:
                                 setup-token|token|chutes|openai-codex|openai-api-key|openrouter-api-key|ai-gateway-api-key|moonshot-api-key|kimi-code-api-key|synthetic-api-key|venice-api-key|gemini-api-key|zai-api-key|xiaomi-api-key|apiKey|minimax-api|minimax-api-lightning|opencode-zen|skip
  --token-provider <id>          令牌提供者 ID (非交互式；与
                                 --auth-choice token 一起使用)
  --token <token>                令牌值 (非交互式；与
                                 --auth-choice token 一起使用)
  --token-profile-id <id>        认证配置文件 ID (非交互式；默认:
                                 <provider>:manual)
  --token-expires-in <duration>  可选的令牌过期时间 (例如 365d, 12h)
  --anthropic-api-key <key>      Anthropic API 密钥
  --openai-api-key <key>         OpenAI API 密钥
  --openrouter-api-key <key>     OpenRouter API 密钥
  --ai-gateway-api-key <key>     Vercel AI Gateway API 密钥
  --moonshot-api-key <key>       Moonshot API 密钥
  --kimi-code-api-key <key>      Kimi Coding API 密钥
  --gemini-api-key <key>         Gemini API 密钥
  --zai-api-key <key>            Z.AI API 密钥
  --xiaomi-api-key <key>         Xiaomi API 密钥
  --minimax-api-key <key>        MiniMax API 密钥
  --synthetic-api-key <key>      Synthetic API 密钥
  --venice-api-key <key>         Venice API 密钥
  --opencode-zen-api-key <key>   OpenCode Zen API 密钥
  --gateway-port <port>          网关端口
  --gateway-bind <mode>          网关绑定: loopback|tailnet|lan|auto|custom
  --gateway-auth <mode>          网关认证: token|password
  --gateway-token <token>        网关令牌 (令牌认证)
  --gateway-password <password>  网关密码 (密码认证)
  --remote-url <url>             远程网关 WebSocket URL
  --remote-token <token>         远程网关令牌 (可选)
  --tailscale <mode>             Tailscale: off|serve|funnel
  --tailscale-reset-on-exit      退出时重置 tailscale serve/funnel
  --install-daemon               安装网关服务
  --no-install-daemon            跳过网关服务安装
  --skip-daemon                  跳过网关服务安装
  --daemon-runtime <runtime>     守护进程运行时: node|bun
  --skip-channels                跳过通道设置
  --skip-skills                  跳过技能设置
  --skip-health                  跳过健康检查
  --skip-ui                      跳过控制 UI/TUI 提示
  --node-manager <name>          技能的节点管理器: npm|pnpm|bun
  --json                         输出 JSON 摘要 (默认: false)
  -h, --help                     显示命令帮助


========================================================================
openclaw configure
========================================================================

Usage: openclaw configure [options]

设置凭据、设备和代理默认值的交互式提示

Options:
  --section <section>  配置部分 (可重复)。选项: workspace,
                       model, web, gateway, daemon, channels, skills, health
                       (默认: [])
  -h, --help           显示命令帮助


========================================================================
openclaw config
========================================================================

Usage: openclaw config [options] [command]

配置辅助工具 (get/set/unset)。不带子命令运行将启动向导。

Options:
  --section <section>  配置向导部分 (可重复)。在没有
                       子命令的情况下使用。(默认: [])
  -h, --help           显示命令帮助

Commands:
  get                  通过点路径获取配置值
  set                  通过点路径设置配置值
  unset                通过点路径移除配置值


========================================================================
openclaw config get
========================================================================

Usage: openclaw config get [options] <path>

通过点路径获取配置值

Arguments:
  path        配置路径 (点或括号表示法)

Options:
  --json      输出 JSON (默认: false)
  -h, --help  显示命令帮助


========================================================================
openclaw config set
========================================================================

Usage: openclaw config set [options] <path> <value>

通过点路径设置配置值

Arguments:
  path        配置路径 (点或括号表示法)
  value       值 (JSON5 或原始字符串)

Options:
  --json      将值解析为 JSON5 (必需) (默认: false)
  -h, --help  显示命令帮助


========================================================================
openclaw config unset
========================================================================

Usage: openclaw config unset [options] <path>

通过点路径移除配置值

Arguments:
  path        配置路径 (点或括号表示法)

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw doctor
========================================================================

Usage: openclaw doctor [options]

网关和通道的健康检查 + 快速修复

Options:
  --no-workspace-suggestions  禁用工作区内存系统建议
  --yes                       不提示直接接受默认值 (默认: false)
  --repair                    不提示直接应用推荐的修复
                              (默认: false)
  --fix                       应用推荐的修复 (--repair 的别名)
                              (默认: false)
  --force                     应用激进的修复 (覆盖自定义
                              服务配置) (默认: false)
  --non-interactive           无提示运行 (仅限安全的迁移)
                              (默认: false)
  --generate-gateway-token    生成并配置网关令牌 (默认:
                              false)
  --deep                      扫描系统服务以查找多余的网关安装
                              (默认: false)
  -h, --help                  显示命令帮助


========================================================================
openclaw dashboard
========================================================================

Usage: openclaw dashboard [options]

使用当前令牌打开控制 UI

Options:
  --no-open   打印 URL 但不启动浏览器
  -h, --help  显示命令帮助


========================================================================
openclaw reset
========================================================================

Usage: openclaw reset [options]

重置本地配置/状态 (保留 CLI 安装)

Options:
  --scope <scope>    config|config+creds+sessions|full (默认: 交互式
                     提示)
  --yes              跳过确认提示 (默认: false)
  --non-interactive  禁用提示 (需要 --scope + --yes) (默认: false)
  --dry-run          打印操作但不移除文件 (默认: false)
  -h, --help         显示命令帮助


========================================================================
openclaw uninstall
========================================================================

Usage: openclaw uninstall [options]

卸载网关服务 + 本地数据 (保留 CLI)

Options:
  --service          移除网关服务 (默认: false)
  --state            移除状态 + 配置 (默认: false)
  --workspace        移除工作区目录 (默认: false)
  --app              移除 macOS 应用 (默认: false)
  --all              移除 服务 + 状态 + 工作区 + 应用 (默认: false)
  --yes              跳过确认提示 (默认: false)
  --non-interactive  禁用提示 (需要 --yes) (默认: false)
  --dry-run          打印操作但不移除文件 (默认: false)
  -h, --help         显示命令帮助


========================================================================
openclaw message
========================================================================

Usage: openclaw message [options] [command]

发送消息和通道操作

Options:
  -h, --help   显示命令帮助

Commands:
  send         发送消息
  broadcast    向多个目标广播消息
  poll         发送投票
  react        添加或移除反应
  reactions    列出消息上的反应
  read         读取最近的消息
  edit         编辑消息
  delete       删除消息
  pin          置顶消息
  unpin        取消置顶消息
  pins         列出置顶的消息
  permissions  获取通道权限
  search       搜索 Discord 消息
  thread       线程操作
  emoji        表情符号操作
  sticker      贴纸操作
  role         角色操作
  channel      通道操作
  member       成员操作
  voice        语音操作
  event        事件操作
  timeout      将成员超时禁言
  kick         踢出成员
  ban          封禁成员


========================================================================
openclaw message send
========================================================================

Usage: openclaw message send [options]

发送消息

Options:
  -m, --message <text>   消息正文 (除非设置了 --media，否则必填)
  -t, --target <dest>    收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                         聊天 ID/@username，Discord/Slack 通道/用户，或
                         iMessage 句柄/聊天 ID
  --media <path-or-url>  附加媒体 (图像/音频/视频/文档)。接受
                         本地路径或 URL。
  --buttons <json>       格式为 JSON 的 Telegram 内联键盘按钮 (按钮行
                         数组)
  --card <json>          自适应卡片 JSON 对象 (当通道支持时
                         )
  --reply-to <id>        回复的消息 ID
  --thread-id <id>       线程 ID (Telegram 论坛线程)
  --gif-playback         将视频媒体视为 GIF 播放 (仅限 WhatsApp)。
                         (默认: false)
  --silent               静默发送消息且不通知 (仅限 Telegram)
                         (默认: false)
  --channel <channel>    通道:
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         通道账户 ID (accountId)
  --json                 将结果输出为 JSON (默认: false)
  --dry-run              打印负载并跳过发送 (默认: false)
  --verbose              详细日志记录 (默认: false)
  -h, --help             显示命令帮助


========================================================================
openclaw message broadcast
========================================================================

Usage: openclaw message broadcast [options]

向多个目标广播消息

Options:
  --channel <channel>    通道:
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         通道账户 ID (accountId)
  --json                 将结果输出为 JSON (默认: false)
  --dry-run              打印负载并跳过发送 (默认: false)
  --verbose              详细日志记录 (默认: false)
  --targets <target...>  收件人/通道目标 (格式与 --target 相同)；
                         当目录可用时接受 ID 或名称。
  --message <text>       要发送的消息
  --media <url>          媒体 URL
  -h, --help             显示命令帮助


========================================================================
openclaw message poll
========================================================================

Usage: openclaw message poll [options]

发送投票

Options:
  -t, --target <dest>        收件人/通道: WhatsApp/Signal 使用 E.164，
                             Telegram 聊天 ID/@username，Discord/Slack
                             通道/用户，或 iMessage 句柄/聊天 ID
  --channel <channel>        通道:
                             telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>             通道账户 ID (accountId)
  --json                     将结果输出为 JSON (默认: false)
  --dry-run                  打印负载并跳过发送 (默认: false)
  --verbose                  详细日志记录 (默认: false)
  --poll-question <text>     投票问题
  --poll-option <choice>     投票选项 (重复 2-12 次) (默认: [])
  --poll-multi               允许选择多项 (默认: false)
  --poll-duration-hours <n>  投票持续时间 (Discord)
  -m, --message <text>       可选的消息正文
  -h, --help                 显示命令帮助


========================================================================
openclaw message react
========================================================================

Usage: openclaw message react [options]

添加或移除反应

Options:
  -t, --target <dest>          收件人/通道: WhatsApp/Signal 使用 E.164，
                               Telegram 聊天 ID/@username，Discord/Slack
                               通道/用户，或 iMessage 句柄/聊天 ID
  --channel <channel>          通道:
                               telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>               通道账户 ID (accountId)
  --json                       将结果输出为 JSON (默认: false)
  --dry-run                    打印负载并跳过发送 (默认: false)
  --verbose                    详细日志记录 (默认: false)
  --message-id <id>            消息 ID
  --emoji <emoji>              用于反应的表情符号
  --remove                     移除反应 (默认: false)
  --participant <id>           WhatsApp 反应参与者
  --from-me                    WhatsApp 的 fromMe 反应 (默认: false)
  --target-author <id>         Signal 反应目标作者 (UUID 或手机号)
  --target-author-uuid <uuid>  Signal 反应目标作者 UUID
  -h, --help                   显示命令帮助


========================================================================
openclaw message reactions
========================================================================

Usage: openclaw message reactions [options]

列出消息上的反应

Options:
  -t, --target <dest>  收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                       聊天 ID/@username，Discord/Slack 通道/用户，或
                       iMessage 句柄/聊天 ID
  --channel <channel>  通道:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       通道账户 ID (accountId)
  --json               将结果输出为 JSON (默认: false)
  --dry-run            打印负载并跳过发送 (默认: false)
  --verbose            详细日志记录 (默认: false)
  --message-id <id>    消息 ID
  --limit <n>          结果数量限制
  -h, --help           显示命令帮助


========================================================================
openclaw message read
========================================================================

Usage: openclaw message read [options]

读取最近的消息

Options:
  -t, --target <dest>  收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                       聊天 ID/@username，Discord/Slack 通道/用户，或
                       iMessage 句柄/聊天 ID
  --channel <channel>  通道:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       通道账户 ID (accountId)
  --json               将结果输出为 JSON (默认: false)
  --dry-run            打印负载并跳过发送 (默认: false)
  --verbose            详细日志记录 (默认: false)
  --limit <n>          结果数量限制
  --before <id>        读取/搜索指定 ID 之前的消息
  --after <id>         读取/搜索指定 ID 之后的消息
  --around <id>        读取指定 ID 周围的消息
  --include-thread     包含线程回复 (Discord) (默认: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message edit
========================================================================

Usage: openclaw message edit [options]

编辑消息

Options:
  --message-id <id>     消息 ID
  -m, --message <text>  消息正文
  -t, --target <dest>   收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                        聊天 ID/@username，Discord/Slack 通道/用户，或
                        iMessage 句柄/聊天 ID
  --channel <channel>   通道:
                        telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>        通道账户 ID (accountId)
  --json                将结果输出为 JSON (默认: false)
  --dry-run             打印负载并跳过发送 (默认: false)
  --verbose             详细日志记录 (默认: false)
  --thread-id <id>      线程 ID (Telegram 论坛线程)
  -h, --help            显示命令帮助


========================================================================
openclaw message delete
========================================================================

Usage: openclaw message delete [options]

删除消息

Options:
  --message-id <id>    消息 ID
  -t, --target <dest>  收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                       聊天 ID/@username，Discord/Slack 通道/用户，或
                       iMessage 句柄/聊天 ID
  --channel <channel>  通道:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       通道账户 ID (accountId)
  --json               将结果输出为 JSON (默认: false)
  --dry-run            打印负载并跳过发送 (默认: false)
  --verbose            详细日志记录 (默认: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message pin
========================================================================

Usage: openclaw message pin [options]

置顶消息

Options:
  -t, --target <dest>  收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                       聊天 ID/@username，Discord/Slack 通道/用户，或
                       iMessage 句柄/聊天 ID
  --channel <channel>  通道:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       通道账户 ID (accountId)
  --json               将结果输出为 JSON (默认: false)
  --dry-run            打印负载并跳过发送 (默认: false)
  --verbose            详细日志记录 (默认: false)
  --message-id <id>    消息 ID
  -h, --help           显示命令帮助


========================================================================
openclaw message unpin
========================================================================

Usage: openclaw message unpin [options]

取消置顶消息

Options:
  -t, --target <dest>  收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                       聊天 ID/@username，Discord/Slack 通道/用户，或
                       iMessage 句柄/聊天 ID
  --channel <channel>  通道:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       通道账户 ID (accountId)
  --json               将结果输出为 JSON (默认: false)
  --dry-run            打印负载并跳过发送 (默认: false)
  --verbose            详细日志记录 (默认: false)
  --message-id <id>    消息 ID
  -h, --help           显示命令帮助


========================================================================
openclaw message pins
========================================================================

Usage: openclaw message pins [options]

列出置顶的消息

Options:
  -t, --target <dest>  收件人/通道: WhatsApp/Signal 使用 E.164，Telegram
                       聊天 ID/@username，Discord/Slack 通道/用户，或
                       iMessage 句柄/聊天 ID
  --channel <channel>  通道:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       通道账户 ID (accountId)
  --json               将结果输出为 JSON (默认: false)
  --dry-run            打印负载并跳过发送 (默认: false)
  --verbose            详细日志记录 (默认: false)  --limit <n>          结果限制
  -h, --help           显示命令帮助


========================================================================
openclaw message permissions
========================================================================

Usage: openclaw message permissions [options]

获取频道权限

Options:
  -t, --target <dest>  收件人/频道：WhatsApp/Signal 的 E.164，Telegram
                       的 chat id/@username，Discord/Slack 的频道/用户，或
                       iMessage 的 handle/chat_id
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message search
========================================================================

Usage: openclaw message search [options]

搜索 Discord 消息

Options:
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  --guild-id <id>      公会 ID
  --query <text>       搜索查询
  --channel-id <id>    频道 ID
  --channel-ids <id>   频道 ID (可重复) (默认值: [])
  --author-id <id>     作者 ID
  --author-ids <id>    作者 ID (可重复) (默认值: [])
  --limit <n>          结果限制
  -h, --help           显示命令帮助


========================================================================
openclaw message thread
========================================================================

Usage: openclaw message thread [options] [command]

主题操作

Options:
  -h, --help  显示命令帮助

Commands:
  create      创建一个主题
  list        列出主题
  reply       在主题中回复
  help        显示命令帮助


========================================================================
openclaw message thread create
========================================================================

Usage: openclaw message thread create [options]

创建一个主题

Options:
  --thread-name <name>    主题名称
  -t, --target <dest>     收件人/频道：WhatsApp/Signal 的 E.164，Telegram
                          的 chat id/@username，Discord/Slack 的频道/用户，或
                          iMessage 的 handle/chat_id
  --channel <channel>     频道：
                          telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>          频道账户 ID (accountId)
  --json                  将结果输出为 JSON (默认值: false)
  --dry-run               打印有效负载并跳过发送 (默认值: false)
  --verbose               详细日志记录 (默认值: false)
  --message-id <id>       消息 ID (可选)
  --auto-archive-min <n>  主题自动存档时间(分钟)
  -h, --help              显示命令帮助


========================================================================
openclaw message thread list
========================================================================

Usage: openclaw message thread list [options]

列出主题

Options:
  --guild-id <id>      公会 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  --channel-id <id>    频道 ID
  --include-archived   包含已存档的主题 (默认值: false)
  --before <id>        读取/搜索指定 ID 之前的内容
  --limit <n>          结果限制
  -h, --help           显示命令帮助


========================================================================
openclaw message thread reply
========================================================================

Usage: openclaw message thread reply [options]

在主题中回复

Options:
  -m, --message <text>   消息正文
  -t, --target <dest>    收件人/频道：WhatsApp/Signal 的 E.164，Telegram
                         的 chat id/@username，Discord/Slack 的频道/用户，或
                         iMessage 的 handle/chat_id
  --channel <channel>    频道：
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         频道账户 ID (accountId)
  --json                 将结果输出为 JSON (默认值: false)
  --dry-run              打印有效负载并跳过发送 (默认值: false)
  --verbose              详细日志记录 (默认值: false)
  --media <path-or-url>  附加媒体 (图片/音频/视频/文档)。接受
                         本地路径或 URL。
  --reply-to <id>        回复的消息 ID
  -h, --help             显示命令帮助


========================================================================
openclaw message emoji
========================================================================

Usage: openclaw message emoji [options] [command]

表情符号操作

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出表情符号
  upload      上传表情符号
  help        显示命令帮助


========================================================================
openclaw message emoji list
========================================================================

Usage: openclaw message emoji list [options]

列出表情符号

Options:
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  --guild-id <id>      公会 ID (Discord)
  -h, --help           显示命令帮助


========================================================================
openclaw message emoji upload
========================================================================

Usage: openclaw message emoji upload [options]

上传表情符号

Options:
  --guild-id <id>        公会 ID
  --channel <channel>    频道：
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         频道账户 ID (accountId)
  --json                 将结果输出为 JSON (默认值: false)
  --dry-run              打印有效负载并跳过发送 (默认值: false)
  --verbose              详细日志记录 (默认值: false)
  --emoji-name <name>    表情符号名称
  --media <path-or-url>  表情符号媒体 (路径或 URL)
  --role-ids <id>        角色 ID (可重复) (默认值: [])
  -h, --help             显示命令帮助


========================================================================
openclaw message sticker
========================================================================

Usage: openclaw message sticker [options] [command]

贴纸操作

Options:
  -h, --help  显示命令帮助

Commands:
  send        发送贴纸
  upload      上传贴纸
  help        显示命令帮助


========================================================================
openclaw message sticker send
========================================================================

Usage: openclaw message sticker send [options]

发送贴纸

Options:
  -t, --target <dest>   收件人/频道：WhatsApp/Signal 的 E.164，Telegram
                        的 chat id/@username，Discord/Slack 的频道/用户，或
                        iMessage 的 handle/chat_id
  --channel <channel>   频道：
                        telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>        频道账户 ID (accountId)
  --json                将结果输出为 JSON (默认值: false)
  --dry-run             打印有效负载并跳过发送 (默认值: false)
  --verbose             详细日志记录 (默认值: false)
  --sticker-id <id>     贴纸 ID (可重复)
  -m, --message <text>  可选的消息正文
  -h, --help            显示命令帮助


========================================================================
openclaw message sticker upload
========================================================================

Usage: openclaw message sticker upload [options]

上传贴纸

Options:
  --guild-id <id>        公会 ID
  --channel <channel>    频道：
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         频道账户 ID (accountId)
  --json                 将结果输出为 JSON (默认值: false)
  --dry-run              打印有效负载并跳过发送 (默认值: false)
  --verbose              详细日志记录 (默认值: false)
  --sticker-name <name>  贴纸名称
  --sticker-desc <text>  贴纸描述
  --sticker-tags <tags>  贴纸标签
  --media <path-or-url>  贴纸媒体 (路径或 URL)
  -h, --help             显示命令帮助


========================================================================
openclaw message role
========================================================================

Usage: openclaw message role [options] [command]

角色操作

Options:
  -h, --help  显示命令帮助

Commands:
  info        列出角色
  add         为成员添加角色
  remove      从成员移除角色
  help        显示命令帮助


========================================================================
openclaw message role info
========================================================================

Usage: openclaw message role info [options]

列出角色

Options:
  --guild-id <id>      公会 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message role add
========================================================================

Usage: openclaw message role add [options]

为成员添加角色

Options:
  --guild-id <id>      公会 ID
  --user-id <id>       用户 ID
  --role-id <id>       角色 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message role remove
========================================================================

Usage: openclaw message role remove [options]

从成员移除角色

Options:
  --guild-id <id>      公会 ID
  --user-id <id>       用户 ID
  --role-id <id>       角色 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message channel
========================================================================

Usage: openclaw message channel [options] [command]

频道操作

Options:
  -h, --help  显示命令帮助

Commands:
  info        获取频道信息
  list        列出频道
  help        显示命令帮助


========================================================================
openclaw message channel info
========================================================================

Usage: openclaw message channel info [options]

获取频道信息

Options:
  -t, --target <dest>  收件人/频道：WhatsApp/Signal 的 E.164，Telegram
                       的 chat id/@username，Discord/Slack 的频道/用户，或
                       iMessage 的 handle/chat_id
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message channel list
========================================================================

Usage: openclaw message channel list [options]

列出频道

Options:
  --guild-id <id>      公会 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message member
========================================================================

Usage: openclaw message member [options] [command]

成员操作

Options:
  -h, --help  显示命令帮助

Commands:
  info        获取成员信息
  help        显示命令帮助


========================================================================
openclaw message member info
========================================================================

Usage: openclaw message member info [options]

获取成员信息

Options:
  --user-id <id>       用户 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  --guild-id <id>      公会 ID (Discord)
  -h, --help           显示命令帮助


========================================================================
openclaw message voice
========================================================================

Usage: openclaw message voice [options] [command]

语音操作

Options:
  -h, --help  显示命令帮助

Commands:
  status      获取语音状态
  help        显示命令帮助


========================================================================
openclaw message voice status
========================================================================

Usage: openclaw message voice status [options]

获取语音状态

Options:
  --guild-id <id>      公会 ID
  --user-id <id>       用户 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message event
========================================================================

Usage: openclaw message event [options] [command]

事件操作

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出已安排的事件
  create      创建已安排的事件
  help        显示命令帮助


========================================================================
openclaw message event list
========================================================================

Usage: openclaw message event list [options]

列出已安排的事件

Options:
  --guild-id <id>      公会 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  -h, --help           显示命令帮助


========================================================================
openclaw message event create
========================================================================

Usage: openclaw message event create [options]

创建已安排的事件

Options:
  --guild-id <id>                      公会 ID
  --event-name <name>                  事件名称
  --start-time <iso>                   事件开始时间
  --channel <channel>                  频道：
                                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>                       频道账户 ID (accountId)
  --json                               将结果输出为 JSON (默认值: false)
  --dry-run                            打印有效负载并跳过发送 (默认值:
                                       false)
  --verbose                            详细日志记录 (默认值: false)
  --end-time <iso>                     事件结束时间
  --desc <text>                        事件描述
  --channel-id <id>                    频道 ID
  --location <text>                    事件地点
  --event-type <stage|external|voice>  事件类型
  -h, --help                           显示命令帮助


========================================================================
openclaw message timeout
========================================================================

Usage: openclaw message timeout [options]

使成员禁言超时

Options:
  --guild-id <id>      公会 ID
  --user-id <id>       用户 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  --duration-min <n>   超时持续时间(分钟)
  --until <iso>        超时直到
  --reason <text>      审核原因
  -h, --help           显示命令帮助


========================================================================
openclaw message kick
========================================================================

Usage: openclaw message kick [options]

踢出成员

Options:
  --guild-id <id>      公会 ID
  --user-id <id>       用户 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  --reason <text>      审核原因
  -h, --help           显示命令帮助


========================================================================
openclaw message ban
========================================================================

Usage: openclaw message ban [options]

封禁成员

Options:
  --guild-id <id>      公会 ID
  --user-id <id>       用户 ID
  --channel <channel>  频道：
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       频道账户 ID (accountId)
  --json               将结果输出为 JSON (默认值: false)
  --dry-run            打印有效负载并跳过发送 (默认值: false)
  --verbose            详细日志记录 (默认值: false)
  --reason <text>      审核原因
  --delete-days <n>    封禁时删除消息的天数
  -h, --help           显示命令帮助


========================================================================
openclaw memory
========================================================================

Usage: openclaw memory [options] [command]

记忆搜索工具

Options:
  -h, --help  显示命令帮助

Commands:
  status      显示记忆搜索索引状态
  index       重新索引记忆文件
  search      搜索记忆文件
  help        显示命令帮助


========================================================================
openclaw memory status
========================================================================

Usage: openclaw memory status [options]

显示记忆搜索索引状态

Options:
  --agent <id>  代理 ID (默认值: 默认代理)
  --json        打印 JSON
  --deep        探查嵌入提供商的可用性
  --index       如果脏则重新索引 (隐含 --deep)
  --verbose     详细日志记录 (默认值: false)
  -h, --help    显示命令帮助


========================================================================
openclaw memory index
========================================================================

Usage: openclaw memory index [options]

重新索引记忆文件

Options:
  --agent <id>  代理 ID (默认值: 默认代理)
  --force       强制完整重新索引 (默认值: false)
  --verbose     详细日志记录 (默认值: false)
  -h, --help    显示命令帮助


========================================================================
openclaw memory search
========================================================================

Usage: openclaw memory search [options] <query>

搜索记忆文件

Arguments:
  query              搜索查询

Options:
  --agent <id>       代理 ID (默认值: 默认代理)
  --max-results <n>  最大结果数
  --min-score <n>    最低分数
  --json             打印 JSON
  -h, --help         显示命令帮助


========================================================================
openclaw agent
========================================================================

Usage: openclaw agent [options]

通过网关运行代理轮次 (使用 --local 用于嵌入式)

Options:
  -m, --message <text>       代理的消息正文
  -t, --to <number>          E.164 格式的收件人号码，用于派生会话密钥
  --session-id <id>          使用显式会话 ID
  --agent <id>               代理 ID (覆盖路由绑定)
  --thinking <level>         思考级别：off | minimal | low | medium | high
  --verbose <on|off>         为会话持久化代理详细日志级别
  --channel <channel>        投递频道：
                             last|telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
                             (默认值: whatsapp)
  --reply-to <target>        覆盖投递目标 (独立于会话路由)
  --reply-channel <channel>  覆盖投递频道 (独立于路由)
  --reply-account <id>       覆盖投递账户 ID
  --local                    在本地运行嵌入式代理 (需要在您的 shell 中提供模型
                             提供商的 API 密钥) (默认值: false)
  --deliver                  将代理的回复发送回选定的频道
                             (默认值: false)
  --json                     将结果输出为 JSON (默认值: false)
  --timeout <seconds>        覆盖代理命令超时时间 (秒，默认值
                             600 或配置值)
  -h, --help                 显示命令帮助
========================================================================
openclaw agents
========================================================================

Usage: openclaw agents [options] [command]

管理独立代理（工作区 + 认证 + 路由）

Options:
  -h, --help    显示命令帮助

Commands:
  list          列出已配置的代理
  add           添加一个新的独立代理
  set-identity  更新代理身份（名称/主题/表情符号/头像）
  delete        删除代理并清理工作区/状态


========================================================================
openclaw agents list
========================================================================

Usage: openclaw agents list [options]

列出已配置的代理

Options:
  --json      输出 JSON 而不是文本 (default: false)
  --bindings  包含路由绑定 (default: false)
  -h, --help  显示命令帮助


========================================================================
openclaw agents add
========================================================================

Usage: openclaw agents add [options] [name]

添加一个新的独立代理

Options:
  --workspace <dir>             新代理的工作区目录
  --model <id>                  该代理的模型 ID
  --agent-dir <dir>             该代理的代理状态目录
  --bind <channel[:accountId]>  路由频道绑定（可重复） (default: [])
  --non-interactive             禁用提示；需要 --workspace (default:
                                false)
  --json                        输出 JSON 摘要 (default: false)
  -h, --help                    显示命令帮助


========================================================================
openclaw agents set-identity
========================================================================

Usage: openclaw agents set-identity [options]

更新代理身份（名称/主题/表情符号/头像）

Options:
  --agent <id>            要更新的代理 ID
  --workspace <dir>       用于定位代理及 IDENTITY.md 的工作区目录
  --identity-file <path>  要读取的显式 IDENTITY.md 路径
  --from-identity         从 IDENTITY.md 读取值 (default: false)
  --name <name>           身份名称
  --theme <theme>         身份主题
  --emoji <emoji>         身份表情符号
  --avatar <value>        身份头像（工作区路径、http(s) URL 或 data
                          URI）
  --json                  输出 JSON 摘要 (default: false)
  -h, --help              显示命令帮助


========================================================================
openclaw agents delete
========================================================================

Usage: openclaw agents delete [options] <id>

删除代理并清理工作区/状态

Options:
  --force     跳过确认 (default: false)
  --json      输出 JSON 摘要 (default: false)
  -h, --help  显示命令帮助


========================================================================
openclaw status
========================================================================

Usage: openclaw status [options]

显示频道健康状况和最近的会话接收者

Options:
  --json          输出 JSON 而不是文本 (default: false)
  --all           完整诊断（只读，可粘贴） (default: false)
  --usage         显示模型提供商使用情况/配额快照 (default: false)
  --deep          探测频道（WhatsApp Web + Telegram + Discord + Slack +
                  Signal） (default: false)
  --timeout <ms>  探测超时时间，以毫秒为单位 (default: "10000")
  --verbose       详细日志 (default: false)
  --debug         --verbose 的别名 (default: false)
  -h, --help      显示命令帮助


========================================================================
openclaw health
========================================================================

Usage: openclaw health [options]

从运行中的网关获取健康状态

Options:
  --json          输出 JSON 而不是文本 (default: false)
  --timeout <ms>  连接超时时间，以毫秒为单位 (default: "10000")
  --verbose       详细日志 (default: false)
  --debug         --verbose 的别名 (default: false)
  -h, --help      显示命令帮助


========================================================================
openclaw sessions
========================================================================

Usage: openclaw sessions [options]

列出已存储的对话会话

Options:
  --json              输出为 JSON (default: false)
  --verbose           详细日志 (default: false)
  --store <path>      会话存储路径 (default: 从配置解析)
  --active <minutes>  仅显示过去 N 分钟内更新的会话
  -h, --help          显示命令帮助


========================================================================
openclaw browser
========================================================================

Usage: openclaw browser [options] [command]

管理 OpenClaw 的专用浏览器（Chrome/Chromium）

Options:
  --browser-profile <name>  浏览器配置文件名称（默认为配置值）
  --json                    输出机器可读的 JSON (default: false)
  --url <url>               网关 WebSocket URL（如果已配置，默认为
                            gateway.remote.url）
  --token <token>           网关令牌（如果需要）
  --timeout <ms>            超时时间，以毫秒为单位 (default: "10000")
  --expect-final            等待最终响应（代理） (default: false)
  -h, --help                显示命令帮助

Commands:
  status                    显示浏览器状态
  start                     启动浏览器（如果已运行则无操作）
  stop                      停止浏览器（尽力而为）
  reset-profile             重置浏览器配置文件（将其移至垃圾桶）
  tabs                      列出打开的标签页
  tab                       标签页快捷方式（基于索引）
  open                      在新标签页中打开 URL
  focus                     通过目标 ID（或唯一前缀）聚焦标签页
  close                     关闭标签页（目标 ID 可选）
  profiles                  列出所有浏览器配置文件
  create-profile            创建新的浏览器配置文件
  delete-profile            删除浏览器配置文件
  extension                 Chrome 扩展助手
  screenshot                捕获屏幕截图 (MEDIA:<path>)
  snapshot                  捕获快照（默认：ai；aria 为无障碍树）
  navigate                  将当前标签页导航到 URL
  resize                    调整视口大小
  click                     通过快照中的 ref 点击元素
  type                      通过快照中的 ref 在元素中输入
  press                     按键
  hover                     通过 ai ref 悬停元素
  scrollintoview            通过快照中的 ref 将元素滚动到视图中
  drag                      从一个 ref 拖动到另一个 ref
  select                    在 select 元素中选择选项
  upload                    为下一个文件选择器准备文件上传
  waitfordownload           等待下一个下载（并保存它）
  download                  点击 ref 并保存生成的下载
  dialog                    准备处理下一个模态对话框（alert/confirm/prompt）
  fill                      使用 JSON 字段描述符填写表单
  wait                      等待时间、选择器、URL、加载状态或 JS
                            条件
  evaluate                  针对页面或 ref 评估函数
  console                   获取最近的控制台消息
  pdf                       将页面保存为 PDF
  responsebody              等待网络响应并返回其正文
  highlight                 通过 ref 高亮显示元素
  errors                    获取最近的页面错误
  requests                  获取最近的网络请求（尽力而为）
  trace                     记录 Playwright 跟踪
  cookies                   读取/写入 cookies
  storage                   读取/写入 localStorage/sessionStorage
  set                       浏览器环境设置


========================================================================
openclaw browser status
========================================================================

Usage: openclaw browser status [options]

显示浏览器状态

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser start
========================================================================

Usage: openclaw browser start [options]

启动浏览器（如果已运行则无操作）

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser stop
========================================================================

Usage: openclaw browser stop [options]

停止浏览器（尽力而为）

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser reset-profile
========================================================================

Usage: openclaw browser reset-profile [options]

重置浏览器配置文件（将其移至垃圾桶）

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser tabs
========================================================================

Usage: openclaw browser tabs [options]

列出打开的标签页

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser tab
========================================================================

Usage: openclaw browser tab [options] [command]

标签页快捷方式（基于索引）

Options:
  -h, --help  显示命令帮助

Commands:
  new         打开新标签页 (about:blank)
  select      通过索引聚焦标签页（从 1 开始）
  close       通过索引关闭标签页（从 1 开始）；默认：第一个标签页


========================================================================
openclaw browser tab new
========================================================================

Usage: openclaw browser tab new [options]

打开新标签页 (about:blank)

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser tab select
========================================================================

Usage: openclaw browser tab select [options] <index>

通过索引聚焦标签页（从 1 开始）

Arguments:
  index       标签页索引（从 1 开始）

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser tab close
========================================================================

Usage: openclaw browser tab close [options] [index]

通过索引关闭标签页（从 1 开始）；默认：第一个标签页

Arguments:
  index       标签页索引（从 1 开始）

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser open
========================================================================

Usage: openclaw browser open [options] <url>

在新标签页中打开 URL

Arguments:
  url         要打开的 URL

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser focus
========================================================================

Usage: openclaw browser focus [options] <targetId>

通过目标 ID（或唯一前缀）聚焦标签页

Arguments:
  targetId    目标 ID 或唯一前缀

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser close
========================================================================

Usage: openclaw browser close [options] [targetId]

关闭标签页（目标 ID 可选）

Arguments:
  targetId    目标 ID 或唯一前缀（可选）

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser profiles
========================================================================

Usage: openclaw browser profiles [options]

列出所有浏览器配置文件

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser create-profile
========================================================================

Usage: openclaw browser create-profile [options]

创建新的浏览器配置文件

Options:
  --name <name>      配置文件名称（小写、数字、连字符）
  --color <hex>      配置文件颜色（十六进制格式，例如 #0066CC）
  --cdp-url <url>    用于远程 Chrome 的 CDP URL (http/https)
  --driver <driver>  配置文件驱动程序 (openclaw|extension)。默认：openclaw
  -h, --help         显示命令帮助


========================================================================
openclaw browser delete-profile
========================================================================

Usage: openclaw browser delete-profile [options]

删除浏览器配置文件

Options:
  --name <name>  要删除的配置文件名称
  -h, --help     显示命令帮助


========================================================================
openclaw browser extension
========================================================================

Usage: openclaw browser extension [options] [command]

Chrome 扩展助手

Options:
  -h, --help  显示命令帮助

Commands:
  install     将 Chrome 扩展安装到稳定的本地路径
  path        打印已安装 Chrome 扩展的路径（加载解压的扩展）
  help        显示命令帮助


========================================================================
openclaw browser extension install
========================================================================

Usage: openclaw browser extension install [options]

将 Chrome 扩展安装到稳定的本地路径

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser extension path
========================================================================

Usage: openclaw browser extension path [options]

打印已安装 Chrome 扩展的路径（加载解压的扩展）

Options:
  -h, --help  显示命令帮助


========================================================================
openclaw browser screenshot
========================================================================

Usage: openclaw browser screenshot [options] [targetId]

捕获屏幕截图 (MEDIA:<path>)

Arguments:
  targetId              CDP 目标 ID（或唯一前缀）

Options:
  --full-page           捕获完整的可滚动页面 (default: false)
  --ref <ref>           来自 ai 快照的 ARIA ref
  --element <selector>  元素屏幕截图的 CSS 选择器
  --type <png|jpeg>     输出类型 (默认：png) (default: "png")
  -h, --help            显示命令帮助


========================================================================
openclaw browser snapshot
========================================================================

Usage: openclaw browser snapshot [options]

捕获快照（默认：ai；aria 为无障碍树）

Options:
  --format <aria|ai>  快照格式 (默认：ai) (default: "ai")
  --target-id <id>    CDP 目标 ID（或唯一前缀）
  --limit <n>         最大节点数 (默认：500/800)
  --mode <efficient>  快照预设 (efficient)
  --efficient         使用 efficient 快照预设 (default: false)
  --interactive       角色快照：仅交互式元素 (default: false)
  --compact           角色快照：紧凑输出 (default: false)
  --depth <n>         角色快照：最大深度
  --selector <sel>    角色快照：限定到 CSS 选择器范围
  --frame <sel>       角色快照：限定到 iframe 选择器范围
  --labels            包含视口标签叠加屏幕截图 (default: false)
  --out <path>        将快照写入文件
  -h, --help          显示命令帮助


========================================================================
openclaw browser navigate
========================================================================

Usage: openclaw browser navigate [options] <url>

将当前标签页导航到 URL

Arguments:
  url               要导航到的 URL

Options:
  --target-id <id>  CDP 目标 ID（或唯一前缀）
  -h, --help        显示命令帮助


========================================================================
openclaw browser resize
========================================================================

Usage: openclaw browser resize [options] <width> <height>

调整视口大小

Arguments:
  width             视口宽度
  height            视口高度

Options:
  --target-id <id>  CDP 目标 ID（或唯一前缀）
  -h, --help        显示命令帮助


========================================================================
openclaw browser click
========================================================================

Usage: openclaw browser click [options] <ref>

通过快照中的 ref 点击元素

Arguments:
  ref                           来自快照的 ref id

Options:
  --target-id <id>              CDP 目标 ID（或唯一前缀）
  --double                      双击 (default: false)
  --button <left|right|middle>  要使用的鼠标按钮
  --modifiers <list>            逗号分隔的修饰键 (Shift,Alt,Meta)
  -h, --help                    显示命令帮助


========================================================================
openclaw browser type
========================================================================

Usage: openclaw browser type [options] <ref> <text>

通过快照中的 ref 在元素中输入

Arguments:
  ref               来自快照的 ref id
  text              要输入的文本

Options:
  --submit          输入后按 Enter 键 (default: false)
  --slowly          缓慢输入（像人一样） (default: false)
  --target-id <id>  CDP 目标 ID（或唯一前缀）
  -h, --help        显示命令帮助


========================================================================
openclaw browser press
========================================================================

Usage: openclaw browser press [options] <key>

按键

Arguments:
  key               要按下的键 (例如 Enter)

Options:
  --target-id <id>  CDP 目标 ID（或唯一前缀）
  -h, --help        显示命令帮助


========================================================================
openclaw browser hover
========================================================================

Usage: openclaw browser hover [options] <ref>

通过 ai ref 悬停元素

Arguments:
  ref               来自快照的 ref id

Options:
  --target-id <id>  CDP 目标 ID（或唯一前缀）
  -h, --help        显示命令帮助


========================================================================
openclaw browser scrollintoview
========================================================================

Usage: openclaw browser scrollintoview [options] <ref>

通过快照中的 ref 将元素滚动到视图中

Arguments:
  ref                来自快照的 ref id

Options:
  --target-id <id>   CDP 目标 ID（或唯一前缀）
  --timeout-ms <ms>  等待滚动的时长 (default: 20000)
  -h, --help         显示命令帮助


========================================================================
openclaw browser drag
========================================================================

Usage: openclaw browser drag [options] <startRef> <endRef>

从一个 ref 拖动到另一个 ref

Arguments:
  startRef          起始 ref id
  endRef            结束 ref id

Options:
  --target-id <id>  CDP 目标 ID（或唯一前缀）
  -h, --help        显示命令帮助


========================================================================
openclaw browser select
========================================================================

Usage: openclaw browser select [options] <ref> <values...>

在 select 元素中选择选项

Arguments:
  ref               来自快照的 ref id
  values            要选择的选项值

Options:
  --target-id <id>  CDP 目标 ID（或唯一前缀）
  -h, --help        显示命令帮助


========================================================================
openclaw browser upload
========================================================================

Usage: openclaw browser upload [options] <paths...>

为下一个文件选择器准备文件上传

Arguments:
  paths                 要上传的文件路径

Options:
  --ref <ref>           装备后要点击的快照 ref id
  --input-ref <ref>     直接设置的 <input type=file> ref id
  --element <selector>  <input type=file> 的 CSS 选择器
  --target-id <id>      CDP 目标 ID（或唯一前缀）
  --timeout-ms <ms>     等待下一个文件选择器的时长 (default:
                        120000)
  -h, --help            显示命令帮助


========================================================================
openclaw browser waitfordownload
========================================================================

Usage: openclaw browser waitfordownload [options] [path]

等待下一个下载（并保存它）

Arguments:
  path               保存路径 (默认：/tmp/openclaw/downloads/...)

Options:
  --target-id <id>   CDP 目标 ID（或唯一前缀）
  --timeout-ms <ms>  等待下一个下载的时长 (default: 120000)
  -h, --help         显示命令帮助


========================================================================
openclaw browser download
========================================================================

Usage: openclaw browser download [options] <ref> <path>

点击 ref 并保存生成的下载

Arguments:
  ref                要点击的快照 ref id
  path               保存路径

Options:
  --target-id <id>   CDP 目标 ID（或唯一前缀）
  --timeout-ms <ms>  等待下载开始的时长 (default:                     120000)
  -h, --help         显示命令的帮助信息


========================================================================
openclaw browser dialog
========================================================================

Usage: openclaw browser dialog [options]

捕获下一个模态对话框（alert/confirm/prompt）

Options:
  --accept           接受对话框 (默认值: false)
  --dismiss          关闭对话框 (默认值: false)
  --prompt <text>    提示响应文本
  --target-id <id>   CDP target id (或唯一前缀)
  --timeout-ms <ms>  等待下一个对话框的时长 (默认值: 120000)
  -h, --help         显示命令的帮助信息


========================================================================
openclaw browser fill
========================================================================

Usage: openclaw browser fill [options]

使用 JSON 字段描述符填写表单

Options:
  --fields <json>       字段对象的 JSON 数组
  --fields-file <path>  从文件读取 JSON 数组
  --target-id <id>      CDP target id (或唯一前缀)
  -h, --help            显示命令的帮助信息


========================================================================
openclaw browser wait
========================================================================

Usage: openclaw browser wait [options] [selector]

等待时间、选择器、URL、加载状态或 JS 条件

Arguments:
  selector                                    要等待的 CSS 选择器 (可见的)

Options:
  --time <ms>                                 等待 N 毫秒
  --text <value>                              等待文本出现
  --text-gone <value>                         等待文本消失
  --url <pattern>                             等待 URL (支持 glob 模式，如 **/dash)
  --load <load|domcontentloaded|networkidle>  等待加载状态
  --fn <js>                                   等待 JS 条件 (传递给 waitForFunction)
  --timeout-ms <ms>                           等待每个条件的时长 (默认值: 20000)
  --target-id <id>                            CDP target id (或唯一前缀)
  -h, --help                                  显示命令的帮助信息


========================================================================
openclaw browser evaluate
========================================================================

Usage: openclaw browser evaluate [options]

针对页面或引用执行函数

Options:
  --fn <code>       函数源码, 例如 (el) => el.textContent
  --ref <id>        来自快照的引用
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser console
========================================================================

Usage: openclaw browser console [options]

获取最近的控制台消息

Options:
  --level <level>   按级别过滤 (error, warn, info)
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser pdf
========================================================================

Usage: openclaw browser pdf [options]

将页面保存为 PDF

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser responsebody
========================================================================

Usage: openclaw browser responsebody [options] <url>

等待网络响应并返回其主体内容

Arguments:
  url                URL (精确匹配、子字符串或 glob 模式如 **/api)

Options:
  --target-id <id>   CDP target id (或唯一前缀)
  --timeout-ms <ms>  等待响应的时长 (默认值: 20000)
  --max-chars <n>    返回主体的最大字符数 (默认值: 200000)
  -h, --help         显示命令的帮助信息


========================================================================
openclaw browser highlight
========================================================================

Usage: openclaw browser highlight [options] <ref>

通过引用高亮显示元素

Arguments:
  ref               来自快照的引用 ID

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser errors
========================================================================

Usage: openclaw browser errors [options]

获取最近的页面错误

Options:
  --clear           读取后清除存储的错误 (默认值: false)
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser requests
========================================================================

Usage: openclaw browser requests [options]

获取最近的网络请求 (尽力而为)

Options:
  --filter <text>   仅显示包含此子字符串的 URL
  --clear           读取后清除存储的请求 (默认值: false)
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser trace
========================================================================

Usage: openclaw browser trace [options] [command]

录制 Playwright 追踪(trace)

Options:
  -h, --help  显示命令的帮助信息

Commands:
  start       开始录制追踪
  stop        停止录制追踪并写入 .zip 文件
  help        显示命令的帮助信息


========================================================================
openclaw browser trace start
========================================================================

Usage: openclaw browser trace start [options]

开始录制追踪

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  --no-screenshots  禁用屏幕截图
  --no-snapshots    禁用快照
  --sources         包含源码 (生成的追踪文件更大) (默认值: false)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser trace stop
========================================================================

Usage: openclaw browser trace stop [options]

停止录制追踪并写入 .zip 文件

Options:
  --out <path>      追踪 zip 文件的输出路径
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser cookies
========================================================================

Usage: openclaw browser cookies [options] [command]

读/写 cookies

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息

Commands:
  set               设置 cookie (需要 --url 或 domain+path)
  clear             清除所有 cookies


========================================================================
openclaw browser cookies set
========================================================================

Usage: openclaw browser cookies set [options] <name> <value>

设置 cookie (需要 --url 或 domain+path)

Arguments:
  name              Cookie 名称
  value             Cookie 值

Options:
  --url <url>       Cookie 的 URL 范围 (推荐)
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser cookies clear
========================================================================

Usage: openclaw browser cookies clear [options]

清除所有 cookies

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser storage
========================================================================

Usage: openclaw browser storage [options] [command]

读/写 localStorage/sessionStorage

Options:
  -h, --help  显示命令的帮助信息

Commands:
  local       localStorage 命令
  session     sessionStorage 命令
  help        显示命令的帮助信息


========================================================================
openclaw browser storage local
========================================================================

Usage: openclaw browser storage local [options] [command]

localStorage 命令

Options:
  -h, --help  显示命令的帮助信息

Commands:
  get         获取 localStorage (所有键或单个键)
  set         设置 localStorage 键
  clear       清除所有 localStorage 键
  help        显示命令的帮助信息


========================================================================
openclaw browser storage local get
========================================================================

Usage: openclaw browser storage local get [options] [key]

获取 localStorage (所有键或单个键)

Arguments:
  key               键名 (可选)

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser storage local set
========================================================================

Usage: openclaw browser storage local set [options] <key> <value>

设置 localStorage 键

Arguments:
  key               键名
  value             键值

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser storage local clear
========================================================================

Usage: openclaw browser storage local clear [options]

清除所有 localStorage 键

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser storage session
========================================================================

Usage: openclaw browser storage session [options] [command]

sessionStorage 命令

Options:
  -h, --help  显示命令的帮助信息

Commands:
  get         获取 sessionStorage (所有键或单个键)
  set         设置 sessionStorage 键
  clear       清除所有 sessionStorage 键
  help        显示命令的帮助信息


========================================================================
openclaw browser storage session get
========================================================================

Usage: openclaw browser storage session get [options] [key]

获取 sessionStorage (所有键或单个键)

Arguments:
  key               键名 (可选)

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser storage session set
========================================================================

Usage: openclaw browser storage session set [options] <key> <value>

设置 sessionStorage 键

Arguments:
  key               键名
  value             键值

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser storage session clear
========================================================================

Usage: openclaw browser storage session clear [options]

清除所有 sessionStorage 键

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser set
========================================================================

Usage: openclaw browser set [options] [command]

浏览器环境设置

Options:
  -h, --help   显示命令的帮助信息

Commands:
  viewport     设置视口大小 (resize 的别名)
  offline      切换离线模式
  headers      设置额外的 HTTP 头部 (JSON 对象)
  credentials  设置 HTTP 基础认证凭据
  geo          设置地理位置 (并授予权限)
  media        模拟 prefers-color-scheme (首选配色方案)
  timezone     覆盖时区 (CDP)
  locale       覆盖区域设置 (CDP)
  device       应用 Playwright 设备描述符 (例如 "iPhone 14")
  help         显示命令的帮助信息


========================================================================
openclaw browser set viewport
========================================================================

Usage: openclaw browser set viewport [options] <width> <height>

设置视口大小 (resize 的别名)

Arguments:
  width             视口宽度
  height            视口高度

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser set offline
========================================================================

Usage: openclaw browser set offline [options] <on|off>

切换离线模式

Arguments:
  on|off            on/off (开/关)

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser set headers
========================================================================

Usage: openclaw browser set headers [options]

设置额外的 HTTP 头部 (JSON 对象)

Options:
  --json <json>     头部的 JSON 对象
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser set credentials
========================================================================

Usage: openclaw browser set credentials [options] [username] [password]

设置 HTTP 基础认证凭据

Arguments:
  username          用户名
  password          密码

Options:
  --clear           清除凭据 (默认值: false)
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser set geo
========================================================================

Usage: openclaw browser set geo [options] [latitude] [longitude]

设置地理位置 (并授予权限)

Arguments:
  latitude           纬度
  longitude          经度

Options:
  --clear            清除地理位置及权限 (默认值: false)
  --accuracy <m>     精确度 (单位: 米)
  --origin <origin>  要授予权限的来源(Origin)
  --target-id <id>   CDP target id (或唯一前缀)
  -h, --help         显示命令的帮助信息


========================================================================
openclaw browser set media
========================================================================

Usage: openclaw browser set media [options] <dark|light|none>

模拟 prefers-color-scheme (首选配色方案)

Arguments:
  dark|light|none   dark/light/none (暗/亮/无)

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser set timezone
========================================================================

Usage: openclaw browser set timezone [options] <timezoneId>

覆盖时区 (CDP)

Arguments:
  timezoneId        时区 ID (例如 America/New_York)

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息


========================================================================
openclaw browser set locale
========================================================================

Usage: openclaw browser set locale [options] <locale>

覆盖区域设置 (CDP)

Arguments:
  locale            区域设置 (例如 en-US)

Options:
  --target-id <id>  CDP target id (或唯一前缀)
  -h, --help        显示命令的帮助信息
```

---

## 附录 C：懒加载顶层子命令（`openclaw <cmd> -h`）

包含 `acp`、`gateway`、`daemon`、`plugins`、`channels` 等。

```text
========================================================================
openclaw acp
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — It's not "failing," it's "discovering new ways to configure the same thing wrong."

Usage: openclaw acp [options] [command]

运行一个由网关支持的 ACP 桥接器

Options:
  --url <url>              网关 WebSocket URL (如果已配置，则默认为
                           gateway.remote.url)
  --token <token>          网关令牌 (如果需要)
  --password <password>    网关密码 (如果需要)
  --session <key>          默认会话键 (例如 agent:main:main)
  --session-label <label>  要解析的默认会话标签
  --require-existing       如果会话键/标签不存在则失败
                           (默认值: false)
  --reset-session          在首次使用前重置会话键 (默认值:
                           false)
  --no-prefix-cwd          不要在提示前加上工作目录
  --verbose, -v            输出详细日志到 stderr (默认值: false)
  -h, --help               显示命令的帮助信息

Commands:
  client                   针对本地 ACP 桥接器运行交互式 ACP 客户端

Docs: https://docs.openclaw.ai/cli/acp

Invalid config at C:\Users\18332\.openclaw\openclaw.json:\n- plugins.enabled: Invalid input: expected boolean, received array

========================================================================
openclaw gateway
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Your .env is showing; don't worry, I'll pretend I didn't see it.

Usage: openclaw gateway [options] [command]

运行 WebSocket 网关

Options:
  --port <port>              网关 WebSocket 的端口
  --bind <mode>              绑定模式
                             ("loopback"|"lan"|"tailnet"|"auto"|"custom").
                             默认为配置中的 gateway.bind (或 loopback).
  --token <token>            在 connect.params.auth.token 中所需的共享令牌
                             (默认值: 如果设置了 OPENCLAW_GATEWAY_TOKEN 环境变量)
  --auth <mode>              网关认证模式 ("token"|"password")
  --password <password>      认证模式为 password 时的密码
  --tailscale <mode>         Tailscale 暴露模式 ("off"|"serve"|"funnel")
  --tailscale-reset-on-exit  关闭时重置 Tailscale serve/funnel 配置
                             (默认值: false)
  --allow-unconfigured       允许在配置中没有 gateway.mode=local 的情况下启动网关
                             (默认值: false)
  --dev                      如果缺失则创建一个开发配置 + 工作区 (无
                             BOOTSTRAP.md) (默认值: false)
  --reset                    重置开发配置 + 凭据 + 会话 +
                             工作区 (需要 --dev) (默认值: false)
  --force                    在启动前强行终止目标端口上的任何现有监听器
                             (默认值: false)
  --verbose                  输出详细日志到 stdout/stderr (默认值: false)
  --claude-cli-logs          仅在控制台中显示 claude-cli 日志 (包括
                             stdout/stderr) (默认值: false)
  --ws-log <style>           WebSocket 日志样式 ("auto"|"full"|"compact")
                             (默认值: "auto")
  --compact                  "--ws-log compact" 的别名 (默认值: false)
  --raw-stream               将原始模型流事件记录到 jsonl (默认值:
                             false)
  --raw-stream-path <path>   原始流 jsonl 路径
  -h, --help                 显示命令的帮助信息

Commands:
  run                        运行 WebSocket 网关 (前台)
  status                     显示网关服务状态 + 探测网关
  install                    安装网关服务
                             (launchd/systemd/schtasks)
  uninstall                  卸载网关服务
                             (launchd/systemd/schtasks)
  start                      启动网关服务
                             (launchd/systemd/schtasks)
  stop                       停止网关服务 (launchd/systemd/schtasks)
  restart                    重启网关服务
                             (launchd/systemd/schtasks)
  call                       调用网关方法
  usage-cost                 从会话日志获取使用成本汇总
  health                     获取网关健康状况
  probe                      显示网关连通性 + 发现 + 健康状况 +
                             状态汇总 (本地 + 远程)
  discover                   通过 Bonjour 发现网关 (本地 + 广域如果已配置)

Docs: https://docs.openclaw.ai/cli/gateway

Invalid config at C:\Users\18332\.openclaw\openclaw.json:\n- plugins.enabled: Invalid input: expected boolean, received array

========================================================================
openclaw daemon
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I'm the assistant your terminal demanded, not the one your sleep schedule requested.

Usage: openclaw daemon [options] [command]

管理网关服务 (launchd/systemd/schtasks)

Options:
  -h, --help  显示命令的帮助信息

Commands:
  status      显示服务安装状态 + 探测网关  install     安装 Gateway 服务 (launchd/systemd/schtasks)
  uninstall   卸载 Gateway 服务 (launchd/systemd/schtasks)
  start       启动 Gateway 服务 (launchd/systemd/schtasks)
  stop        停止 Gateway 服务 (launchd/systemd/schtasks)
  restart     重启 Gateway 服务 (launchd/systemd/schtasks)
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/gateway


========================================================================
openclaw logs
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — UNIX 哲学与你的私信相遇。

Usage: openclaw logs [options]

通过 RPC 追踪 Gateway 文件日志

Options:
  --limit <n>      返回的最大行数 (默认值: "200")
  --max-bytes <n>  读取的最大字节数 (默认值: "250000")
  --follow         跟踪日志输出 (默认值: false)
  --interval <ms>  轮询间隔（毫秒） (默认值: "1000")
  --json           输出 JSON 格式的日志行 (默认值: false)
  --plain          纯文本输出（无 ANSI 样式） (默认值: false)
  --no-color       禁用 ANSI 颜色
  --url <url>      Gateway WebSocket URL (配置时默认为 gateway.remote.url)
  --token <token>  Gateway 令牌 (如果需要)
  --timeout <ms>   超时时间（毫秒） (默认值: "10000")
  --expect-final   等待最终响应（代理） (默认值: false)
  -h, --help       显示命令帮助

文档: https://docs.openclaw.ai/cli/logs


========================================================================
openclaw system
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 我保守秘密就像金库一样……除非你再次将它们打印在调试日志中。

Usage: openclaw system [options] [command]

系统工具（事件、心跳、在线状态）

Options:
  -h, --help  显示命令帮助

Commands:
  event       将系统事件排队并有选择地触发心跳
  heartbeat   心跳控制
  presence    列出系统在线状态条目
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/system


========================================================================
openclaw models
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 兼容 OpenAI，但不依赖 OpenAI。

Usage: openclaw models [options] [command]

模型发现、扫描和配置

Options:
  --status-json    输出 JSON（`models status --json` 的别名） (默认值: false)
  --status-plain   纯文本输出（`models status --plain` 的别名） (默认值: false)
  --agent <id>     要检查的代理 ID（覆盖 OPENCLAW_AGENT_DIR/PI_CODING_AGENT_DIR）
  -h, --help       显示命令帮助

Commands:
  list             列出模型（默认配置）
  status           显示已配置的模型状态
  set              设置默认模型
  set-image        设置图像模型
  aliases          管理模型别名
  fallbacks        管理模型回退列表
  image-fallbacks  管理图像模型回退列表
  scan             扫描 OpenRouter 免费模型以获取工具 + 图像
  auth             管理模型授权配置文件

文档: https://docs.openclaw.ai/cli/models


========================================================================
openclaw approvals
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Meta 都希望他们能发布得这么快。

Usage: openclaw approvals|exec-approvals [options] [command]

管理执行审批 (Gateway 或节点主机)

Options:
  -h, --help  显示命令帮助

Commands:
  get         获取执行审批快照
  set         使用 JSON 文件替换执行审批
  allowlist   编辑每个代理的允许列表
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/approvals


========================================================================
openclaw nodes
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — IPC，但是你的手机。

Usage: openclaw nodes [options] [command]

管理 Gateway 拥有的节点配对

Options:
  -h, --help  显示命令帮助

Commands:
  status      列出已知节点及其连接状态和能力
  describe    描述节点（能力 + 支持的调用命令）
  list        列出待处理和已配对的节点
  pending     列出待处理的配对请求
  approve     批准待处理的配对请求
  reject      拒绝待处理的配对请求
  rename      重命名已配对节点（覆盖显示名称）
  invoke      在已配对节点上调用命令
  run         在节点上运行 shell 命令（仅限 mac）
  notify      在节点上发送本地通知（仅限 mac）
  canvas      从已配对节点捕获或渲染画布内容
  camera      从已配对节点捕获相机媒体
  screen      从已配对节点捕获屏幕录制
  location    从已配对节点获取位置
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/nodes


========================================================================
openclaw devices
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 我保守秘密就像金库一样……除非你再次将它们打印在调试日志中。

Usage: openclaw devices [options] [command]

设备配对和身份验证令牌

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出待处理和已配对的设备
  approve     批准待处理的设备配对请求
  reject      拒绝待处理的设备配对请求
  rotate      轮换某个角色的设备令牌
  revoke      撤销某个角色的设备令牌
  help        显示命令帮助

========================================================================
openclaw node
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 我阅读日志，这样你就可以继续假装你不需要这么做。

Usage: openclaw node [options] [command]

运行无头节点主机 (system.run/system.which)

Options:
  -h, --help  显示命令帮助

Commands:
  run         运行无头节点主机 (前台)
  status      显示节点主机状态
  install     安装节点主机服务 (launchd/systemd/schtasks)
  uninstall   卸载节点主机服务 (launchd/systemd/schtasks)
  stop        停止节点主机服务 (launchd/systemd/schtasks)
  restart     重启节点主机服务 (launchd/systemd/schtasks)
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/node


========================================================================
openclaw sandbox
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 我说流利的 bash，带有轻微的讽刺，以及极具攻击性的 Tab 补全能量。

Usage: openclaw sandbox [options] [command]

管理沙盒容器 (基于 Docker 的代理隔离)

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出沙盒容器及其状态
  recreate    移除容器以使用更新后的配置强制重新创建
  explain     解释会话/代理的有效沙盒/工具策略

Examples:
  openclaw sandbox list
    列出所有沙盒容器。
  openclaw sandbox list --browser
    仅列出浏览器容器。
  openclaw sandbox recreate --all
    重新创建所有容器。
  openclaw sandbox recreate --session main
    重新创建指定会话。
  openclaw sandbox recreate --agent mybot
    重新创建代理容器。
  openclaw sandbox explain
    解释有效的沙盒配置。


文档: https://docs.openclaw.ai/cli/sandbox


========================================================================
openclaw tui
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 兼容 OpenAI，但不依赖 OpenAI。

Usage: openclaw tui [options]

打开连接到 Gateway 的终端 UI

Options:
  --url <url>            Gateway WebSocket URL (配置时默认为 gateway.remote.url)
  --token <token>        Gateway 令牌 (如果需要)
  --password <password>  Gateway 密码 (如果需要)
  --session <key>        会话密钥 (默认值: "main", 如果范围是全局，则为 "global")
  --deliver              传递助手的回复 (默认值: false)
  --thinking <level>     覆盖思考级别
  --message <text>       连接后发送初始消息
  --timeout-ms <ms>      代理超时时间（毫秒）(默认为 agents.defaults.timeoutSeconds)
  --history-limit <n>    要加载的历史条目数 (默认值: "200")
  -h, --help             显示命令帮助

文档: https://docs.openclaw.ai/cli/tui


========================================================================
openclaw cron
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 你的收件箱，你的基础设施，你的规则。

Usage: openclaw cron [options] [command]

管理 cron 任务（通过 Gateway）

Options:
  -h, --help  显示命令帮助

Commands:
  status      显示 cron 调度程序状态
  list        列出 cron 任务
  add         添加 cron 任务
  rm          移除 cron 任务
  enable      启用 cron 任务
  disable     禁用 cron 任务
  runs        显示 cron 运行历史（由 JSONL 支持）
  run         立即运行 cron 任务（调试）
  edit        编辑 cron 任务（修补字段）
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/cron


========================================================================
openclaw dns
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 不需要 999 美元的支架。

Usage: openclaw dns [options] [command]

用于广域发现的 DNS 辅助工具 (Tailscale + CoreDNS)

Options:
  -h, --help  显示命令帮助

Commands:
  setup       设置 CoreDNS 为你的发现域提供单播 DNS-SD 服务 (Wide-Area Bonjour)
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/dns


========================================================================
openclaw docs
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 我能 grep 它、git blame 它，还能温柔地吐槽它——挑个你的应对机制吧。

Usage: openclaw docs [options] [query...]

搜索实时的 OpenClaw 文档

Arguments:
  query       搜索查询

Options:
  -h, --help  显示命令帮助

文档: https://docs.openclaw.ai/cli/docs


========================================================================
openclaw hooks
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Shell yeah——我来这儿是为了处理苦差事，把荣耀留给你。

Usage: openclaw hooks [options] [command]

管理内部代理钩子

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出所有钩子
  info        显示有关钩子的详细信息
  check       检查钩子的资格状态
  enable      启用钩子
  disable     禁用钩子
  install     安装钩子包 (路径、压缩包或 npm 规范)
  update      更新已安装的钩子 (仅限 npm 安装)

文档: https://docs.openclaw.ai/cli/hooks


========================================================================
openclaw webhooks
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 唯一一个远离你训练集的机器人。

Usage: openclaw webhooks [options] [command]

Webhook 辅助工具和集成

Options:
  -h, --help  显示命令帮助

Commands:
  gmail       Gmail Pub/Sub 钩子 (通过 gogcli)
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/webhooks


========================================================================
openclaw pairing
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 我会处理无聊的事情，而你则像看电影一样戏剧性地盯着日志看。

Usage: openclaw pairing [options] [command]

安全 DM 配对（批准入站请求）

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出待处理的配对请求
  approve     批准配对码并允许该发送者
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/pairing


========================================================================
openclaw plugins
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 我基本上是一把瑞士军刀，但有更多的意见和更少的锋利边缘。

Usage: openclaw plugins [options] [command]

管理 OpenClaw 插件/扩展

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出已发现的插件
  info        显示插件详细信息
  enable      在配置中启用插件
  disable     在配置中禁用插件
  install     安装插件 (路径、压缩包或 npm 规范)
  update      更新已安装的插件 (仅限 npm 安装)
  doctor      报告插件加载问题
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/plugins


========================================================================
openclaw channels
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 你的终端刚长出了爪子——随便打点什么，让机器人来捏碎繁杂的工作。

Usage: openclaw channels [options] [command]

管理聊天频道账户

Options:
  -h, --help    显示命令帮助

Commands:
  list          列出已配置的频道 + 身份验证配置文件
  status        显示 Gateway 频道状态（使用 status --deep 获取本地状态）
  capabilities  显示提供商能力（意图/范围 + 支持的功能）
  resolve       将频道/用户名解析为 ID
  logs          显示来自 Gateway 日志文件的最近频道日志
  add           添加或更新频道账户
  remove        禁用或删除频道账户
  login         链接频道账户（如果支持）
  logout        退出频道会话（如果支持）
  help          显示命令帮助

文档: https://docs.openclaw.ai/cli/channels


========================================================================
openclaw directory
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — UNIX 哲学与你的私信相遇。

Usage: openclaw directory [options] [command]

针对支持的频道的目录查找（自身、节点、群组）

Options:
  -h, --help  显示命令帮助

Commands:
  self        显示当前账户用户
  peers       节点目录（联系人/用户）
  groups      群组目录

文档: https://docs.openclaw.ai/cli/directory


========================================================================
openclaw security
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 唯一一个远离你训练集的机器人。

Usage: openclaw security [options] [command]

安全工具（审计）

Options:
  -h, --help  显示命令帮助

Commands:
  audit       审计配置 + 本地状态以查找常见的安全隐患
  help        显示命令帮助

文档: https://docs.openclaw.ai/cli/security


========================================================================
openclaw skills
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 给我一个工作空间，我会给你更少的标签页、更少的切换，以及更多的氧气。

Usage: openclaw skills [options] [command]

列出并检查可用的技能

Options:
  -h, --help  显示命令帮助

Commands:
  list        列出所有可用技能
  info        显示有关技能的详细信息
  check       检查哪些技能已准备就绪，哪些缺少依赖要求

文档: https://docs.openclaw.ai/cli/skills


========================================================================
openclaw update
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 一个 CLI 统领一切，还得再重启一次，因为你改了端口。

Usage: openclaw update [options] [command]

将 OpenClaw 更新到最新版本

Options:
  --json                       将结果输出为 JSON (默认值: false)
  --no-restart                 成功更新后跳过重启 Gateway 服务
  --channel <stable|beta|dev>  持久化更新通道 (git + npm)
  --tag <dist-tag|version>     为本次更新覆盖 npm dist-tag 或版本
  --timeout <seconds>          每个更新步骤的超时时间（秒） (默认值: 1200)
  --yes                        跳过确认提示（非交互式） (默认值: false)
  -h, --help                   显示命令帮助

Commands:
  wizard                       交互式更新向导
  status                       显示更新通道和版本状态

此操作的功能：
  - Git 检出：拉取（fetches）、变基（rebases）、安装依赖（installs deps）、构建（builds）并运行 doctor
  - npm 安装：通过检测到的包管理器进行更新

切换通道：
  - 使用 --channel stable|beta|dev 在配置中持久化更新通道
  - 运行 openclaw update status 查看活动的通道和来源
  - 使用 --tag <dist-tag|version> 进行一次性的 npm 更新而不持久化

非交互式：
  - 使用 --yes 接受降级提示
  - 根据需要结合 --channel/--tag/--restart/--json/--timeout 使用

Examples:
  openclaw update # 更新源码检出 (git)
  openclaw update --channel beta # 切换到 beta 通道 (git + npm)
  openclaw update --channel dev # 切换到 dev 通道 (git + npm)
  openclaw update --tag beta # 对 dist-tag 或版本进行一次性更新
  openclaw update --no-restart # 更新而不重启服务
  openclaw update --json # 将结果输出为 JSON
  openclaw update --yes # 非交互式 (接受降级提示)
  openclaw update wizard # 交互式更新向导
  openclaw --update # openclaw update 的简写

Notes:
  - 使用 --channel stable|beta|dev 切换通道
  - 对于全局安装：如果可能，通过检测到的包管理器自动更新（参见 docs/install/updating.md）
  - 降级需要确认（可能会破坏配置）
  - 如果工作目录有未提交的更改，则跳过更新

文档: https://docs.openclaw.ai/cli/update

========================================================================
openclaw completion
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — 自信地输入命令吧——如果需要，大自然会提供堆栈跟踪的。

Usage: openclaw completion [options]

生成 shell 自动补全脚本

Options:
  -s, --shell <shell>  要生成补全的 Shell（可选值："zsh", "bash", "powershell", "fish"，默认值："zsh"）
  -i, --install        将补全脚本安装到 shell 配置文件
  -y, --yes            跳过确认（非交互式） (默认值: false)
  -h, --help           显示命令帮助

========================================================================
openclaw help
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Meta 都希望他们能发布得这么快。

Usage: openclaw [options] [command]

Options:
  -V, --version     输出版本号
  --dev             Dev 配置文件：在 ~/.openclaw-dev 下隔离状态，默认 Gateway 端口为 19001，并偏移衍生端口 (browser/canvas)
  --profile <name>  使用命名的配置文件 (将 OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH 隔离在 ~/.openclaw-<name> 下)
  --no-color        禁用 ANSI 颜色
  -h, --help        显示命令帮助

Commands:
  setup             初始化 ~/.openclaw/openclaw.json 和代理工作区
  onboard           设置 Gateway、工作区和技能的交互式向导
  configure         设置凭据、设备和代理默认值的交互式提示
  config            配置辅助工具 (get/set/unset)。不带子命令运行将启动向导。
  doctor            针对 Gateway 和频道的健康检查 + 快速修复
  dashboard         使用你的当前令牌打开控制 UI
  reset             重置本地配置/状态（保留已安装的 CLI）
  uninstall         卸载 Gateway 服务 + 本地数据（保留 CLI）
  message           发送消息和频道操作
  memory            记忆搜索工具
  agent             通过 Gateway 运行代理轮次（使用 --local 进行内嵌运行）
  agents            管理隔离的代理 (工作区 + 身份验证 + 路由)
  acp               代理控制协议工具
  gateway           Gateway 控制
  daemon            Gateway 服务 (旧版别名)
  logs              Gateway 日志
  system            系统事件、心跳和在线状态
  models            模型配置
  approvals         执行审批
  nodes             节点命令
  devices           设备配对 + 令牌管理
  node              节点控制
  sandbox           沙盒工具
  tui               终端 UI
  cron              Cron 调度程序
  dns               DNS 辅助工具
  docs              文档辅助工具
  hooks             钩子工具
  webhooks          Webhook 辅助工具
  pairing           配对辅助工具
  plugins           插件管理
  channels          频道管理
  directory         目录命令
  security          安全辅助工具
  skills            技能管理
  update            CLI 更新辅助工具
  completion        生成 shell 自动补全脚本
  status            显示频道健康状况和最近会话接收者
  health            从运行中的 Gateway 获取健康状况
  sessions          列出存储的对话会话
  browser           管理 OpenClaw 的专用浏览器 (Chrome/Chromium)
  help              显示命令帮助

Examples:
  openclaw channels login --verbose
    链接个人 WhatsApp Web 并显示二维码 + 连接日志。
  openclaw message send --target +15555550123 --message "Hi" --json
    通过你的网页会话发送并打印 JSON 结果。
  openclaw gateway --port 18789
    在本地运行 WebSocket Gateway。
  openclaw --dev gateway
    在 ws://127.0.0.1:19001 运行 dev Gateway（隔离状态/配置）。
  openclaw gateway --force
    杀死任何绑定到默认 Gateway 端口的进程，然后启动它。
  openclaw gateway ...
    通过 WebSocket 控制 Gateway。
  openclaw agent --to +15555550123 --message "Run summary" --deliver
    使用 Gateway 直接与代理对话；有选择地发送 WhatsApp 回复。
  openclaw message send --channel telegram --target @mychat --message "Hi"
    通过你的 Telegram 机器人发送。

文档: https://docs.openclaw.ai/cli
```

