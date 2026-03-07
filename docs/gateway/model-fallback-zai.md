# 配置 Z.AI 模型与 Fallback（解决 Unknown model: zai/glm-4.6v-flash）

当 webchat 报错 `Unknown model: zai/glm-4.6v-flash` 或 429 后无可用 fallback 时，可按下面任一方式配置。

## 方式一：在配置中显式添加 Z.AI provider（推荐）

在 `~/.openclaw/openclaw.json`（或 `OPENCLAW_CONFIG_PATH` 指向的文件）中确保存在 `models.providers.zai`，这样 `zai/glm-4.6v-flash` 会被识别：

```json
{
  "models": {
    "providers": {
      "zai": {
        "baseUrl": "https://api.z.ai/api/paas/v4",
        "api": "openai-completions",
        "models": []
      }
    }
  }
}
```

或使用 CLI（在项目根目录或已安装 openclaw 的环境下）：

```powershell
# PowerShell
openclaw config set models.providers.zai '{"baseUrl":"https://api.z.ai/api/paas/v4","api":"openai-completions","models":[]}' --json
```

```bash
# Bash
openclaw config set models.providers.zai '{"baseUrl":"https://api.z.ai/api/paas/v4","api":"openai-completions","models":[]}' --json
```

API 密钥通过环境变量 `ZAI_API_KEY`（或 `Z_AI_API_KEY`）或 auth profile `zai:default` 提供，无需写在 config 里。

## 方式二：添加 Fallback 模型

当主模型 429 或不可用时，可配置备用模型列表，自动降级：

```json
{
  "agents": {
    "defaults": {
      "model": {
        "primary": "zai/glm-4.6v-flash",
        "fallbacks": ["zai/glm-4.7", "openai/gpt-4o-mini"]
      }
    }
  }
}
```

或仅设置 fallbacks（保留现有 primary）：

```powershell
openclaw config set agents.defaults.model.fallbacks '["zai/glm-4.7","openai/gpt-4o-mini"]' --json
```

注意：若已存在 `agents.defaults.model.fallbacks`，上述命令会**覆盖**为新的数组；若要追加，请手动编辑 JSON。

## 代码层面的改动（本仓库已包含）

- **隐式 Z.AI provider**：当存在 `ZAI_API_KEY` 或 zai auth profile 时，自动在写入的 `models.json` 中加入 zai provider（`baseUrl`: https://api.z.ai/api/paas/v4）。
- **resolveModel 回退**：若 config 中未配置某 provider，会从已写入的 `~/.openclaw/agents/.../agent/models.json` 中读取合并后的 providers，因此隐式 zai 也会被识别。
- **Unknown model 降级**：`Unknown model: ...` 会触发模型降级链，尝试 `agents.defaults.model.fallbacks` 中的下一个候选。

修改配置后需**重启 gateway** 才能生效。
