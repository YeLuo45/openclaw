---
summary: "Use Xiaomi MiMo (mimo-v2-flash) with OpenClaw"
read_when:
  - You want Xiaomi MiMo models in OpenClaw
  - You need XIAOMI_API_KEY setup
title: "Xiaomi MiMo"
---

# Xiaomi MiMo

Xiaomi MiMo is the API platform for **MiMo** models. It provides REST APIs compatible with
OpenAI and Anthropic formats and uses API keys for authentication. Create your API key in
the [Xiaomi MiMo console](https://platform.xiaomimimo.com/#/console/api-keys). OpenClaw uses
the `xiaomi` provider with a Xiaomi MiMo API key.

Official docs: [Xiaomi MiMo API Open Platform](https://platform.xiaomimimo.com/#/docs/welcome).

## Model overview

- **mimo-v2-flash**: 262144-token context window, OpenAI Chat Completions compatible (default in OpenClaw).
- **Default base URL** (控制台常规 API 密钥，可与 OpenAI SDK 同源配置): `https://api.xiaomimimo.com/v1`
- **Token Plan**（月度套餐等，密钥与网关与常规 key 不同）: 在 `models.providers.xiaomi` 中把 `baseUrl` 设为套餐对应网关，例如中国区 `https://token-plan-cn.xiaomimimo.com/v1` 或新加坡 `https://token-plan-sgp.xiaomimimo.com/v1`。若使用常规 `sk-` 类密钥却指向 `token-plan-*`，接口会返回 **401 Invalid API Key**。
- Authorization: `Bearer $XIAOMI_API_KEY`

If you need the legacy Anthropic Messages endpoint instead, override `models.providers.xiaomi` with
`baseUrl: "https://api.xiaomimimo.com/anthropic"` and `api: "anthropic-messages"`.

## CLI setup

```bash
openclaw onboard --auth-choice xiaomi-api-key
# or non-interactive
openclaw onboard --auth-choice xiaomi-api-key --xiaomi-api-key "$XIAOMI_API_KEY"
```

## Config snippet

```json5
{
  env: { XIAOMI_API_KEY: "your-key" },
  agents: { defaults: { model: { primary: "xiaomi/mimo-v2-flash" } } },
  models: {
    mode: "merge",
    providers: {
      xiaomi: {
        baseUrl: "https://api.xiaomimimo.com/v1",
        api: "openai-completions",
        apiKey: "XIAOMI_API_KEY",
        models: [
          {
            id: "mimo-v2-flash",
            name: "Xiaomi MiMo V2 Flash",
            reasoning: false,
            input: ["text"],
            cost: { input: 0, output: 0, cacheRead: 0, cacheWrite: 0 },
            contextWindow: 262144,
            maxTokens: 8192,
          },
        ],
      },
    },
  },
}
```

## Notes

- Model ref: `xiaomi/mimo-v2-flash`.
- The provider is injected automatically when `XIAOMI_API_KEY` is set (or an auth profile exists).
- See [/concepts/model-providers](/concepts/model-providers) for provider rules.
