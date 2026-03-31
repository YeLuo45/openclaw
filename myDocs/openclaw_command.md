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
  -V, --version     output the version number
  --dev             Dev profile: isolate state under ~/.openclaw-dev, default
                    gateway port 19001, and shift derived ports (browser/canvas)
  --profile <name>  Use a named profile (isolates
                    OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH under
                    ~/.openclaw-<name>)
  --no-color        Disable ANSI colors
  -h, --help        display help for command

Commands:
  setup             Initialize ~/.openclaw/openclaw.json and the agent workspace
  onboard           Interactive wizard to set up the gateway, workspace, and
                    skills
  configure         Interactive prompt to set up credentials, devices, and agent
                    defaults
  config            Config helpers (get/set/unset). Run without subcommand for
                    the wizard.
  doctor            Health checks + quick fixes for the gateway and channels
  dashboard         Open the Control UI with your current token
  reset             Reset local config/state (keeps the CLI installed)
  uninstall         Uninstall the gateway service + local data (CLI remains)
  message           Send messages and channel actions
  memory            Memory search tools
  agent             Run an agent turn via the Gateway (use --local for embedded)
  agents            Manage isolated agents (workspaces + auth + routing)
  acp               Agent Control Protocol tools
  gateway           Gateway control
  daemon            Gateway service (legacy alias)
  logs              Gateway logs
  system            System events, heartbeat, and presence
  models            Model configuration
  approvals         Exec approvalsmodels
  nodes             Node commands
  devices           Device pairing + token management
  node              Node control
  sandbox           Sandbox tools
  tui               Terminal UI
  cron              Cron scheduler
  dns               DNS helpers
  docs              Docs helpers
  hooks             Hooks tooling
  webhooks          Webhook helpers
  pairing           Pairing helpers
  plugins           Plugin management
  channels          Channel management
  directory         Directory commands
  security          Security helpers
  skills            Skills management
  update            CLI update helpers
  completion        Generate shell completion script
  status            Show channel health and recent session recipients
  health            Fetch health from the running gateway
  sessions          List stored conversation sessions
  browser           Manage OpenClaw's dedicated browser (Chrome/Chromium)
  help              display help for command

Examples:
  openclaw channels login --verbose
    Link personal WhatsApp Web and show QR + connection logs.
  openclaw message send --target +15555550123 --message "Hi" --json
    Send via your web session and print JSON result.
  openclaw gateway --port 18789
    Run the WebSocket Gateway locally.
  openclaw --dev gateway
    Run a dev Gateway (isolated state/config) on ws://127.0.0.1:19001.
  openclaw gateway --force
    Kill anything bound to the default gateway port, then start it.
  openclaw gateway ...
    Gateway control via WebSocket.
  openclaw agent --to +15555550123 --message "Run summary" --deliver
    Talk directly to the agent using the Gateway; optionally send the WhatsApp reply.
  openclaw message send --channel telegram --target @mychat --message "Hi"
    Send via your Telegram bot.

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
  -V, --version     output the version number
  --dev             Dev profile: isolate state under ~/.openclaw-dev, default
                    gateway port 19001, and shift derived ports (browser/canvas)
  --profile <name>  Use a named profile (isolates
                    OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH under
                    ~/.openclaw-<name>)
  --no-color        Disable ANSI colors
  -h, --help        display help for command

Commands:
  setup             Initialize ~/.openclaw/openclaw.json and the agent workspace
  onboard           Interactive wizard to set up the gateway, workspace, and
                    skills
  configure         Interactive prompt to set up credentials, devices, and agent
                    defaults
  config            Config helpers (get/set/unset). Run without subcommand for
                    the wizard.
  doctor            Health checks + quick fixes for the gateway and channels
  dashboard         Open the Control UI with your current token
  reset             Reset local config/state (keeps the CLI installed)
  uninstall         Uninstall the gateway service + local data (CLI remains)
  message           Send messages and channel actions
  memory            Memory search tools
  agent             Run an agent turn via the Gateway (use --local for embedded)
  agents            Manage isolated agents (workspaces + auth + routing)
  status            Show channel health and recent session recipients
  health            Fetch health from the running gateway
  sessions          List stored conversation sessions
  browser           Manage OpenClaw's dedicated browser (Chrome/Chromium)
  help              display help for command


========================================================================
openclaw setup
========================================================================

Usage: openclaw setup [options]

Initialize ~/.openclaw/openclaw.json and the agent workspace

Options:
  --workspace <dir>       Agent workspace directory (default:
                          ~/.openclaw/workspace; stored as
                          agents.defaults.workspace)
  --wizard                Run the interactive onboarding wizard (default: false)
  --non-interactive       Run the wizard without prompts (default: false)
  --mode <mode>           Wizard mode: local|remote
  --remote-url <url>      Remote Gateway WebSocket URL
  --remote-token <token>  Remote Gateway token (optional)
  -h, --help              display help for command


========================================================================
openclaw onboard
========================================================================

Usage: openclaw onboard [options]

Interactive wizard to set up the gateway, workspace, and skills

Options:
  --workspace <dir>              Agent workspace directory (default:
                                 ~/.openclaw/workspace)
  --reset                        Reset config + credentials + sessions +
                                 workspace before running wizard
  --non-interactive              Run without prompts (default: false)
  --accept-risk                  Acknowledge that agents are powerful and full
                                 system access is risky (required for
                                 --non-interactive) (default: false)
  --flow <flow>                  Wizard flow: quickstart|advanced|manual
  --mode <mode>                  Wizard mode: local|remote
  --auth-choice <choice>         Auth:
                                 setup-token|token|chutes|openai-codex|openai-api-key|openrouter-api-key|ai-gateway-api-key|moonshot-api-key|kimi-code-api-key|synthetic-api-key|venice-api-key|gemini-api-key|zai-api-key|xiaomi-api-key|apiKey|minimax-api|minimax-api-lightning|opencode-zen|skip
  --token-provider <id>          Token provider id (non-interactive; used with
                                 --auth-choice token)
  --token <token>                Token value (non-interactive; used with
                                 --auth-choice token)
  --token-profile-id <id>        Auth profile id (non-interactive; default:
                                 <provider>:manual)
  --token-expires-in <duration>  Optional token expiry duration (e.g. 365d, 12h)
  --anthropic-api-key <key>      Anthropic API key
  --openai-api-key <key>         OpenAI API key
  --openrouter-api-key <key>     OpenRouter API key
  --ai-gateway-api-key <key>     Vercel AI Gateway API key
  --moonshot-api-key <key>       Moonshot API key
  --kimi-code-api-key <key>      Kimi Coding API key
  --gemini-api-key <key>         Gemini API key
  --zai-api-key <key>            Z.AI API key
  --xiaomi-api-key <key>         Xiaomi API key
  --minimax-api-key <key>        MiniMax API key
  --synthetic-api-key <key>      Synthetic API key
  --venice-api-key <key>         Venice API key
  --opencode-zen-api-key <key>   OpenCode Zen API key
  --gateway-port <port>          Gateway port
  --gateway-bind <mode>          Gateway bind: loopback|tailnet|lan|auto|custom
  --gateway-auth <mode>          Gateway auth: token|password
  --gateway-token <token>        Gateway token (token auth)
  --gateway-password <password>  Gateway password (password auth)
  --remote-url <url>             Remote Gateway WebSocket URL
  --remote-token <token>         Remote Gateway token (optional)
  --tailscale <mode>             Tailscale: off|serve|funnel
  --tailscale-reset-on-exit      Reset tailscale serve/funnel on exit
  --install-daemon               Install gateway service
  --no-install-daemon            Skip gateway service install
  --skip-daemon                  Skip gateway service install
  --daemon-runtime <runtime>     Daemon runtime: node|bun
  --skip-channels                Skip channel setup
  --skip-skills                  Skip skills setup
  --skip-health                  Skip health check
  --skip-ui                      Skip Control UI/TUI prompts
  --node-manager <name>          Node manager for skills: npm|pnpm|bun
  --json                         Output JSON summary (default: false)
  -h, --help                     display help for command


========================================================================
openclaw configure
========================================================================

Usage: openclaw configure [options]

Interactive prompt to set up credentials, devices, and agent defaults

Options:
  --section <section>  Configuration sections (repeatable). Options: workspace,
                       model, web, gateway, daemon, channels, skills, health
                       (default: [])
  -h, --help           display help for command


========================================================================
openclaw config
========================================================================

Usage: openclaw config [options] [command]

Config helpers (get/set/unset). Run without subcommand for the wizard.

Options:
  --section <section>  Configure wizard sections (repeatable). Use with no
                       subcommand. (default: [])
  -h, --help           display help for command

Commands:
  get                  Get a config value by dot path
  set                  Set a config value by dot path
  unset                Remove a config value by dot path


========================================================================
openclaw config get
========================================================================

Usage: openclaw config get [options] <path>

Get a config value by dot path

Arguments:
  path        Config path (dot or bracket notation)

Options:
  --json      Output JSON (default: false)
  -h, --help  display help for command


========================================================================
openclaw config set
========================================================================

Usage: openclaw config set [options] <path> <value>

Set a config value by dot path

