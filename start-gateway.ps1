# OpenClaw Gateway 启动脚本

# 设置环境变量
$env:NODE_TLS_REJECT_UNAUTHORIZED = "0"  # 临时禁用 SSL 验证（仅用于测试）
$env:GEMINI_API_KEY = "AIzaSyDpjVyIz93sw4MRFVy08LEdy8RooAmw8_c"

# 如果你有 HTTP 代理，取消下面两行的注释并填写代理地址
# $env:HTTP_PROXY = "http://127.0.0.1:7890"
# $env:HTTPS_PROXY = "http://127.0.0.1:7890"

Write-Host "正在启动 OpenClaw Gateway..." -ForegroundColor Green
Write-Host "使用模型: qwen-portal/coder-model" -ForegroundColor Cyan
Write-Host ""

# 启动 gateway
node scripts/run-node.mjs gateway run --bind loopback --port 18789
