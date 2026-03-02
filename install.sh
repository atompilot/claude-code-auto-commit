#!/usr/bin/env bash
set -euo pipefail

COMMAND_NAME="auto-commit.md"
TARGET_DIR="$HOME/.claude/commands"
REPO_URL="https://raw.githubusercontent.com/atompilot/claude-code-auto-commit/main/commands/auto-commit.md"

echo "=== Claude Code Auto Commit - Installer ==="
echo ""

# Create target directory if needed
mkdir -p "$TARGET_DIR"

# Determine source: local file (cloned repo) or remote download
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
LOCAL_SOURCE="$SCRIPT_DIR/commands/$COMMAND_NAME"

if [ -f "$LOCAL_SOURCE" ]; then
  SOURCE="local"
  echo "Installing from local repository..."
else
  SOURCE="remote"
  echo "Downloading from GitHub..."
fi

# Backup existing file if present
if [ -f "$TARGET_DIR/$COMMAND_NAME" ]; then
  BACKUP="$TARGET_DIR/${COMMAND_NAME}.bak"
  cp "$TARGET_DIR/$COMMAND_NAME" "$BACKUP"
  echo "Existing command backed up to: $BACKUP"
fi

# Install
if [ "$SOURCE" = "local" ]; then
  cp "$LOCAL_SOURCE" "$TARGET_DIR/$COMMAND_NAME"
else
  curl -fsSL "$REPO_URL" -o "$TARGET_DIR/$COMMAND_NAME"
fi

# Show installed version
if [ "$SOURCE" = "local" ] && [ -f "$SCRIPT_DIR/VERSION" ]; then
  INSTALLED_VERSION="$(cat "$SCRIPT_DIR/VERSION")"
elif [ "$SOURCE" = "remote" ]; then
  INSTALLED_VERSION="$(curl -fsSL "https://raw.githubusercontent.com/atompilot/claude-code-auto-commit/main/VERSION" 2>/dev/null || echo "unknown")"
else
  INSTALLED_VERSION="unknown"
fi

echo ""
echo "Installed successfully! (v${INSTALLED_VERSION})"
echo ""
echo "Usage: Type /auto-commit in Claude Code to run."
echo "  /auto-commit              Auto-detect version bump"
echo "  /auto-commit --major      Force major version bump"
echo "  /auto-commit --minor      Force minor version bump"
echo "  /auto-commit --patch      Force patch version bump"
echo "  /auto-commit --no-push    Commit only, do not push"
echo ""
echo "To uninstall: rm ~/.claude/commands/auto-commit.md"