Arguments:
  path        Config path (dot or bracket notation)
  value       Value (JSON5 or raw string)

Options:
  --json      Parse value as JSON5 (required) (default: false)
  -h, --help  display help for command


========================================================================
openclaw config unset
========================================================================

Usage: openclaw config unset [options] <path>

Remove a config value by dot path

Arguments:
  path        Config path (dot or bracket notation)

Options:
  -h, --help  display help for command


========================================================================
openclaw doctor
========================================================================

Usage: openclaw doctor [options]

Health checks + quick fixes for the gateway and channels

Options:
  --no-workspace-suggestions  Disable workspace memory system suggestions
  --yes                       Accept defaults without prompting (default: false)
  --repair                    Apply recommended repairs without prompting
                              (default: false)
  --fix                       Apply recommended repairs (alias for --repair)
                              (default: false)
  --force                     Apply aggressive repairs (overwrites custom
                              service config) (default: false)
  --non-interactive           Run without prompts (safe migrations only)
                              (default: false)
  --generate-gateway-token    Generate and configure a gateway token (default:
                              false)
  --deep                      Scan system services for extra gateway installs
                              (default: false)
  -h, --help                  display help for command


========================================================================
openclaw dashboard
========================================================================

Usage: openclaw dashboard [options]

Open the Control UI with your current token

Options:
  --no-open   Print URL but do not launch a browser
  -h, --help  display help for command


========================================================================
openclaw reset
========================================================================

Usage: openclaw reset [options]

Reset local config/state (keeps the CLI installed)

Options:
  --scope <scope>    config|config+creds+sessions|full (default: interactive
                     prompt)
  --yes              Skip confirmation prompts (default: false)
  --non-interactive  Disable prompts (requires --scope + --yes) (default: false)
  --dry-run          Print actions without removing files (default: false)
  -h, --help         display help for command


========================================================================
openclaw uninstall
========================================================================

Usage: openclaw uninstall [options]

Uninstall the gateway service + local data (CLI remains)

Options:
  --service          Remove the gateway service (default: false)
  --state            Remove state + config (default: false)
  --workspace        Remove workspace dirs (default: false)
  --app              Remove the macOS app (default: false)
  --all              Remove service + state + workspace + app (default: false)
  --yes              Skip confirmation prompts (default: false)
  --non-interactive  Disable prompts (requires --yes) (default: false)
  --dry-run          Print actions without removing files (default: false)
  -h, --help         display help for command


========================================================================
openclaw message
========================================================================

Usage: openclaw message [options] [command]

Send messages and channel actions

Options:
  -h, --help   display help for command

Commands:
  send         Send a message
  broadcast    Broadcast a message to multiple targets
  poll         Send a poll
  react        Add or remove a reaction
  reactions    List reactions on a message
  read         Read recent messages
  edit         Edit a message
  delete       Delete a message
  pin          Pin a message
  unpin        Unpin a message
  pins         List pinned messages
  permissions  Fetch channel permissions
  search       Search Discord messages
  thread       Thread actions
  emoji        Emoji actions
  sticker      Sticker actions
  role         Role actions
  channel      Channel actions
  member       Member actions
  voice        Voice actions
  event        Event actions
  timeout      Timeout a member
  kick         Kick a member
  ban          Ban a member


========================================================================
openclaw message send
========================================================================

Usage: openclaw message send [options]

Send a message

Options:
  -m, --message <text>   Message body (required unless --media is set)
  -t, --target <dest>    Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                         chat id/@username, Discord/Slack channel/user, or
                         iMessage handle/chat_id
  --media <path-or-url>  Attach media (image/audio/video/document). Accepts
                         local paths or URLs.
  --buttons <json>       Telegram inline keyboard buttons as JSON (array of
                         button rows)
  --card <json>          Adaptive Card JSON object (when supported by the
                         channel)
  --reply-to <id>        Reply-to message id
  --thread-id <id>       Thread id (Telegram forum thread)
  --gif-playback         Treat video media as GIF playback (WhatsApp only).
                         (default: false)
  --silent               Send message silently without notification (Telegram
                         only) (default: false)
  --channel <channel>    Channel:
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         Channel account id (accountId)
  --json                 Output result as JSON (default: false)
  --dry-run              Print payload and skip sending (default: false)
  --verbose              Verbose logging (default: false)
  -h, --help             display help for command


========================================================================
openclaw message broadcast
========================================================================

Usage: openclaw message broadcast [options]

Broadcast a message to multiple targets

Options:
  --channel <channel>    Channel:
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         Channel account id (accountId)
  --json                 Output result as JSON (default: false)
  --dry-run              Print payload and skip sending (default: false)
  --verbose              Verbose logging (default: false)
  --targets <target...>  Recipient/channel targets (same format as --target);
                         accepts ids or names when the directory is available.
  --message <text>       Message to send
  --media <url>          Media URL
  -h, --help             display help for command


========================================================================
openclaw message poll
========================================================================

Usage: openclaw message poll [options]

Send a poll

Options:
  -t, --target <dest>        Recipient/channel: E.164 for WhatsApp/Signal,
                             Telegram chat id/@username, Discord/Slack
                             channel/user, or iMessage handle/chat_id
  --channel <channel>        Channel:
                             telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>             Channel account id (accountId)
  --json                     Output result as JSON (default: false)
  --dry-run                  Print payload and skip sending (default: false)
  --verbose                  Verbose logging (default: false)
  --poll-question <text>     Poll question
  --poll-option <choice>     Poll option (repeat 2-12 times) (default: [])
  --poll-multi               Allow multiple selections (default: false)
  --poll-duration-hours <n>  Poll duration (Discord)
  -m, --message <text>       Optional message body
  -h, --help                 display help for command


========================================================================
openclaw message react
========================================================================

Usage: openclaw message react [options]

Add or remove a reaction

Options:
  -t, --target <dest>          Recipient/channel: E.164 for WhatsApp/Signal,
                               Telegram chat id/@username, Discord/Slack
                               channel/user, or iMessage handle/chat_id
  --channel <channel>          Channel:
                               telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>               Channel account id (accountId)
  --json                       Output result as JSON (default: false)
  --dry-run                    Print payload and skip sending (default: false)
  --verbose                    Verbose logging (default: false)
  --message-id <id>            Message id
  --emoji <emoji>              Emoji for reactions
  --remove                     Remove reaction (default: false)
  --participant <id>           WhatsApp reaction participant
  --from-me                    WhatsApp reaction fromMe (default: false)
  --target-author <id>         Signal reaction target author (uuid or phone)
  --target-author-uuid <uuid>  Signal reaction target author uuid
  -h, --help                   display help for command


========================================================================
openclaw message reactions
========================================================================

Usage: openclaw message reactions [options]

List reactions on a message

Options:
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --message-id <id>    Message id
  --limit <n>          Result limit
  -h, --help           display help for command


========================================================================
openclaw message read
========================================================================

Usage: openclaw message read [options]

Read recent messages

Options:
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --limit <n>          Result limit
  --before <id>        Read/search before id
  --after <id>         Read/search after id
  --around <id>        Read around id
  --include-thread     Include thread replies (Discord) (default: false)
  -h, --help           display help for command


========================================================================
openclaw message edit
========================================================================

Usage: openclaw message edit [options]

Edit a message

Options:
  --message-id <id>     Message id
  -m, --message <text>  Message body
  -t, --target <dest>   Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                        chat id/@username, Discord/Slack channel/user, or
                        iMessage handle/chat_id
  --channel <channel>   Channel:
                        telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>        Channel account id (accountId)
  --json                Output result as JSON (default: false)
  --dry-run             Print payload and skip sending (default: false)
  --verbose             Verbose logging (default: false)
  --thread-id <id>      Thread id (Telegram forum thread)
  -h, --help            display help for command


========================================================================
openclaw message delete
========================================================================

Usage: openclaw message delete [options]

Delete a message

Options:
  --message-id <id>    Message id
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message pin
========================================================================

Usage: openclaw message pin [options]

Pin a message

Options:
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --message-id <id>    Message id
  -h, --help           display help for command


========================================================================
openclaw message unpin
========================================================================

Usage: openclaw message unpin [options]

Unpin a message

Options:
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --message-id <id>    Message id
  -h, --help           display help for command


========================================================================
openclaw message pins
========================================================================

Usage: openclaw message pins [options]

List pinned messages

Options:
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --limit <n>          Result limit
  -h, --help           display help for command


========================================================================
openclaw message permissions
========================================================================

Usage: openclaw message permissions [options]

Fetch channel permissions

Options:
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message search
========================================================================

Usage: openclaw message search [options]

Search Discord messages

Options:
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --guild-id <id>      Guild id
  --query <text>       Search query
  --channel-id <id>    Channel id
  --channel-ids <id>   Channel id (repeat) (default: [])
  --author-id <id>     Author id
  --author-ids <id>    Author id (repeat) (default: [])
  --limit <n>          Result limit
  -h, --help           display help for command


========================================================================
openclaw message thread
========================================================================

Usage: openclaw message thread [options] [command]

Thread actions

Options:
  -h, --help  display help for command

Commands:
  create      Create a thread
  list        List threads
  reply       Reply in a thread
  help        display help for command


