# Claude Code Auto Commit

One-command git workflow for [Claude Code](https://docs.anthropic.com/en/docs/claude-code): auto-stage, conventional commit messages, optional semantic versioning, and push.

[中文文档](README.zh-CN.md)

## Features

- **Auto-stage** — `git add -A` all changes automatically
- **Sensitive file detection** — warns before staging `.env`, `*.pem`, `*.key`, credentials, and other secrets
- **Smart commit messages** — analyzes your diff and generates [Conventional Commits](https://www.conventionalcommits.org/) (`feat:`, `fix:`, `refactor:`, etc.)
- **Adapts to your style** — reads recent commit history and matches the language & conventions of your project
- **Respects CLAUDE.md** — if your project defines commit conventions in `CLAUDE.md`, those take priority
- **Semantic versioning** — optional automatic version bumping via `VERSION` file (major/minor/patch)
- **Push in one step** — commits and pushes to origin with helpful error messages on failure (or skip with `--no-push`)
- **Context pre-fetching** — uses Claude Code's `!` backtick syntax to gather git context before execution

## Quick Install

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/atompilot/claude-code-auto-commit/main/install.sh)
```

This installs `auto-commit.md` to `~/.claude/commands/`, making it available globally in Claude Code.

## Other Install Methods

### Clone & Install

```bash
git clone https://github.com/atompilot/claude-code-auto-commit.git
cd claude-code-auto-commit
./install.sh
```

### Manual Copy

```bash
cp commands/auto-commit.md ~/.claude/commands/auto-commit.md
```

## Usage

In Claude Code, type:

```
/auto-commit
```

That's it. Claude will:
1. Check for sensitive files (`.env`, keys, credentials)
2. Stage all changes
3. Analyze the diff
4. Generate a conventional commit message (respecting `CLAUDE.md` conventions if present)
5. Bump the version (if `VERSION` file exists)
6. Commit and push

### Version Bump Control

If your project has a `VERSION` file in the root, the version is bumped automatically based on the commit type. You can also force a specific bump level:

```
/auto-commit --major      # Breaking changes: 1.2.3 → 2.0.0
/auto-commit --minor      # New features:     1.2.3 → 1.3.0
/auto-commit --patch      # Bug fixes:        1.2.3 → 1.2.4
/auto-commit --no-push    # Commit only, do not push
```

No `VERSION` file? No problem — versioning is skipped entirely. Flags can be combined: `/auto-commit --minor --no-push`.

### Commit Types

| Type       | Description                         | Version Bump |
|------------|-------------------------------------|--------------|
| `feat`     | New feature or capability           | minor        |
| `fix`      | Bug fix                             | patch        |
| `refactor` | Code restructuring                  | patch        |
| `docs`     | Documentation only                  | patch        |
| `style`    | Formatting, whitespace              | patch        |
| `test`     | Adding or updating tests            | patch        |
| `chore`    | Build, CI, dependencies             | patch        |
| `perf`     | Performance improvement             | patch        |

## Uninstall

```bash
rm ~/.claude/commands/auto-commit.md
```

Or use the uninstall script:

```bash
./uninstall.sh
```

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## License

[MIT](LICENSE)
