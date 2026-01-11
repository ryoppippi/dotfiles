#!/usr/bin/env bash
# Neovim plugin restoration script (Lazy.nvim is auto-installed by Lua config)
# Usage: nvim-restore.sh <nvim-dotfiles-dir> <lazy-dir> <nvim-bin>

set -e

NVIM_DOTFILES_DIR="$1"
LAZY_DIR="${2:-$HOME/.local/share/nvim/lazy}"
NVIM_BIN="${3:-nvim}"

LAZY_LOCK="$NVIM_DOTFILES_DIR/lazy-lock.json"
LAZY_LOCK_TIMESTAMP="$LAZY_DIR/.lazy-lock-timestamp"

if [[ -f $LAZY_LOCK ]]; then
  echo "📦 Restoring Neovim plugins from lazy-lock.json..."
  "$NVIM_BIN" --headless "+Lazy! restore" +qa
  mkdir -p "$LAZY_DIR"
  touch "$LAZY_LOCK_TIMESTAMP"
  echo "✅ Neovim plugins restored!"
fi