========================================================================
openclaw message thread create
========================================================================

Usage: openclaw message thread create [options]

Create a thread

Options:
  --thread-name <name>    Thread name
  -t, --target <dest>     Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                          chat id/@username, Discord/Slack channel/user, or
                          iMessage handle/chat_id
  --channel <channel>     Channel:
                          telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>          Channel account id (accountId)
  --json                  Output result as JSON (default: false)
  --dry-run               Print payload and skip sending (default: false)
  --verbose               Verbose logging (default: false)
  --message-id <id>       Message id (optional)
  --auto-archive-min <n>  Thread auto-archive minutes
  -h, --help              display help for command


========================================================================
openclaw message thread list
========================================================================

Usage: openclaw message thread list [options]

List threads

Options:
  --guild-id <id>      Guild id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --channel-id <id>    Channel id
  --include-archived   Include archived threads (default: false)
  --before <id>        Read/search before id
  --limit <n>          Result limit
  -h, --help           display help for command


========================================================================
openclaw message thread reply
========================================================================

Usage: openclaw message thread reply [options]

Reply in a thread

Options:
  -m, --message <text>   Message body
  -t, --target <dest>    Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                         chat id/@username, Discord/Slack channel/user, or
                         iMessage handle/chat_id
  --channel <channel>    Channel:
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         Channel account id (accountId)
  --json                 Output result as JSON (default: false)
  --dry-run              Print payload and skip sending (default: false)
  --verbose              Verbose logging (default: false)
  --media <path-or-url>  Attach media (image/audio/video/document). Accepts
                         local paths or URLs.
  --reply-to <id>        Reply-to message id
  -h, --help             display help for command


========================================================================
openclaw message emoji
========================================================================

Usage: openclaw message emoji [options] [command]

Emoji actions

Options:
  -h, --help  display help for command

Commands:
  list        List emojis
  upload      Upload an emoji
  help        display help for command


========================================================================
openclaw message emoji list
========================================================================

Usage: openclaw message emoji list [options]

List emojis

Options:
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --guild-id <id>      Guild id (Discord)
  -h, --help           display help for command


========================================================================
openclaw message emoji upload
========================================================================

Usage: openclaw message emoji upload [options]

Upload an emoji

Options:
  --guild-id <id>        Guild id
  --channel <channel>    Channel:
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         Channel account id (accountId)
  --json                 Output result as JSON (default: false)
  --dry-run              Print payload and skip sending (default: false)
  --verbose              Verbose logging (default: false)
  --emoji-name <name>    Emoji name
  --media <path-or-url>  Emoji media (path or URL)
  --role-ids <id>        Role id (repeat) (default: [])
  -h, --help             display help for command


========================================================================
openclaw message sticker
========================================================================

Usage: openclaw message sticker [options] [command]

Sticker actions

Options:
  -h, --help  display help for command

Commands:
  send        Send stickers
  upload      Upload a sticker
  help        display help for command


========================================================================
openclaw message sticker send
========================================================================

Usage: openclaw message sticker send [options]

Send stickers

Options:
  -t, --target <dest>   Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                        chat id/@username, Discord/Slack channel/user, or
                        iMessage handle/chat_id
  --channel <channel>   Channel:
                        telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>        Channel account id (accountId)
  --json                Output result as JSON (default: false)
  --dry-run             Print payload and skip sending (default: false)
  --verbose             Verbose logging (default: false)
  --sticker-id <id>     Sticker id (repeat)
  -m, --message <text>  Optional message body
  -h, --help            display help for command


========================================================================
openclaw message sticker upload
========================================================================

Usage: openclaw message sticker upload [options]

Upload a sticker

Options:
  --guild-id <id>        Guild id
  --channel <channel>    Channel:
                         telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>         Channel account id (accountId)
  --json                 Output result as JSON (default: false)
  --dry-run              Print payload and skip sending (default: false)
  --verbose              Verbose logging (default: false)
  --sticker-name <name>  Sticker name
  --sticker-desc <text>  Sticker description
  --sticker-tags <tags>  Sticker tags
  --media <path-or-url>  Sticker media (path or URL)
  -h, --help             display help for command


========================================================================
openclaw message role
========================================================================

Usage: openclaw message role [options] [command]

Role actions

Options:
  -h, --help  display help for command

Commands:
  info        List roles
  add         Add role to a member
  remove      Remove role from a member
  help        display help for command


========================================================================
openclaw message role info
========================================================================

Usage: openclaw message role info [options]

List roles

Options:
  --guild-id <id>      Guild id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message role add
========================================================================

Usage: openclaw message role add [options]

Add role to a member

Options:
  --guild-id <id>      Guild id
  --user-id <id>       User id
  --role-id <id>       Role id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message role remove
========================================================================

Usage: openclaw message role remove [options]

Remove role from a member

Options:
  --guild-id <id>      Guild id
  --user-id <id>       User id
  --role-id <id>       Role id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message channel
========================================================================

Usage: openclaw message channel [options] [command]

Channel actions

Options:
  -h, --help  display help for command

Commands:
  info        Fetch channel info
  list        List channels
  help        display help for command


========================================================================
openclaw message channel info
========================================================================

Usage: openclaw message channel info [options]

Fetch channel info

Options:
  -t, --target <dest>  Recipient/channel: E.164 for WhatsApp/Signal, Telegram
                       chat id/@username, Discord/Slack channel/user, or
                       iMessage handle/chat_id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message channel list
========================================================================

Usage: openclaw message channel list [options]

List channels

Options:
  --guild-id <id>      Guild id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message member
========================================================================

Usage: openclaw message member [options] [command]

Member actions

Options:
  -h, --help  display help for command

Commands:
  info        Fetch member info
  help        display help for command


========================================================================
openclaw message member info
========================================================================

Usage: openclaw message member info [options]

Fetch member info

Options:
  --user-id <id>       User id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --guild-id <id>      Guild id (Discord)
  -h, --help           display help for command


========================================================================
openclaw message voice
========================================================================

Usage: openclaw message voice [options] [command]

Voice actions

Options:
  -h, --help  display help for command

Commands:
  status      Fetch voice status
  help        display help for command


========================================================================
openclaw message voice status
========================================================================

Usage: openclaw message voice status [options]

Fetch voice status

Options:
  --guild-id <id>      Guild id
  --user-id <id>       User id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message event
========================================================================

Usage: openclaw message event [options] [command]

Event actions

Options:
  -h, --help  display help for command

Commands:
  list        List scheduled events
  create      Create a scheduled event
  help        display help for command


========================================================================
openclaw message event list
========================================================================

Usage: openclaw message event list [options]

List scheduled events

Options:
  --guild-id <id>      Guild id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  -h, --help           display help for command


========================================================================
openclaw message event create
========================================================================

Usage: openclaw message event create [options]

Create a scheduled event

Options:
  --guild-id <id>                      Guild id
  --event-name <name>                  Event name
  --start-time <iso>                   Event start time
  --channel <channel>                  Channel:
                                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>                       Channel account id (accountId)
  --json                               Output result as JSON (default: false)
  --dry-run                            Print payload and skip sending (default:
                                       false)
  --verbose                            Verbose logging (default: false)
  --end-time <iso>                     Event end time
  --desc <text>                        Event description
  --channel-id <id>                    Channel id
  --location <text>                    Event location
  --event-type <stage|external|voice>  Event type
  -h, --help                           display help for command


========================================================================
openclaw message timeout
========================================================================

Usage: openclaw message timeout [options]

Timeout a member

Options:
  --guild-id <id>      Guild id
  --user-id <id>       User id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --duration-min <n>   Timeout duration minutes
  --until <iso>        Timeout until
  --reason <text>      Moderation reason
  -h, --help           display help for command


========================================================================
openclaw message kick
========================================================================

Usage: openclaw message kick [options]

Kick a member

Options:
  --guild-id <id>      Guild id
  --user-id <id>       User id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --reason <text>      Moderation reason
  -h, --help           display help for command


========================================================================
openclaw message ban
========================================================================

Usage: openclaw message ban [options]

Ban a member

Options:
  --guild-id <id>      Guild id
  --user-id <id>       User id
  --channel <channel>  Channel:
                       telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
  --account <id>       Channel account id (accountId)
  --json               Output result as JSON (default: false)
  --dry-run            Print payload and skip sending (default: false)
  --verbose            Verbose logging (default: false)
  --reason <text>      Moderation reason
  --delete-days <n>    Ban delete message days
  -h, --help           display help for command


========================================================================
openclaw memory
========================================================================

Usage: openclaw memory [options] [command]

Memory search tools

Options:
  -h, --help  display help for command

Commands:
  status      Show memory search index status
  index       Reindex memory files
  search      Search memory files
  help        display help for command


========================================================================
openclaw memory status
========================================================================

Usage: openclaw memory status [options]

Show memory search index status

Options:
  --agent <id>  Agent id (default: default agent)
  --json        Print JSON
  --deep        Probe embedding provider availability
  --index       Reindex if dirty (implies --deep)
  --verbose     Verbose logging (default: false)
  -h, --help    display help for command


========================================================================
openclaw memory index
========================================================================

Usage: openclaw memory index [options]

