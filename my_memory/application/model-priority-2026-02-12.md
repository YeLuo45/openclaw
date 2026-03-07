# OpenClaw 模型优先级配置

**日期**：2026-02-12  
**说明**：Agent 默认模型优先顺序（primary + fallbacks）。

## 顺序

1. **primary**：`qwen-portal/coder-model`
2. **fallbacks**（按顺序）：
   - `zai/glm-4.6v-flash`
   - `zai/glm-4.6v`
   - `deepseek/deepseek-v3.2-exp`
   - `zai/glm-4.7-flashx`
   - `zai/glm-4.7`

## 配置方式

配置文件：`~/.openclaw/openclaw.json`（Windows：`%USERPROFILE%\.openclaw\openclaw.json`，即 `C:\Users\14663\.openclaw\openclaw.json`）。

### 方式一（推荐）：直接编辑配置文件

在 `openclaw.json` 的 `agents.defaults` 下确保 `model` 字段为：

```json
"model": {
  "primary": "qwen-portal/coder-model",
  "fallbacks": [
    "zai/glm-4.6v-flash",
    "zai/glm-4.6v",
    "deepseek/deepseek-v3.2-exp",
    "zai/glm-4.7-flashx",
    "zai/glm-4.7"
  ]
}
```

改完保存，**重启 gateway**（或重启 OpenClaw 应用）配置生效。

### 方式二：CLI 命令（PowerShell，可选）

若只想用命令行设置（注意：PowerShell 变量传递可能有换行/空格问题，若报错请改用方式一）：

```powershell
openclaw config set agents.defaults.model.primary "qwen-portal/coder-model"
$fallbacks = Get-Content .\scripts\config-fallbacks.json -Raw
openclaw config set agents.defaults.model.fallbacks $fallbacks --json
```

若用项目内 pnpm 或 run-node.mjs 运行，将 `openclaw` 改为 `pnpm openclaw` 或 `node .\scripts\run-node.mjs`。

若启用了 `agents.defaults.models` 白名单，需将上述所有模型加入白名单，否则会无法选用。修改后需**重启 gateway** 生效。
