#!/usr/bin/env bash
# Check Neovim configuration and install plugins
# Usage: nvim-check.sh <dotfiles-dir> <git-bin> <nvim-bin>

set -e

DOTFILES_DIR="$1"
GIT_BIN="$2"
NVIM_BIN="$3"

echo "🔍 Testing Neovim configuration..."

# Copy nvim config to a temporary location for testing
TEMP_NVIM_DIR=$(mktemp -d)
trap "rm -rf $TEMP_NVIM_DIR" EXIT

export XDG_CONFIG_HOME="$TEMP_NVIM_DIR/config"
export XDG_DATA_HOME="$TEMP_NVIM_DIR/data"
export XDG_STATE_HOME="$TEMP_NVIM_DIR/state"
export XDG_CACHE_HOME="$TEMP_NVIM_DIR/cache"

mkdir -p "$XDG_CONFIG_HOME/nvim"
cp -r "$DOTFILES_DIR/nvim/"* "$XDG_CONFIG_HOME/nvim/"

# Install Lazy.nvim
echo "📦 Installing Lazy.nvim..."
"$GIT_BIN" clone --filter=blob:none \
  https://github.com/folke/lazy.nvim.git \
  "$XDG_DATA_HOME/nvim/lazy/lazy.nvim"

# Restore plugins from lazy-lock.json
echo "📦 Installing Neovim plugins..."
"$NVIM_BIN" --headless "+Lazy! restore" +qa

echo "✅ Neovim configuration is valid and all plugins installed successfully!"