Reindex memory files

Options:
  --agent <id>  Agent id (default: default agent)
  --force       Force full reindex (default: false)
  --verbose     Verbose logging (default: false)
  -h, --help    display help for command


========================================================================
openclaw memory search
========================================================================

Usage: openclaw memory search [options] <query>

Search memory files

Arguments:
  query              Search query

Options:
  --agent <id>       Agent id (default: default agent)
  --max-results <n>  Max results
  --min-score <n>    Minimum score
  --json             Print JSON
  -h, --help         display help for command


========================================================================
openclaw agent
========================================================================

Usage: openclaw agent [options]

Run an agent turn via the Gateway (use --local for embedded)

Options:
  -m, --message <text>       Message body for the agent
  -t, --to <number>          Recipient number in E.164 used to derive the
                             session key
  --session-id <id>          Use an explicit session id
  --agent <id>               Agent id (overrides routing bindings)
  --thinking <level>         Thinking level: off | minimal | low | medium | high
  --verbose <on|off>         Persist agent verbose level for the session
  --channel <channel>        Delivery channel:
                             last|telegram|whatsapp|discord|googlechat|slack|signal|imessage|nostr|msteams|mattermost|nextcloud-talk|matrix|bluebubbles|line|zalo|zalouser|tlon
                             (default: whatsapp)
  --reply-to <target>        Delivery target override (separate from session
                             routing)
  --reply-channel <channel>  Delivery channel override (separate from routing)
  --reply-account <id>       Delivery account id override
  --local                    Run the embedded agent locally (requires model
                             provider API keys in your shell) (default: false)
  --deliver                  Send the agent's reply back to the selected channel
                             (default: false)
  --json                     Output result as JSON (default: false)
  --timeout <seconds>        Override agent command timeout (seconds, default
                             600 or config value)
  -h, --help                 display help for command


========================================================================
openclaw agents
========================================================================

Usage: openclaw agents [options] [command]

Manage isolated agents (workspaces + auth + routing)

Options:
  -h, --help    display help for command

Commands:
  list          List configured agents
  add           Add a new isolated agent
  set-identity  Update an agent identity (name/theme/emoji/avatar)
  delete        Delete an agent and prune workspace/state


========================================================================
openclaw agents list
========================================================================

Usage: openclaw agents list [options]

List configured agents

Options:
  --json      Output JSON instead of text (default: false)
  --bindings  Include routing bindings (default: false)
  -h, --help  display help for command


========================================================================
openclaw agents add
========================================================================

Usage: openclaw agents add [options] [name]

Add a new isolated agent

Options:
  --workspace <dir>             Workspace directory for the new agent
  --model <id>                  Model id for this agent
  --agent-dir <dir>             Agent state directory for this agent
  --bind <channel[:accountId]>  Route channel binding (repeatable) (default: [])
  --non-interactive             Disable prompts; requires --workspace (default:
                                false)
  --json                        Output JSON summary (default: false)
  -h, --help                    display help for command


========================================================================
openclaw agents set-identity
========================================================================

Usage: openclaw agents set-identity [options]

Update an agent identity (name/theme/emoji/avatar)

Options:
  --agent <id>            Agent id to update
  --workspace <dir>       Workspace directory used to locate the agent +
                          IDENTITY.md
  --identity-file <path>  Explicit IDENTITY.md path to read
  --from-identity         Read values from IDENTITY.md (default: false)
  --name <name>           Identity name
  --theme <theme>         Identity theme
  --emoji <emoji>         Identity emoji
  --avatar <value>        Identity avatar (workspace path, http(s) URL, or data
                          URI)
  --json                  Output JSON summary (default: false)
  -h, --help              display help for command


========================================================================
openclaw agents delete
========================================================================

Usage: openclaw agents delete [options] <id>

Delete an agent and prune workspace/state

Options:
  --force     Skip confirmation (default: false)
  --json      Output JSON summary (default: false)
  -h, --help  display help for command


========================================================================
openclaw status
========================================================================

Usage: openclaw status [options]

Show channel health and recent session recipients

Options:
  --json          Output JSON instead of text (default: false)
  --all           Full diagnosis (read-only, pasteable) (default: false)
  --usage         Show model provider usage/quota snapshots (default: false)
  --deep          Probe channels (WhatsApp Web + Telegram + Discord + Slack +
                  Signal) (default: false)
  --timeout <ms>  Probe timeout in milliseconds (default: "10000")
  --verbose       Verbose logging (default: false)
  --debug         Alias for --verbose (default: false)
  -h, --help      display help for command


========================================================================
openclaw health
========================================================================

Usage: openclaw health [options]

Fetch health from the running gateway

Options:
  --json          Output JSON instead of text (default: false)
  --timeout <ms>  Connection timeout in milliseconds (default: "10000")
  --verbose       Verbose logging (default: false)
  --debug         Alias for --verbose (default: false)
  -h, --help      display help for command


========================================================================
openclaw sessions
========================================================================

Usage: openclaw sessions [options]

List stored conversation sessions

Options:
  --json              Output as JSON (default: false)
  --verbose           Verbose logging (default: false)
  --store <path>      Path to session store (default: resolved from config)
  --active <minutes>  Only show sessions updated within the past N minutes
  -h, --help          display help for command


========================================================================
openclaw browser
========================================================================

Usage: openclaw browser [options] [command]

Manage OpenClaw's dedicated browser (Chrome/Chromium)

Options:
  --browser-profile <name>  Browser profile name (default from config)
  --json                    Output machine-readable JSON (default: false)
  --url <url>               Gateway WebSocket URL (defaults to
                            gateway.remote.url when configured)
  --token <token>           Gateway token (if required)
  --timeout <ms>            Timeout in ms (default: "10000")
  --expect-final            Wait for final response (agent) (default: false)
  -h, --help                display help for command

Commands:
  status                    Show browser status
  start                     Start the browser (no-op if already running)
  stop                      Stop the browser (best-effort)
  reset-profile             Reset browser profile (moves it to Trash)
  tabs                      List open tabs
  tab                       Tab shortcuts (index-based)
  open                      Open a URL in a new tab
  focus                     Focus a tab by target id (or unique prefix)
  close                     Close a tab (target id optional)
  profiles                  List all browser profiles
  create-profile            Create a new browser profile
  delete-profile            Delete a browser profile
  extension                 Chrome extension helpers
  screenshot                Capture a screenshot (MEDIA:<path>)
  snapshot                  Capture a snapshot (default: ai; aria is the
                            accessibility tree)
  navigate                  Navigate the current tab to a URL
  resize                    Resize the viewport
  click                     Click an element by ref from snapshot
  type                      Type into an element by ref from snapshot
  press                     Press a key
  hover                     Hover an element by ai ref
  scrollintoview            Scroll an element into view by ref from snapshot
  drag                      Drag from one ref to another
  select                    Select option(s) in a select element
  upload                    Arm file upload for the next file chooser
  waitfordownload           Wait for the next download (and save it)
  download                  Click a ref and save the resulting download
  dialog                    Arm the next modal dialog (alert/confirm/prompt)
  fill                      Fill a form with JSON field descriptors
  wait                      Wait for time, selector, URL, load state, or JS
                            conditions
  evaluate                  Evaluate a function against the page or a ref
  console                   Get recent console messages
  pdf                       Save page as PDF
  responsebody              Wait for a network response and return its body
  highlight                 Highlight an element by ref
  errors                    Get recent page errors
  requests                  Get recent network requests (best-effort)
  trace                     Record a Playwright trace
  cookies                   Read/write cookies
  storage                   Read/write localStorage/sessionStorage
  set                       Browser environment settings


========================================================================
openclaw browser status
========================================================================

Usage: openclaw browser status [options]

Show browser status

Options:
  -h, --help  display help for command


========================================================================
openclaw browser start
========================================================================

Usage: openclaw browser start [options]

Start the browser (no-op if already running)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser stop
========================================================================

Usage: openclaw browser stop [options]

Stop the browser (best-effort)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser reset-profile
========================================================================

Usage: openclaw browser reset-profile [options]

Reset browser profile (moves it to Trash)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser tabs
========================================================================

Usage: openclaw browser tabs [options]

List open tabs

Options:
  -h, --help  display help for command


========================================================================
openclaw browser tab
========================================================================

Usage: openclaw browser tab [options] [command]

Tab shortcuts (index-based)

Options:
  -h, --help  display help for command

Commands:
  new         Open a new tab (about:blank)
  select      Focus tab by index (1-based)
  close       Close tab by index (1-based); default: first tab


========================================================================
openclaw browser tab new
========================================================================

Usage: openclaw browser tab new [options]

Open a new tab (about:blank)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser tab select
========================================================================

Usage: openclaw browser tab select [options] <index>

Focus tab by index (1-based)

Arguments:
  index       Tab index (1-based)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser tab close
========================================================================

Usage: openclaw browser tab close [options] [index]

Close tab by index (1-based); default: first tab

Arguments:
  index       Tab index (1-based)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser open
========================================================================

Usage: openclaw browser open [options] <url>

Open a URL in a new tab

Arguments:
  url         URL to open

Options:
  -h, --help  display help for command


