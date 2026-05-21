---
title: API 参考
---

# API 参考 📡

OpenClaw 提供完整的 REST API 和 WebSocket 接口。

## REST API

### 基础信息

- **基础URL**: `http://127.0.0.1:18789`
- **认证**: 通过配置中的令牌进行认证

### 端点

#### 健康检查

```
GET /health
```

响应：
```json
{
  "status": "ok",
  "version": "1.0.0",
  "uptime": 3600
}
```

#### 发送消息

```
POST /api/chat
```

请求：
```json
{
  "channel": "telegram",
  "sender": "123456789",
  "message": "你好，帮我写一段代码"
}
```

响应：
```json
{
  "success": true,
  "messageId": "msg_123456",
  "response": "好的，我来帮你..."
}
```

#### 获取会话

```
GET /api/sessions/{sessionId}
```

响应：
```json
{
  "sessionId": "user_123456",
  "messages": [...],
  "createdAt": "2024-01-01T00:00:00Z"
}
```

#### 重置会话

```
POST /api/sessions/{sessionId}/reset
```

响应：
```json
{
  "success": true
}
```

#### 网关状态

```
GET /api/gateway/status
```

响应：
```json
{
  "status": "running",
  "channels": {
    "telegram": "connected",
    "discord": "connected"
  },
  "memory": {
    "used": "2GB",
    "total": "8GB"
  }
}
```

## WebSocket API

### 连接

```
ws://127.0.0.1:18789/ws
```

### 消息格式

```json
{
  "type": "message",
  "channel": "telegram",
  "sender": "123456789",
  "content": "你好"
}
```

### 响应格式

```json
{
  "type": "response",
  "messageId": "msg_123456",
  "content": "你好！有什么可以帮助你的吗？"
}
```

## SSE (Server-Sent Events)

### 订阅事件

```
GET /api/events?channels=telegram,discord
```

### 事件类型

| 事件 | 说明 |
|------|------|
| message | 新消息 |
| response | AI 响应 |
| error | 错误 |
| status | 状态更新 |

## 错误代码

| 代码 | 说明 |
|------|------|
| 400 | 请求格式错误 |
| 401 | 未授权 |
| 403 | 禁止访问 |
| 404 | 未找到 |
| 500 | 服务器错误 |

## Python SDK

```python
from openclaw import OpenClaw

client = OpenClaw(api_key="your-api-key")

# 发送消息
response = client.chat("你好，帮我写一段代码")
print(response)
```

## JavaScript SDK

```javascript
import { OpenClaw } from "openclaw";

const client = new OpenClaw({ apiKey: "your-api-key" });

// 发送消息
const response = await client.chat("你好，帮我写一段代码");
console.log(response);
```

## 更多信息

- [架构概述](/openclaw/architecture)
- [工具系统](/openclaw/tools)
