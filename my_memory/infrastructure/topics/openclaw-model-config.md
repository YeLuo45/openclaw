# 主题：OpenClaw 模型配置

**归档日期**：2026-02-13（按模块从前期聊天整理）

---

## 模型优先级（当前配置）

1. primary: `qwen-portal/coder-model`  
2. fallbacks 顺序：`zai/glm-4.6v-flash` → `zai/glm-4.6v` → `deepseek/deepseek-v3.2-exp` → `zai/glm-4.7-flashx` → `zai/glm-4.7`

## 配置位置

- 文件：`%USERPROFILE%\.openclaw\openclaw.json`（Windows）  
- 节点：`agents.defaults.model.primary`、`agents.defaults.model.fallbacks`（数组）

## 注意

- PowerShell 下用 `openclaw config set agents.defaults.model.fallbacks '[...]' --json` 易因引号/方括号解析报错；推荐直接编辑 JSON，或使用项目内 `scripts/config-fallbacks.json` 内容用变量传入。
- 若配置了 `agents.defaults.models` 白名单，上述模型均需在白名单内。

**关联**：`application/model-priority-2026-02-12.md`、`application/decisions-and-workflows.md` §1。