========================================================================
openclaw browser focus
========================================================================

Usage: openclaw browser focus [options] <targetId>

Focus a tab by target id (or unique prefix)

Arguments:
  targetId    Target id or unique prefix

Options:
  -h, --help  display help for command


========================================================================
openclaw browser close
========================================================================

Usage: openclaw browser close [options] [targetId]

Close a tab (target id optional)

Arguments:
  targetId    Target id or unique prefix (optional)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser profiles
========================================================================

Usage: openclaw browser profiles [options]

List all browser profiles

Options:
  -h, --help  display help for command


========================================================================
openclaw browser create-profile
========================================================================

Usage: openclaw browser create-profile [options]

Create a new browser profile

Options:
  --name <name>      Profile name (lowercase, numbers, hyphens)
  --color <hex>      Profile color (hex format, e.g. #0066CC)
  --cdp-url <url>    CDP URL for remote Chrome (http/https)
  --driver <driver>  Profile driver (openclaw|extension). Default: openclaw
  -h, --help         display help for command


========================================================================
openclaw browser delete-profile
========================================================================

Usage: openclaw browser delete-profile [options]

Delete a browser profile

Options:
  --name <name>  Profile name to delete
  -h, --help     display help for command


========================================================================
openclaw browser extension
========================================================================

Usage: openclaw browser extension [options] [command]

Chrome extension helpers

Options:
  -h, --help  display help for command

Commands:
  install     Install the Chrome extension to a stable local path
  path        Print the path to the installed Chrome extension (load unpacked)
  help        display help for command


========================================================================
openclaw browser extension install
========================================================================

Usage: openclaw browser extension install [options]

Install the Chrome extension to a stable local path

Options:
  -h, --help  display help for command


========================================================================
openclaw browser extension path
========================================================================

Usage: openclaw browser extension path [options]

Print the path to the installed Chrome extension (load unpacked)

Options:
  -h, --help  display help for command


========================================================================
openclaw browser screenshot
========================================================================

Usage: openclaw browser screenshot [options] [targetId]

Capture a screenshot (MEDIA:<path>)

Arguments:
  targetId              CDP target id (or unique prefix)

Options:
  --full-page           Capture full scrollable page (default: false)
  --ref <ref>           ARIA ref from ai snapshot
  --element <selector>  CSS selector for element screenshot
  --type <png|jpeg>     Output type (default: png) (default: "png")
  -h, --help            display help for command


========================================================================
openclaw browser snapshot
========================================================================

Usage: openclaw browser snapshot [options]

Capture a snapshot (default: ai; aria is the accessibility tree)

Options:
  --format <aria|ai>  Snapshot format (default: ai) (default: "ai")
  --target-id <id>    CDP target id (or unique prefix)
  --limit <n>         Max nodes (default: 500/800)
  --mode <efficient>  Snapshot preset (efficient)
  --efficient         Use the efficient snapshot preset (default: false)
  --interactive       Role snapshot: interactive elements only (default: false)
  --compact           Role snapshot: compact output (default: false)
  --depth <n>         Role snapshot: max depth
  --selector <sel>    Role snapshot: scope to CSS selector
  --frame <sel>       Role snapshot: scope to an iframe selector
  --labels            Include viewport label overlay screenshot (default: false)
  --out <path>        Write snapshot to a file
  -h, --help          display help for command


========================================================================
openclaw browser navigate
========================================================================

Usage: openclaw browser navigate [options] <url>

Navigate the current tab to a URL

Arguments:
  url               URL to navigate to

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser resize
========================================================================

Usage: openclaw browser resize [options] <width> <height>

Resize the viewport

Arguments:
  width             Viewport width
  height            Viewport height

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser click
========================================================================

Usage: openclaw browser click [options] <ref>

Click an element by ref from snapshot

Arguments:
  ref                           Ref id from snapshot

Options:
  --target-id <id>              CDP target id (or unique prefix)
  --double                      Double click (default: false)
  --button <left|right|middle>  Mouse button to use
  --modifiers <list>            Comma-separated modifiers (Shift,Alt,Meta)
  -h, --help                    display help for command


========================================================================
openclaw browser type
========================================================================

Usage: openclaw browser type [options] <ref> <text>

Type into an element by ref from snapshot

Arguments:
  ref               Ref id from snapshot
  text              Text to type

Options:
  --submit          Press Enter after typing (default: false)
  --slowly          Type slowly (human-like) (default: false)
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser press
========================================================================

Usage: openclaw browser press [options] <key>

Press a key

Arguments:
  key               Key to press (e.g. Enter)

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser hover
========================================================================

Usage: openclaw browser hover [options] <ref>

Hover an element by ai ref

Arguments:
  ref               Ref id from snapshot

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser scrollintoview
========================================================================

Usage: openclaw browser scrollintoview [options] <ref>

Scroll an element into view by ref from snapshot

Arguments:
  ref                Ref id from snapshot

Options:
  --target-id <id>   CDP target id (or unique prefix)
  --timeout-ms <ms>  How long to wait for scroll (default: 20000)
  -h, --help         display help for command


========================================================================
openclaw browser drag
========================================================================

Usage: openclaw browser drag [options] <startRef> <endRef>

Drag from one ref to another

Arguments:
  startRef          Start ref id
  endRef            End ref id

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser select
========================================================================

Usage: openclaw browser select [options] <ref> <values...>

Select option(s) in a select element

Arguments:
  ref               Ref id from snapshot
  values            Option values to select

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser upload
========================================================================

Usage: openclaw browser upload [options] <paths...>

Arm file upload for the next file chooser

Arguments:
  paths                 File paths to upload

Options:
  --ref <ref>           Ref id from snapshot to click after arming
  --input-ref <ref>     Ref id for <input type=file> to set directly
  --element <selector>  CSS selector for <input type=file>
  --target-id <id>      CDP target id (or unique prefix)
  --timeout-ms <ms>     How long to wait for the next file chooser (default:
                        120000)
  -h, --help            display help for command


========================================================================
openclaw browser waitfordownload
========================================================================

Usage: openclaw browser waitfordownload [options] [path]

Wait for the next download (and save it)

Arguments:
  path               Save path (default: /tmp/openclaw/downloads/...)

Options:
  --target-id <id>   CDP target id (or unique prefix)
  --timeout-ms <ms>  How long to wait for the next download (default: 120000)
  -h, --help         display help for command


========================================================================
openclaw browser download
========================================================================

Usage: openclaw browser download [options] <ref> <path>

Click a ref and save the resulting download

Arguments:
  ref                Ref id from snapshot to click
  path               Save path

Options:
  --target-id <id>   CDP target id (or unique prefix)
  --timeout-ms <ms>  How long to wait for the download to start (default:
                     120000)
  -h, --help         display help for command


========================================================================
openclaw browser dialog
========================================================================

Usage: openclaw browser dialog [options]

Arm the next modal dialog (alert/confirm/prompt)

Options:
  --accept           Accept the dialog (default: false)
  --dismiss          Dismiss the dialog (default: false)
  --prompt <text>    Prompt response text
  --target-id <id>   CDP target id (or unique prefix)
  --timeout-ms <ms>  How long to wait for the next dialog (default: 120000)
  -h, --help         display help for command


========================================================================
openclaw browser fill
========================================================================

Usage: openclaw browser fill [options]

Fill a form with JSON field descriptors

Options:
  --fields <json>       JSON array of field objects
  --fields-file <path>  Read JSON array from a file
  --target-id <id>      CDP target id (or unique prefix)
  -h, --help            display help for command


========================================================================
openclaw browser wait
========================================================================

Usage: openclaw browser wait [options] [selector]

Wait for time, selector, URL, load state, or JS conditions

Arguments:
  selector                                    CSS selector to wait for (visible)

Options:
  --time <ms>                                 Wait for N milliseconds
  --text <value>                              Wait for text to appear
  --text-gone <value>                         Wait for text to disappear
  --url <pattern>                             Wait for URL (supports globs like **/dash)
  --load <load|domcontentloaded|networkidle>  Wait for load state
  --fn <js>                                   Wait for JS condition (passed to waitForFunction)
  --timeout-ms <ms>                           How long to wait for each condition (default: 20000)
  --target-id <id>                            CDP target id (or unique prefix)
  -h, --help                                  display help for command


========================================================================
openclaw browser evaluate
========================================================================

Usage: openclaw browser evaluate [options]

Evaluate a function against the page or a ref

Options:
  --fn <code>       Function source, e.g. (el) => el.textContent
  --ref <id>        Ref from snapshot
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser console
========================================================================

Usage: openclaw browser console [options]

Get recent console messages

Options:
  --level <level>   Filter by level (error, warn, info)
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser pdf
========================================================================

Usage: openclaw browser pdf [options]

Save page as PDF

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser responsebody
========================================================================

Usage: openclaw browser responsebody [options] <url>

Wait for a network response and return its body

Arguments:
  url                URL (exact, substring, or glob like **/api)

Options:
  --target-id <id>   CDP target id (or unique prefix)
  --timeout-ms <ms>  How long to wait for the response (default: 20000)
  --max-chars <n>    Max body chars to return (default: 200000)
  -h, --help         display help for command


========================================================================
openclaw browser highlight
========================================================================

Usage: openclaw browser highlight [options] <ref>

Highlight an element by ref

Arguments:
  ref               Ref id from snapshot

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser errors
========================================================================

Usage: openclaw browser errors [options]

Get recent page errors

Options:
  --clear           Clear stored errors after reading (default: false)
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser requests
========================================================================

Usage: openclaw browser requests [options]

Get recent network requests (best-effort)

Options:
  --filter <text>   Only show URLs that contain this substring
  --clear           Clear stored requests after reading (default: false)
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser trace
========================================================================

Usage: openclaw browser trace [options] [command]

Record a Playwright trace

Options:
  -h, --help  display help for command

Commands:
  start       Start trace recording
  stop        Stop trace recording and write a .zip
  help        display help for command


========================================================================
openclaw browser trace start
========================================================================

Usage: openclaw browser trace start [options]

Start trace recording

Options:
  --target-id <id>  CDP target id (or unique prefix)
  --no-screenshots  Disable screenshots
  --no-snapshots    Disable snapshots
  --sources         Include sources (bigger traces) (default: false)
  -h, --help        display help for command


========================================================================
openclaw browser trace stop
========================================================================

Usage: openclaw browser trace stop [options]

Stop trace recording and write a .zip

Options:
  --out <path>      Output path for the trace zip
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser cookies
========================================================================

Usage: openclaw browser cookies [options] [command]

Read/write cookies

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command

Commands:
  set               Set a cookie (requires --url or domain+path)
  clear             Clear all cookies


========================================================================
openclaw browser cookies set
========================================================================

Usage: openclaw browser cookies set [options] <name> <value>

Set a cookie (requires --url or domain+path)

Arguments:
  name              Cookie name
  value             Cookie value

Options:
  --url <url>       Cookie URL scope (recommended)
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser cookies clear
========================================================================

Usage: openclaw browser cookies clear [options]

Clear all cookies

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser storage
========================================================================

Usage: openclaw browser storage [options] [command]

Read/write localStorage/sessionStorage

Options:
  -h, --help  display help for command

Commands:
  local       localStorage commands
  session     sessionStorage commands
  help        display help for command


========================================================================
openclaw browser storage local
========================================================================

Usage: openclaw browser storage local [options] [command]

localStorage commands

Options:
  -h, --help  display help for command

Commands:
  get         Get localStorage (all keys or one key)
  set         Set a localStorage key
  clear       Clear all localStorage keys
  help        display help for command


========================================================================
openclaw browser storage local get
========================================================================

Usage: openclaw browser storage local get [options] [key]

Get localStorage (all keys or one key)

Arguments:
  key               Key (optional)

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser storage local set
========================================================================

Usage: openclaw browser storage local set [options] <key> <value>

Set a localStorage key

Arguments:
  key               Key
  value             Value

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser storage local clear
========================================================================

Usage: openclaw browser storage local clear [options]

Clear all localStorage keys

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser storage session
========================================================================

Usage: openclaw browser storage session [options] [command]

sessionStorage commands

Options:
  -h, --help  display help for command

Commands:
  get         Get sessionStorage (all keys or one key)
  set         Set a sessionStorage key
  clear       Clear all sessionStorage keys
  help        display help for command


========================================================================
openclaw browser storage session get
========================================================================

Usage: openclaw browser storage session get [options] [key]

Get sessionStorage (all keys or one key)

Arguments:
  key               Key (optional)

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser storage session set
========================================================================

Usage: openclaw browser storage session set [options] <key> <value>

Set a sessionStorage key

Arguments:
  key               Key
  value             Value

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser storage session clear
========================================================================

Usage: openclaw browser storage session clear [options]

Clear all sessionStorage keys

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set
========================================================================

Usage: openclaw browser set [options] [command]

Browser environment settings

Options:
  -h, --help   display help for command

Commands:
  viewport     Set viewport size (alias for resize)
  offline      Toggle offline mode
  headers      Set extra HTTP headers (JSON object)
  credentials  Set HTTP basic auth credentials
  geo          Set geolocation (and grant permission)
  media        Emulate prefers-color-scheme
  timezone     Override timezone (CDP)
  locale       Override locale (CDP)
  device       Apply a Playwright device descriptor (e.g. "iPhone 14")
  help         display help for command


========================================================================
openclaw browser set viewport
========================================================================

Usage: openclaw browser set viewport [options] <width> <height>

Set viewport size (alias for resize)

Arguments:
  width             Viewport width
  height            Viewport height

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set offline
========================================================================

Usage: openclaw browser set offline [options] <on|off>

Toggle offline mode

Arguments:
  on|off            on/off

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set headers
========================================================================

Usage: openclaw browser set headers [options]

Set extra HTTP headers (JSON object)

Options:
  --json <json>     JSON object of headers
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set credentials
========================================================================

Usage: openclaw browser set credentials [options] [username] [password]

Set HTTP basic auth credentials

Arguments:
  username          Username
  password          Password

Options:
  --clear           Clear credentials (default: false)
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set geo
========================================================================

Usage: openclaw browser set geo [options] [latitude] [longitude]

Set geolocation (and grant permission)

Arguments:
  latitude           Latitude
  longitude          Longitude

Options:
  --clear            Clear geolocation + permissions (default: false)
  --accuracy <m>     Accuracy in meters
  --origin <origin>  Origin to grant permissions for
  --target-id <id>   CDP target id (or unique prefix)
  -h, --help         display help for command


========================================================================
openclaw browser set media
========================================================================

Usage: openclaw browser set media [options] <dark|light|none>

Emulate prefers-color-scheme

Arguments:
  dark|light|none   dark/light/none

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set timezone
========================================================================

Usage: openclaw browser set timezone [options] <timezoneId>

Override timezone (CDP)

Arguments:
  timezoneId        Timezone ID (e.g. America/New_York)

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set locale
========================================================================

Usage: openclaw browser set locale [options] <locale>

Override locale (CDP)

Arguments:
  locale            Locale (e.g. en-US)

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command


========================================================================
openclaw browser set device
========================================================================

Usage: openclaw browser set device [options] <name>

Apply a Playwright device descriptor (e.g. "iPhone 14")

Arguments:
  name              Device name (Playwright devices)

Options:
  --target-id <id>  CDP target id (or unique prefix)
  -h, --help        display help for command
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

Run an ACP bridge backed by the Gateway

Options:
  --url <url>              Gateway WebSocket URL (defaults to gateway.remote.url
                           when configured)
  --token <token>          Gateway token (if required)
  --password <password>    Gateway password (if required)
  --session <key>          Default session key (e.g. agent:main:main)
  --session-label <label>  Default session label to resolve
  --require-existing       Fail if the session key/label does not exist
                           (default: false)
  --reset-session          Reset the session key before first use (default:
                           false)
  --no-prefix-cwd          Do not prefix prompts with the working directory
  --verbose, -v            Verbose logging to stderr (default: false)
  -h, --help               display help for command

Commands:
  client                   Run an interactive ACP client against the local ACP
                           bridge

Docs: https://docs.openclaw.ai/cli/acp

Invalid config at C:\Users\18332\.openclaw\openclaw.json:\n- plugins.enabled: Invalid input: expected boolean, received array

========================================================================
openclaw gateway
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Your .env is showing; don't worry, I'll pretend I didn't see it.

Usage: openclaw gateway [options] [command]

Run the WebSocket Gateway

Options:
  --port <port>              Port for the gateway WebSocket
  --bind <mode>              Bind mode
                             ("loopback"|"lan"|"tailnet"|"auto"|"custom").
                             Defaults to config gateway.bind (or loopback).
  --token <token>            Shared token required in connect.params.auth.token
                             (default: OPENCLAW_GATEWAY_TOKEN env if set)
  --auth <mode>              Gateway auth mode ("token"|"password")
  --password <password>      Password for auth mode=password
  --tailscale <mode>         Tailscale exposure mode ("off"|"serve"|"funnel")
  --tailscale-reset-on-exit  Reset Tailscale serve/funnel configuration on
                             shutdown (default: false)
  --allow-unconfigured       Allow gateway start without gateway.mode=local in
                             config (default: false)
  --dev                      Create a dev config + workspace if missing (no
                             BOOTSTRAP.md) (default: false)
  --reset                    Reset dev config + credentials + sessions +
                             workspace (requires --dev) (default: false)
  --force                    Kill any existing listener on the target port
                             before starting (default: false)
  --verbose                  Verbose logging to stdout/stderr (default: false)
  --claude-cli-logs          Only show claude-cli logs in the console (includes
                             stdout/stderr) (default: false)
  --ws-log <style>           WebSocket log style ("auto"|"full"|"compact")
                             (default: "auto")
  --compact                  Alias for "--ws-log compact" (default: false)
  --raw-stream               Log raw model stream events to jsonl (default:
                             false)
  --raw-stream-path <path>   Raw stream jsonl path
  -h, --help                 display help for command

Commands:
  run                        Run the WebSocket Gateway (foreground)
  status                     Show gateway service status + probe the Gateway
  install                    Install the Gateway service
                             (launchd/systemd/schtasks)
  uninstall                  Uninstall the Gateway service
                             (launchd/systemd/schtasks)
  start                      Start the Gateway service
                             (launchd/systemd/schtasks)
  stop                       Stop the Gateway service (launchd/systemd/schtasks)
  restart                    Restart the Gateway service
                             (launchd/systemd/schtasks)
  call                       Call a Gateway method
  usage-cost                 Fetch usage cost summary from session logs
  health                     Fetch Gateway health
  probe                      Show gateway reachability + discovery + health +
                             status summary (local + remote)
  discover                   Discover gateways via Bonjour (local + wide-area if
                             configured)

Docs: https://docs.openclaw.ai/cli/gateway

Invalid config at C:\Users\18332\.openclaw\openclaw.json:\n- plugins.enabled: Invalid input: expected boolean, received array

========================================================================
openclaw daemon
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I'm the assistant your terminal demanded, not the one your sleep schedule requested.

Usage: openclaw daemon [options] [command]

Manage the Gateway service (launchd/systemd/schtasks)

Options:
  -h, --help  display help for command

Commands:
  status      Show service install status + probe the Gateway
  install     Install the Gateway service (launchd/systemd/schtasks)
  uninstall   Uninstall the Gateway service (launchd/systemd/schtasks)
  start       Start the Gateway service (launchd/systemd/schtasks)
  stop        Stop the Gateway service (launchd/systemd/schtasks)
  restart     Restart the Gateway service (launchd/systemd/schtasks)
  help        display help for command

Docs: https://docs.openclaw.ai/cli/gateway


========================================================================
openclaw logs
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — The UNIX philosophy meets your DMs.

Usage: openclaw logs [options]

Tail gateway file logs via RPC

Options:
  --limit <n>      Max lines to return (default: "200")
  --max-bytes <n>  Max bytes to read (default: "250000")
  --follow         Follow log output (default: false)
  --interval <ms>  Polling interval in ms (default: "1000")
  --json           Emit JSON log lines (default: false)
  --plain          Plain text output (no ANSI styling) (default: false)
  --no-color       Disable ANSI colors
  --url <url>      Gateway WebSocket URL (defaults to gateway.remote.url when
                   configured)
  --token <token>  Gateway token (if required)
  --timeout <ms>   Timeout in ms (default: "10000")
  --expect-final   Wait for final response (agent) (default: false)
  -h, --help       display help for command

Docs: https://docs.openclaw.ai/cli/logs


========================================================================
openclaw system
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I keep secrets like a vault... unless you print them in debug logs again.

Usage: openclaw system [options] [command]

System tools (events, heartbeat, presence)

Options:
  -h, --help  display help for command

Commands:
  event       Enqueue a system event and optionally trigger a heartbeat
  heartbeat   Heartbeat controls
  presence    List system presence entries
  help        display help for command

Docs: https://docs.openclaw.ai/cli/system


========================================================================
openclaw models
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — OpenAI-compatible, not OpenAI-dependent.

Usage: openclaw models [options] [command]

Model discovery, scanning, and configuration

Options:
  --status-json    Output JSON (alias for `models status --json`) (default:
                   false)
  --status-plain   Plain output (alias for `models status --plain`) (default:
                   false)
  --agent <id>     Agent id to inspect (overrides
                   OPENCLAW_AGENT_DIR/PI_CODING_AGENT_DIR)
  -h, --help       display help for command

Commands:
  list             List models (configured by default)
  status           Show configured model state
  set              Set the default model
  set-image        Set the image model
  aliases          Manage model aliases
  fallbacks        Manage model fallback list
  image-fallbacks  Manage image model fallback list
  scan             Scan OpenRouter free models for tools + images
  auth             Manage model auth profiles

Docs: https://docs.openclaw.ai/cli/models


========================================================================
openclaw approvals
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Meta wishes they shipped this fast.

Usage: openclaw approvals|exec-approvals [options] [command]

Manage exec approvals (gateway or node host)

Options:
  -h, --help  display help for command

Commands:
  get         Fetch exec approvals snapshot
  set         Replace exec approvals with a JSON file
  allowlist   Edit the per-agent allowlist
  help        display help for command

Docs: https://docs.openclaw.ai/cli/approvals


========================================================================
openclaw nodes
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — IPC, but it's your phone.

Usage: openclaw nodes [options] [command]

Manage gateway-owned node pairing

Options:
  -h, --help  display help for command

Commands:
  status      List known nodes with connection status and capabilities
  describe    Describe a node (capabilities + supported invoke commands)
  list        List pending and paired nodes
  pending     List pending pairing requests
  approve     Approve a pending pairing request
  reject      Reject a pending pairing request
  rename      Rename a paired node (display name override)
  invoke      Invoke a command on a paired node
  run         Run a shell command on a node (mac only)
  notify      Send a local notification on a node (mac only)
  canvas      Capture or render canvas content from a paired node
  camera      Capture camera media from a paired node
  screen      Capture screen recordings from a paired node
  location    Fetch location from a paired node
  help        display help for command

Docs: https://docs.openclaw.ai/cli/nodes


========================================================================
openclaw devices
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I keep secrets like a vault... unless you print them in debug logs again.

Usage: openclaw devices [options] [command]

Device pairing and auth tokens

Options:
  -h, --help  display help for command

Commands:
  list        List pending and paired devices
  approve     Approve a pending device pairing request
  reject      Reject a pending device pairing request
  rotate      Rotate a device token for a role
  revoke      Revoke a device token for a role
  help        display help for command

========================================================================
openclaw node
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I read logs so you can keep pretending you don't have to.

Usage: openclaw node [options] [command]

Run a headless node host (system.run/system.which)

Options:
  -h, --help  display help for command

Commands:
  run         Run the headless node host (foreground)
  status      Show node host status
  install     Install the node host service (launchd/systemd/schtasks)
  uninstall   Uninstall the node host service (launchd/systemd/schtasks)
  stop        Stop the node host service (launchd/systemd/schtasks)
  restart     Restart the node host service (launchd/systemd/schtasks)
  help        display help for command

Docs: https://docs.openclaw.ai/cli/node


========================================================================
openclaw sandbox
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I speak fluent bash, mild sarcasm, and aggressive tab-completion energy.

Usage: openclaw sandbox [options] [command]

Manage sandbox containers (Docker-based agent isolation)

Options:
  -h, --help  display help for command

Commands:
  list        List sandbox containers and their status
  recreate    Remove containers to force recreation with updated config
  explain     Explain effective sandbox/tool policy for a session/agent

Examples:
  openclaw sandbox list
    List all sandbox containers.
  openclaw sandbox list --browser
    List only browser containers.
  openclaw sandbox recreate --all
    Recreate all containers.
  openclaw sandbox recreate --session main
    Recreate a specific session.
  openclaw sandbox recreate --agent mybot
    Recreate agent containers.
  openclaw sandbox explain
    Explain effective sandbox config.


Docs: https://docs.openclaw.ai/cli/sandbox


========================================================================
openclaw tui
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — OpenAI-compatible, not OpenAI-dependent.

Usage: openclaw tui [options]

Open a terminal UI connected to the Gateway

Options:
  --url <url>            Gateway WebSocket URL (defaults to gateway.remote.url
                         when configured)
  --token <token>        Gateway token (if required)
  --password <password>  Gateway password (if required)
  --session <key>        Session key (default: "main", or "global" when scope is
                         global)
  --deliver              Deliver assistant replies (default: false)
  --thinking <level>     Thinking level override
  --message <text>       Send an initial message after connecting
  --timeout-ms <ms>      Agent timeout in ms (defaults to
                         agents.defaults.timeoutSeconds)
  --history-limit <n>    History entries to load (default: "200")
  -h, --help             display help for command

Docs: https://docs.openclaw.ai/cli/tui


========================================================================
openclaw cron
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Your inbox, your infra, your rules.

Usage: openclaw cron [options] [command]

Manage cron jobs (via Gateway)

Options:
  -h, --help  display help for command

Commands:
  status      Show cron scheduler status
  list        List cron jobs
  add         Add a cron job
  rm          Remove a cron job
  enable      Enable a cron job
  disable     Disable a cron job
  runs        Show cron run history (JSONL-backed)
  run         Run a cron job now (debug)
  edit        Edit a cron job (patch fields)
  help        display help for command

Docs: https://docs.openclaw.ai/cli/cron


========================================================================
openclaw dns
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — No $999 stand required.

Usage: openclaw dns [options] [command]

DNS helpers for wide-area discovery (Tailscale + CoreDNS)

Options:
  -h, --help  display help for command

Commands:
  setup       Set up CoreDNS to serve your discovery domain for unicast DNS-SD
              (Wide-Area Bonjour)
  help        display help for command

Docs: https://docs.openclaw.ai/cli/dns


========================================================================
openclaw docs
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I can grep it, git blame it, and gently roast it—pick your coping mechanism.

Usage: openclaw docs [options] [query...]

Search the live OpenClaw docs

Arguments:
  query       Search query

Options:
  -h, --help  display help for command

Docs: https://docs.openclaw.ai/cli/docs


========================================================================
openclaw hooks
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Shell yeah—I'm here to pinch the toil and leave you the glory.

Usage: openclaw hooks [options] [command]

Manage internal agent hooks

Options:
  -h, --help  display help for command

Commands:
  list        List all hooks
  info        Show detailed information about a hook
  check       Check hooks eligibility status
  enable      Enable a hook
  disable     Disable a hook
  install     Install a hook pack (path, archive, or npm spec)
  update      Update installed hooks (npm installs only)

Docs: https://docs.openclaw.ai/cli/hooks


========================================================================
openclaw webhooks
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — The only bot that stays out of your training set.

Usage: openclaw webhooks [options] [command]

Webhook helpers and integrations

Options:
  -h, --help  display help for command

Commands:
  gmail       Gmail Pub/Sub hooks (via gogcli)
  help        display help for command

Docs: https://docs.openclaw.ai/cli/webhooks


========================================================================
openclaw pairing
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I'll do the boring stuff while you dramatically stare at the logs like it's cinema.

Usage: openclaw pairing [options] [command]

Secure DM pairing (approve inbound requests)

Options:
  -h, --help  display help for command

Commands:
  list        List pending pairing requests
  approve     Approve a pairing code and allow that sender
  help        display help for command

Docs: https://docs.openclaw.ai/cli/pairing


========================================================================
openclaw plugins
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — I'm basically a Swiss Army knife, but with more opinions and fewer sharp edges.

Usage: openclaw plugins [options] [command]

Manage OpenClaw plugins/extensions

Options:
  -h, --help  display help for command

Commands:
  list        List discovered plugins
  info        Show plugin details
  enable      Enable a plugin in config
  disable     Disable a plugin in config
  install     Install a plugin (path, archive, or npm spec)
  update      Update installed plugins (npm installs only)
  doctor      Report plugin load issues
  help        display help for command

Docs: https://docs.openclaw.ai/cli/plugins


========================================================================
openclaw channels
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Your terminal just grew claws—type something and let the bot pinch the busywork.

Usage: openclaw channels [options] [command]

Manage chat channel accounts

Options:
  -h, --help    display help for command

Commands:
  list          List configured channels + auth profiles
  status        Show gateway channel status (use status --deep for local)
  capabilities  Show provider capabilities (intents/scopes + supported features)
  resolve       Resolve channel/user names to IDs
  logs          Show recent channel logs from the gateway log file
  add           Add or update a channel account
  remove        Disable or delete a channel account
  login         Link a channel account (if supported)
  logout        Log out of a channel session (if supported)
  help          display help for command

Docs: https://docs.openclaw.ai/cli/channels


========================================================================
openclaw directory
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — The UNIX philosophy meets your DMs.

Usage: openclaw directory [options] [command]

Directory lookups (self, peers, groups) for channels that support it

Options:
  -h, --help  display help for command

Commands:
  self        Show the current account user
  peers       Peer directory (contacts/users)
  groups      Group directory

Docs: https://docs.openclaw.ai/cli/directory


========================================================================
openclaw security
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — The only bot that stays out of your training set.

Usage: openclaw security [options] [command]

Security tools (audit)

Options:
  -h, --help  display help for command

Commands:
  audit       Audit config + local state for common security foot-guns
  help        display help for command

Docs: https://docs.openclaw.ai/cli/security


========================================================================
openclaw skills
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Give me a workspace and I'll give you fewer tabs, fewer toggles, and more oxygen.

Usage: openclaw skills [options] [command]

List and inspect available skills

Options:
  -h, --help  display help for command

Commands:
  list        List all available skills
  info        Show detailed information about a skill
  check       Check which skills are ready vs missing requirements

Docs: https://docs.openclaw.ai/cli/skills


========================================================================
openclaw update
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — One CLI to rule them all, and one more restart because you changed the port.

Usage: openclaw update [options] [command]

Update OpenClaw to the latest version

Options:
  --json                       Output result as JSON (default: false)
  --no-restart                 Skip restarting the gateway service after a
                               successful update
  --channel <stable|beta|dev>  Persist update channel (git + npm)
  --tag <dist-tag|version>     Override npm dist-tag or version for this update
  --timeout <seconds>          Timeout for each update step in seconds (default:
                               1200)
  --yes                        Skip confirmation prompts (non-interactive)
                               (default: false)
  -h, --help                   display help for command

Commands:
  wizard                       Interactive update wizard
  status                       Show update channel and version status

What this does:
  - Git checkouts: fetches, rebases, installs deps, builds, and runs doctor
  - npm installs: updates via detected package manager

Switch channels:
  - Use --channel stable|beta|dev to persist the update channel in config
  - Run openclaw update status to see the active channel and source
  - Use --tag <dist-tag|version> for a one-off npm update without persisting

Non-interactive:
  - Use --yes to accept downgrade prompts
  - Combine with --channel/--tag/--restart/--json/--timeout as needed

Examples:
  openclaw update # Update a source checkout (git)
  openclaw update --channel beta # Switch to beta channel (git + npm)
  openclaw update --channel dev # Switch to dev channel (git + npm)
  openclaw update --tag beta # One-off update to a dist-tag or version
  openclaw update --no-restart # Update without restarting the service
  openclaw update --json # Output result as JSON
  openclaw update --yes # Non-interactive (accept downgrade prompts)
  openclaw update wizard # Interactive update wizard
  openclaw --update # Shorthand for openclaw update

Notes:
  - Switch channels with --channel stable|beta|dev
  - For global installs: auto-updates via detected package manager when possible (see docs/install/updating.md)
  - Downgrades require confirmation (can break configuration)
  - Skips update if the working directory has uncommitted changes

Docs: https://docs.openclaw.ai/cli/update

========================================================================
openclaw completion
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Type the command with confidence—nature will provide the stack trace if needed.

Usage: openclaw completion [options]

Generate shell completion script

Options:
  -s, --shell <shell>  Shell to generate completion for (choices: "zsh", "bash",
                       "powershell", "fish", default: "zsh")
  -i, --install        Install completion script to shell profile
  -y, --yes            Skip confirmation (non-interactive) (default: false)
  -h, --help           display help for command

========================================================================
openclaw help
========================================================================


🦞 OpenClaw 2026.2.1 (bdaf1ee) — Meta wishes they shipped this fast.

Usage: openclaw [options] [command]

Options:
  -V, --version     output the version number
  --dev             Dev profile: isolate state under ~/.openclaw-dev, default
                    gateway port 19001, and shift derived ports (browser/canvas)
  --profile <name>  Use a named profile (isolates
                    OPENCLAW_STATE_DIR/OPENCLAW_CONFIG_PATH under
                    ~/.openclaw-<name>)
  --no-color        Disable ANSI colors
  -h, --help        display help for command

Commands:
  setup             Initialize ~/.openclaw/openclaw.json and the agent workspace
  onboard           Interactive wizard to set up the gateway, workspace, and
                    skills
  configure         Interactive prompt to set up credentials, devices, and agent
                    defaults
  config            Config helpers (get/set/unset). Run without subcommand for
                    the wizard.
  doctor            Health checks + quick fixes for the gateway and channels
  dashboard         Open the Control UI with your current token
  reset             Reset local config/state (keeps the CLI installed)
  uninstall         Uninstall the gateway service + local data (CLI remains)
  message           Send messages and channel actions
  memory            Memory search tools
  agent             Run an agent turn via the Gateway (use --local for embedded)
  agents            Manage isolated agents (workspaces + auth + routing)
  acp               Agent Control Protocol tools
  gateway           Gateway control
  daemon            Gateway service (legacy alias)
  logs              Gateway logs
  system            System events, heartbeat, and presence
  models            Model configuration
  approvals         Exec approvals
  nodes             Node commands
  devices           Device pairing + token management
  node              Node control
  sandbox           Sandbox tools
  tui               Terminal UI
  cron              Cron scheduler
  dns               DNS helpers
  docs              Docs helpers
  hooks             Hooks tooling
  webhooks          Webhook helpers
  pairing           Pairing helpers
  plugins           Plugin management
  channels          Channel management
  directory         Directory commands
  security          Security helpers
  skills            Skills management
  update            CLI update helpers
  completion        Generate shell completion script
  status            Show channel health and recent session recipients
  health            Fetch health from the running gateway
  sessions          List stored conversation sessions
  browser           Manage OpenClaw's dedicated browser (Chrome/Chromium)
  help              display help for command

Examples:
  openclaw channels login --verbose
    Link personal WhatsApp Web and show QR + connection logs.
  openclaw message send --target +15555550123 --message "Hi" --json
    Send via your web session and print JSON result.
  openclaw gateway --port 18789
    Run the WebSocket Gateway locally.
  openclaw --dev gateway
    Run a dev Gateway (isolated state/config) on ws://127.0.0.1:19001.
  openclaw gateway --force
    Kill anything bound to the default gateway port, then start it.
  openclaw gateway ...
    Gateway control via WebSocket.
  openclaw agent --to +15555550123 --message "Run summary" --deliver
    Talk directly to the agent using the Gateway; optionally send the WhatsApp reply.
  openclaw message send --channel telegram --target @mychat --message "Hi"
    Send via your Telegram bot.

Docs: https://docs.openclaw.ai/cli
```

