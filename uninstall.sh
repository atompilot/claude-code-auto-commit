#!/usr/bin/env bash
set -euo pipefail

COMMAND_NAME="auto-commit.md"
TARGET_DIR="$HOME/.claude/commands"

echo "=== Claude Code Auto Commit - Uninstaller ==="
echo ""

removed=false

if [ -f "$TARGET_DIR/$COMMAND_NAME" ]; then
  rm "$TARGET_DIR/$COMMAND_NAME"
  echo "Removed: $TARGET_DIR/$COMMAND_NAME"
  removed=true
fi

if [ -f "$TARGET_DIR/${COMMAND_NAME}.bak" ]; then
  rm "$TARGET_DIR/${COMMAND_NAME}.bak"
  echo "Removed backup: $TARGET_DIR/${COMMAND_NAME}.bak"
  removed=true
fi

if [ "$removed" = true ]; then
  echo ""
  echo "Uninstalled successfully."
else
  echo "Nothing to uninstall — auto-commit.md not found."
fi
