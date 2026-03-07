# Playwright 常用交互模式

## 1. 无限滚动加载
```python
async def scroll_to_bottom(page):
    await page.evaluate("""
        async () => {
            await new Promise((resolve) => {
                let totalHeight = 0;
                let distance = 100;
                let timer = setInterval(() => {
                    let scrollHeight = document.body.scrollHeight;
                    window.scrollBy(0, distance);
                    totalHeight += distance;
                    if(totalHeight >= scrollHeight){
                        clearInterval(timer);
                        resolve();
                    }
                }, 100);
            });
        }
    """)
```

## 2. 处理弹窗/点击
```python
# 等待并点击
await page.click("button#login-submit")

# 处理 Dialog
page.on("dialog", lambda dialog: dialog.accept())
```

## 3. 提取列表数据
```python
items = await page.query_selector_all(".item-class")
data = []
for item in items:
    text = await item.inner_text()
    data.append(text)
```
