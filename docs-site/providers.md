---
title: 模型提供商
---

# 模型提供商 🔌

OpenClaw 支持多种 AI 模型提供商，通过统一接口连接不同的 AI 服务。

## 支持的提供商

### OpenAI 系列

| 提供商 | 模型 | 说明 |
|--------|------|------|
| OpenAI | GPT-4o, GPT-4-turbo, GPT-3.5-turbo | 官方 API |
| Azure OpenAI | GPT-4, GPT-3.5 | Azure 托管版本 |
| OpenAI 兼容 | Any OpenAI-compatible API | 自建模型或第三方 |

### Anthropic 系列

| 提供商 | 模型 | 说明 |
|--------|------|------|
| Anthropic | Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Haiku | 官方 API |

### Google 系列

| 提供商 | 模型 | 说明 |
|--------|------|------|
| Google AI | Gemini 1.5 Pro, Gemini 1.5 Flash | Google AI Studio |

### 其他提供商

| 提供商 | 说明 |
|--------|------|
| Groq | 高性能推理 |
| Perplexity | 搜索增强模型 |
| OpenRouter | 多模型聚合 |

## 配置

### OpenAI

```json5
{
  providers: {
    openai: {
      apiKey: "sk-...",
      defaultModel: "gpt-4o",
    },
  },
}
```

### Anthropic

```json5
{
  providers: {
    anthropic: {
      apiKey: "sk-ant-...",
      defaultModel: "claude-3-5-sonnet-20241022",
    },
  },
}
```

### Azure OpenAI

```json5
{
  providers: {
    azure: {
      endpoint: "https://YOUR_RESOURCE.openai.azure.com",
      apiKey: "YOUR_API_KEY",
      apiVersion: "2024-02-01",
      defaultModel: "gpt-4o",
    },
  },
}
```

## 默认提供商设置

```json5
{
  providers: {
    default: "openai",
    openai: {
      apiKey: "sk-...",
    },
  },
}
```

## 模型选择建议

- **推荐**：使用最新的强一代模型以获得最佳质量和安全性
- **快速响应**：选择 GPT-3.5-turbo 或 Gemini 1.5 Flash
- **高质量**：选择 GPT-4o 或 Claude 3.5 Sonnet

## 更多信息

- [架构概述](/openclaw/architecture)
- [API 参考](/openclaw/api)
