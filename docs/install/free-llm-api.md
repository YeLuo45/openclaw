---
summary: "Free LLM API 配置：基于 free-llm-api-resources 的 OpenClaw 大模型与 API Key 配置"
read_when:
  - 使用免费 API 运行 OpenClaw 大模型
  - 配置 OpenRouter / Groq / Google AI Studio 等
title: "Free LLM API 配置"
---

# Free LLM API 配置

本文基于 [free-llm-api-resources](https://github.com/cheahjs/free-llm-api-resources) 整理可在 OpenClaw 中使用的**免费或试用额度**大模型 API，以及对应的 API Key 获取方式与配置方法。

## 推荐：OpenRouter（一个 Key 多模型）

- **限制**：约 20 次/分钟、50 次/天（免费）；充值 $10 可提升至约 1000 次/天。
- **获取 Key**：https://openrouter.ai → 注册并创建 API Key。
- **OpenClaw 环境变量**：`OPENROUTER_API_KEY`
- **模型格式**：`openrouter/<provider>/<model>`，免费模型通常带 `:free` 后缀。

### 常用免费模型示例

| OpenClaw 模型引用 | 说明 |
|-------------------|------|
| `openrouter/meta-llama/llama-3.3-70b:free` | Llama 3.3 70B |
| `openrouter/google/gemma-3n-e2b-it:free` | Gemma 3 2B |
| `openrouter/google/gemma-3n-e4b-it:free` | Gemma 3 4B |
| `openrouter/qwen/qwen3-4b:free` | Qwen3 4B |
| `openrouter/moonshotai/kimi-k2:free` | Kimi K2 |
| `openrouter/deepseek/deepseek-r1-0528:free` | DeepSeek R1 |
| `openrouter/auto` | 自动选模型（需有余额或免费额度） |

更多免费模型见：https://openrouter.ai/docs#models

---

## 其他免费/试用提供商

### Groq

- **限制**：如 Llama 3.3 70B 约 1000 次/天、12000 tokens/分钟。
- **获取 Key**：https://console.groq.com
- **OpenClaw 环境变量**：`GROQ_API_KEY`
- **示例模型**：`groq/llama-3.3-70b`、`groq/llama-3.1-8b`

### Google AI Studio（Gemini）

- **限制**：如 Gemini 2.5 Flash 约 20 次/天、5 次/分钟等（以控制台为准）。
- **获取 Key**：https://aistudio.google.com
- **OpenClaw 环境变量**：`GEMINI_API_KEY`
- **示例模型**：`google/gemini-2.5-flash`、`google/gemini-2.5-flash-lite`

### Cerebras

- **限制**：约 40 次/分钟。
- **获取 Key**：https://cloud.cerebras.ai
- **OpenClaw 环境变量**：`CEREBRAS_API_KEY`
- **Base URL**：`https://api.cerebras.ai/v1`（OpenClaw 内置）

### Cohere

- **限制**：约 20 次/分钟、1000 次/月。
- **获取 Key**：https://dashboard.cohere.com
- **OpenClaw**：需通过 `models.providers` 配置 OpenAI 兼容 base URL 使用。

---

## 在 OpenClaw 中配置

### 方式一：环境变量（推荐）

在 **运行 Gateway 的环境** 中设置（如 `~/.openclaw/.env` 或系统环境变量）：

```bash
# OpenRouter（推荐，一个 Key 用多款免费模型）
OPENROUTER_API_KEY=sk-or-v1-xxxxxxxx

# 可选：Groq
GROQ_API_KEY=gsk_xxxxxxxx

# 可选：Google AI Studio
GEMINI_API_KEY=xxxxxxxx
```

使用 systemd/launchd 时，可在对应 service 的 `Environment=` 或 `EnvironmentFile=` 中配置，或保持从 `~/.openclaw/.env` 加载。

### 方式二：通过 config 写入 env.vars

不把 Key 放在 `.env` 时，可用配置注入（注意不要将含 Key 的配置文件提交到仓库）：

```bash
openclaw config set env.vars.OPENROUTER_API_KEY "sk-or-v1-你的Key"
```

（Key 会写入 `~/.openclaw/openclaw.json` 的 `env.vars`，Gateway 启动时会注入为环境变量。）

### 方式三：仅设置默认模型（Key 仍用环境变量）

若已设置 `OPENROUTER_API_KEY`，只需把默认模型改为 OpenRouter 免费模型：

```bash
# 默认使用 OpenRouter 免费 Llama 3.3 70B
openclaw config set agents.defaults.model.primary "openrouter/meta-llama/llama-3.3-70b:free"
```

如需同时写入 auth profile（供 Gateway 读 Key），可用：

```bash
openclaw onboard --auth-choice apiKey --token-provider openrouter --token "sk-or-v1-你的Key"
```

（会设置 `openrouter:default` profile 并将默认模型设为 `openrouter/auto`；之后可用上面命令把 primary 改为 `openrouter/meta-llama/llama-3.3-70b:free`。）

---

## 完整示例：仅用 OpenRouter 免费模型

1. 在 https://openrouter.ai 注册并创建 API Key。
2. 设置环境变量或 config：

```bash
# 二选一：环境变量
export OPENROUTER_API_KEY=sk-or-v1-你的Key

# 或 config（Key 会写入 openclaw.json）
openclaw config set env.vars.OPENROUTER_API_KEY "sk-or-v1-你的Key"
```

3. 设置默认模型为免费模型：

```bash
openclaw config set agents.defaults.model.primary "openrouter/meta-llama/llama-3.3-70b:free"
```

4. 重启 Gateway 使配置生效。

如需在对话中切换模型，可使用 `/model` 或 `/model openrouter/meta-llama/llama-3.3-70b:free`。

---

## 参考

- 免费/试用 API 列表与限制详情：[free-llm-api-resources](https://github.com/cheahjs/free-llm-api-resources)
- OpenClaw 模型与提供商：[Model Providers](/concepts/model-providers)、[OpenRouter](/providers/openrouter)
- 环境变量与 config：[Environment](/environment)、[Configuration](/gateway/configuration)
