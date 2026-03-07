---
name: hot-news
description: 通过网页检索查询当天/今日热点新闻，使用 web_search 工具并限定近期时间范围。
metadata: { "openclaw": { "emoji": "📰" } }
---

# 当天热点新闻 (Hot News Today)

使用 OpenClaw 内置的 `web_search` 工具检索**当天或近 24 小时**的热点新闻，并整理成简明摘要回复用户。

## 何时使用（触发场景）

当用户提出以下任一需求时，应使用本 skill：

- 「今天的新闻」「今日热点」「当天热点新闻」「今日头条」
- 「有什么新闻」「最近有什么大事」「今天发生了什么」
- "today's hot news" / "today's top news" / "what's in the news today"
- 用户要求「查一下今天的热点」或「检索当天新闻」

## 操作步骤

1. **调用 web_search**
   - `query`: 根据用户语言选择，例如「今日热点新闻」「今日头条」或 "today's top news"、"breaking news today"。可带地区或领域，如「中国今日热点」「科技今日新闻」。
   - `freshness`: 必须设为 **`pd`**（past 24 hours），只取近 24 小时内内容，保证是「当天」相关新闻。
   - `count`: 建议 5–8 条，便于覆盖多来源又不至于过长。

2. **整理与回复**
   - 从返回的 `results` 中提取标题、来源、链接和简要描述。
   - 按重要性或时间顺序整理成列表，每条包含：标题、来源（siteName 或 URL 域名）、可选一句话摘要、链接。
   - 若用户指定了语言，用该语言回复；未指定时与用户提问语言一致。

3. **可选增强**
   - 若用户关心某领域（科技、财经、体育等），在 query 中加入相应关键词，并保持 `freshness: pd`。
   - 若需多地区视角，可对同一主题用不同 `country` 或不同 query 再搜一次，再合并去重后呈现。

## 示例（web_search 调用）

- 中文：query = "今日热点新闻"，freshness = "pd"，count = 6
- 英文：query = "today's top news", freshness = "pd", count = 6
- 带领域：query = "今日科技热点"，freshness = "pd"

## 依赖

- 需在 OpenClaw 中启用并配置 **web_search**（如 Brave Search API 或 Perplexity）。
- 配置路径：`tools.web.search`，并设置 `apiKey`（如 Brave 的 `BRAVE_API_KEY` 或相应 API Key）。
- 未配置时，应提示用户运行 `openclaw configure --section web` 或查阅 Web 工具文档完成配置。

## 注意

- 务必使用 **freshness: "pd"**，否则结果可能包含多日前的旧闻。
- 结果来自公开网页，请以「据检索结果」等方式表述，避免断言未核实信息。
