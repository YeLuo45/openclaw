---
name: openclaw-update-checker
description: OpenClaw 更新检测器 - 每周检测 GitHub 仓库更新，提供更新命令和变更摘要
metadata: { "openclaw": { "emoji": "🔄" } }
---

# OpenClaw 更新检测器 (Update Checker)

自动检测 [OpenClaw GitHub 仓库](https://github.com/openclaw/openclaw) 的更新，每周执行一次检查，并提供手动更新命令。

## 配置

- **配置文件**：`.cursor/skills/openclaw-update-checker/config.json`
- **检查间隔**：默认 7 天（可配置 `checkIntervalDays`）
- **远程仓库**：`https://github.com/openclaw/openclaw.git`

### 配置示例

```json
{
  "checkIntervalDays": 7,
  "lastCheckDate": "2026-03-01",
  "lastCommitSha": "abc123...",
  "autoNotify": true
}
```

---

## 更新命令

用户说出以下意图时，按对应方式执行。

### 1. 检查更新

| 用户说法示例 | 行为 |
|--------------|------|
| 「检查 openclaw 更新」「openclaw 有更新吗」「检测更新」 | 执行 `git fetch origin main`，对比本地与远程 commit，报告是否有新提交及变更摘要。 |
| 「最近有什么更新」「看看 openclaw 更新了什么」 | 执行 `git log` 查看远程最新提交，展示最近 5-10 条 commit 的标题和作者。 |

### 2. 执行更新

| 用户说法示例 | 行为 |
|--------------|------|
| 「更新 openclaw」「拉取最新代码」「同步代码」 | 执行 `git pull origin main --rebase`，拉取最新代码并合并到本地。 |
| 「重置到最新版本」「强制更新」 | 警告用户本地修改将丢失，确认后执行 `git fetch origin main && git reset --hard origin/main`。 |

### 3. 查看更新历史

| 用户说法示例 | 行为 |
|--------------|------|
| 「查看更新历史」「最近的提交」「changelog」 | 展示最近 10 条 commit 或读取 CHANGELOG.md 的最新内容。 |
| 「上次更新是什么时候」「上次检查时间」 | 读取 config.json 中的 `lastCheckDate` 并报告。 |

### 4. 配置检查间隔

| 用户说法示例 | 行为 |
|--------------|------|
| 「设置每 X 天检查一次」「更新间隔改为 X 天」 | 更新 config.json 中的 `checkIntervalDays` 为指定值。 |
| 「关闭自动检查」「不要自动提醒更新」 | 设置 `autoNotify: false`。 |

---

## 自动检查触发（每周一次）

Agent 在以下情况下**主动检查更新**：

1. **会话开始时**：读取 config.json，如果距离 `lastCheckDate` 超过 `checkIntervalDays`（默认 7 天），自动执行更新检查。
2. **检查后更新配置**：将 `lastCheckDate` 更新为当天日期，记录 `lastCommitSha`。
3. **有更新时通知**：如果检测到新提交，简要报告更新数量和主要变更，询问是否立即更新。

### 自动检查流程

```
1. 读取 .cursor/skills/openclaw-update-checker/config.json
2. 计算距离上次检查的天数
3. 如果 >= checkIntervalDays：
   a. 执行 git fetch origin main
   b. 对比 HEAD 与 origin/main
   c. 如有差异，报告更新内容
   d. 更新 lastCheckDate 和 lastCommitSha
4. 如果 < checkIntervalDays：跳过，不打扰用户
```

---

## 操作步骤

### 检查更新

1. 确保 Git 远程已配置：`git remote -v` 应包含 `origin https://github.com/openclaw/openclaw.git`
2. 获取远程更新：`git fetch origin main`
3. 查看本地与远程差异：`git log HEAD..origin/main --oneline`
4. 如有差异，展示变更摘要

### 执行更新

1. 检查本地是否有未提交的修改：`git status`
2. 如有修改，建议先 stash 或提交
3. 拉取更新：`git pull origin main --rebase`
4. 如有冲突，报告并指导解决

### 查看变更详情

1. 查看最近提交：`git log origin/main -10 --oneline`
2. 查看特定文件变更：`git diff HEAD..origin/main -- <file>`
3. 读取 CHANGELOG.md 了解版本更新说明

---

## Git 命令参考（PowerShell）

```powershell
# 检查远程配置
git remote -v

# 添加远程仓库（如未配置）
git remote add origin https://github.com/openclaw/openclaw.git

# 获取最新更新（不合并）
git fetch origin main

# 查看本地落后多少提交
git rev-list --count HEAD..origin/main

# 查看远程最新提交
git log origin/main -5 --oneline

# 拉取并合并更新
git pull origin main --rebase

# 强制重置到远程版本（警告：丢失本地修改）
git fetch origin main
git reset --hard origin/main
```

---

## 依赖与约束

- **Git**：需要安装 Git 并可在 PowerShell 中执行
- **网络**：需要能访问 GitHub（如有代理，确保 Git 配置了代理）
- **权限**：只读检查无需特殊权限；写入（pull/reset）需要仓库写权限

### 网络问题排查

如果 `git fetch` 超时或失败：

1. 检查网络连接
2. 检查代理设置：`git config --global http.proxy`
3. 尝试使用 SSH：`git remote set-url origin git@github.com:openclaw/openclaw.git`
4. 使用镜像加速（如适用）

---

## 示例对话

**用户**：检查 openclaw 有没有更新

**Agent**：
1. 执行 `git fetch origin main`
2. 执行 `git rev-list --count HEAD..origin/main`
3. 报告：「OpenClaw 有 15 个新提交。主要更新包括：
   - feat: 添加新的语音唤醒功能
   - fix: 修复 WhatsApp 连接问题
   - docs: 更新配置文档
   是否立即更新？」

---

**用户**：更新 openclaw

**Agent**：
1. 检查 `git status` 确认无未提交修改
2. 执行 `git pull origin main --rebase`
3. 报告：「更新完成！已拉取 15 个新提交。建议运行 `pnpm install` 更新依赖。」

---

## 注意事项

- 更新前建议备份本地修改
- 如有本地自定义配置，注意 .gitignore 中的文件不会被覆盖
- 大版本更新后可能需要重新运行 `pnpm install` 和 `pnpm build`
- 检查 CHANGELOG.md 了解破坏性变更（Breaking Changes）
