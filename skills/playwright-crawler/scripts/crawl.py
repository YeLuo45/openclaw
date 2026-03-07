import sys
import asyncio
from playwright.async_api import async_playwright
import json

async def run(url, wait_for_selector=None, output_file="output.json"):
    async with async_playwright() as p:
        # 使用 stealth 策略绕过检测
        browser = await p.chromium.launch(headless=True)
        context = await browser.new_context(
            user_agent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36",
            viewport={"width": 1280, "height": 800}
        )
        
        # 注入 stealth 脚本 (简单版)
        await context.add_init_script("""
            Object.defineProperty(navigator, 'webdriver', { get: () => undefined });
        """)
        
        page = await context.new_page()
        
        try:
            print(f"Navigating to {url}...")
            await page.goto(url, wait_until="networkidle")
            
            if wait_for_selector:
                await page.wait_for_selector(wait_for_selector, timeout=10000)
            
            # 获取页面内容
            content = await page.content()
            title = await page.title()

            # 截屏功能
            screenshot_path = "screenshot.png"
            await page.screenshot(path=screenshot_path, full_page=True)
            print(f"Screenshot saved to {screenshot_path}")
            
            # 专门提取 Hacker News 标题
            hn_titles = []
            title_elements = await page.query_selector_all(".titleline > a")
            for el in title_elements:
                hn_titles.append(await el.inner_text())

            result = {
                "url": url,
                "title": title,
                "status": "success",
                "titles": hn_titles
            }
            
            with open(output_file, "w", encoding="utf-8") as f:
                json.dump(result, f, ensure_ascii=False, indent=2)
            
            print(f"Successfully scraped {url}. Data saved to {output_file}")
            
        except Exception as e:
            print(f"Error: {str(e)}")
        finally:
            await browser.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 crawl.py <url> [selector]")
        sys.exit(1)
    
    target_url = sys.argv[1]
    selector = sys.argv[2] if len(sys.argv) > 2 else None
    
    asyncio.run(run(target_url, selector))
