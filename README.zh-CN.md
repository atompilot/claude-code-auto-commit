# Claude Code Auto Commit

为 [Claude Code](https://docs.anthropic.com/en/docs/claude-code) 设计的一键 git 工作流：自动暂存、生成规范化 commit 消息、可选语义化版本管理、自动推送。

[English](README.md)

## 特性

- **自动暂存** — 自动执行 `git add -A` 暂存所有变更
- **智能 commit 消息** — 分析 diff 内容，生成 [Conventional Commits](https://www.conventionalcommits.org/) 格式的提交信息（`feat:`、`fix:`、`refactor:` 等）
- **适配项目风格** — 读取最近的 commit 历史，自动匹配项目的语言和提交规范
- **语义化版本管理** — 通过 `VERSION` 文件自动管理版本号（major/minor/patch），可选功能
- **一步推送** — 提交后自动 push 到 origin，失败时给出友好的错误提示
- **上下文预获取** — 使用 Claude Code 的 `!` 反引号语法在执行前收集 git 上下文

## 快速安装

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/atompilot/claude-code-auto-commit/main/install.sh)
```

这会将 `auto-commit.md` 安装到 `~/.claude/commands/`，使其在 Claude Code 中全局可用。

## 其他安装方式

### 克隆安装

```bash
git clone https://github.com/atompilot/claude-code-auto-commit.git
cd claude-code-auto-commit
./install.sh
```

### 手动复制

```bash
cp commands/auto-commit.md ~/.claude/commands/auto-commit.md
```

## 使用方法

在 Claude Code 中输入：

```
/auto-commit
```

就这样。Claude 会自动：
1. 暂存所有变更
2. 分析 diff 内容
3. 生成规范化 commit 消息
4. 更新版本号（如果存在 `VERSION` 文件）
5. 提交并推送

### 版本号控制

如果项目根目录有 `VERSION` 文件，版本号会根据 commit 类型自动递增。也可以强制指定递增级别：

```
/auto-commit --major    # 破坏性变更: 1.2.3 → 2.0.0
/auto-commit --minor    # 新功能:     1.2.3 → 1.3.0
/auto-commit --patch    # Bug 修复:   1.2.3 → 1.2.4
```

没有 `VERSION` 文件？没关系 — 版本管理步骤会被完全跳过。

### Commit 类型

| 类型       | 说明                 | 版本递增 |
|------------|---------------------|---------|
| `feat`     | 新功能              | minor   |
| `fix`      | Bug 修复            | patch   |
| `refactor` | 代码重构            | patch   |
| `docs`     | 仅文档变更          | patch   |
| `style`    | 格式调整、空格等     | patch   |
| `test`     | 添加或更新测试       | patch   |
| `chore`    | 构建、CI、依赖管理   | patch   |
| `perf`     | 性能优化            | patch   |

## 卸载

```bash
rm ~/.claude/commands/auto-commit.md
```

或使用卸载脚本：

```bash
./uninstall.sh
```

## 贡献

欢迎贡献！请提交 issue 或 pull request。

## 许可证

[MIT](LICENSE)
