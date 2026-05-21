---
title: 工具系统
---

# 工具系统 🛠️

OpenClaw 内置强大的工具系统，让 AI Agent 能够执行各种操作。

## 内置工具

### 文件系统工具

| 工具 | 说明 |
|------|------|
| read_file | 读取文件内容 |
| write_file | 写入文件内容 |
| list_directory | 列出目录内容 |
| create_directory | 创建目录 |

### 系统工具

| 工具 | 说明 |
|------|------|
| shell | 执行 Shell 命令 |
| process | 管理进程 |

### 网络工具

| 工具 | 说明 |
|------|------|
| web_fetch | 获取网页内容 |
| web_search | 搜索网络 |

### 开发工具

| 工具 | 说明 |
|------|------|
| code_execute | 执行代码 |
| mcp | 调用 MCP 服务器 |

### 计划任务

| 工具 | 说明 |
|------|------|
| cron | 设置定时任务 |
| schedule | 调度任务 |

## 工具调用示例

### 读取文件

```
工具: read_file
参数: {"path": "/path/to/file.txt"}
```

### 执行 Shell 命令

```
工具: shell
参数: {"command": "ls -la", "timeout": 30}
```

### 网络搜索

```
工具: web_search
参数: {"query": "OpenClaw AI gateway", "limit": 5}
```

## 工具配置

在 `~/.openclaw/openclaw.json` 中配置工具：

```json5
{
  tools: {
    enabled: true,
    shell: {
      enabled: true,
      timeout: 60,
    },
    webFetch: {
      enabled: true,
      userAgent: "OpenClaw/1.0",
    },
  },
}
```

## MCP 集成

OpenClaw 支持 MCP (Model Context Protocol)，可以连接外部工具服务器：

```json5
{
  mcpServers: {
    filesystem: {
      command: "npx",
      args: ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/dir"],
    },
  },
}
```

## 安全考虑

- 工具执行在沙箱环境中
- Shell 命令有超时限制
- 敏感操作需要确认

## 更多信息

- [架构概述](/openclaw/architecture)
- [API 参考](/openclaw/api)
