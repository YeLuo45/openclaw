# OpenClaw Skill 安装记录：2026-02-12

**日期**：2026-02-12  
**来源**：ClawHub (https://clawhub.ai)  
**工具**：clawhub CLI v1.x

---

## 已安装 Skill

### 1. web-scraper (v1.0.1)

- **来源**：`clawhub install web-scraper`
- **位置**：`skills/web-scraper/`
- **说明**：可配置的网页抓取服务，从任意网站提取结构化数据。
- **用途**：
  - 电商：商品信息、价格、库存、评论
  - 不动产：房源列表、价格、面积
  - 招聘：职位、薪资、公司
  - SNS/媒体：帖子、评论、粉丝数
- **技术栈**：支持 Puppeteer（浏览器渲染）、Cheerio（静态 HTML）
- **触发方式**：`auto_trigger: false`（需手动请求，如「从 [URL] 抓取商品信息」）
- **输出格式**：CSV、JSON、Excel

---

## 未安装 Skill（被标记为可疑）

### wechat-search (v1.0.3)

- **状态**：VirusTotal Code Insight 标记为可疑（可能含加密密钥、外部 API、eval 等风险模式）
- **来源**：`clawhub install wechat-search`（需 `--force` 强制安装）
- **说明**：微信搜索相关功能
- **建议**：在非交互模式下需用 `clawhub install wechat-search --force`；安装前建议先查看源码确认安全性。

### wechat-article-search (v0.0.1)

- **状态**：同样被标记为可疑
- **说明**：微信文章搜索

---

## 安装步骤（记录）

1. **安装 clawhub CLI**  
   ```powershell
   npm install -g clawhub
   ```

2. **搜索 skill**  
   ```powershell
   clawhub search "web scraper"
   clawhub search "wechat"
   ```

3. **安装 skill**  
   ```powershell
   clawhub install web-scraper
   # 成功安装到 skills/web-scraper/
   ```

4. **查看已安装 skill**  
   ```powershell
   clawhub list
   # 输出：web-scraper  1.0.1
   ```

---

## 使用说明

- **重启 OpenClaw**：安装 skill 后需重启 OpenClaw gateway 或应用，新 skill 才会被加载。
- **Skill 位置**：默认安装在项目下的 `skills/` 目录（即 `<workspace>/skills`）。
- **更新 skill**：`clawhub update --all` 或 `clawhub update <skill-name>`
- **卸载 skill**：直接删除 `skills/<skill-name>/` 目录，或用 `clawhub uninstall <skill-name>`（若 CLI 支持）

---

## 关于可疑 Skill 的说明

ClawHub 通过 VirusTotal Code Insight 对 skill 进行安全扫描。被标记的 skill 可能包含：
- 硬编码的 API 密钥或密码
- 调用外部 API
- 使用 `eval` 或动态代码执行
- 其它风险模式

**建议**：
- 安装前先在 https://clawhub.ai/skills/<skill-slug> 查看源码
- 确认无安全隐患后再用 `--force` 安装
- 或寻找其它替代 skill

---

## 参考

- ClawHub 官方文档：https://docs.openclaw.ai/tools/clawhub
- ClawHub 网站：https://clawhub.ai
- OpenClaw Skill 系统：https://docs.openclaw.ai/tools/skills
