---
name: playwright-crawler
description: 使用无头 Playwright 进行网页爬取和数据提取。包含绕过反爬虫（Stealth）配置，适用于需要动态渲染、自动化交互或需要特定 User-Agent 伪装的场景。
---

# Playwright Crawler

此技能用于执行自动化网页爬取任务。它预配置了无头模式和基础的反爬虫伪装。

## 核心功能

1. **无头爬取**：默认使用 Chromium 无头模式运行，节省资源。
2. **反爬虫伪装**：
   - 注入脚本抹除 `navigator.webdriver` 标记。
   - 自定义现代浏览器 User-Agent。
   - 自动等待网络空闲（networkidle）。
3. **数据提取**：支持通过 CSS 选择器等待特定元素加载。

## 使用方法

### 基础爬取
调用脚本并传入 URL：
`python3 scripts/crawl.py "https://example.com"`

### 等待特定元素
如果页面是异步加载的，传入 CSS 选择器：
`python3 scripts/crawl.py "https://example.com" ".product-list"`

## 进阶配置
- **Cookies/Session**: 修改 `scripts/crawl.py` 中的 `context` 配置以加载存储的状态。
- **截图**: 在脚本中添加 `await page.screenshot(path="screenshot.png")`。
- **复杂交互**: 可以参考 `references/patterns.md` 中的常用交互代码段（点击、滚动、输入）。
