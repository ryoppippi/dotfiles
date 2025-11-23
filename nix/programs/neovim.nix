{
  pkgs,
  lib,
  config,
  dotfilesDir,
  ...
}:
let
  nvimDotfilesDir = "${dotfilesDir}/nvim";
  nvimConfigDir = "${config.xdg.configHome}/nvim";
  helpers = import ../lib/activation-helpers.nix { inherit lib; };
in
{
  programs.neovim = {
    enable = true;

    # These packages are only available when NeoVim is running
    extraPackages = with pkgs; [
      # Runtime dependencies
      sqlite # SQLite library for sqlite.lua plugin

      # Language servers
      lua-language-server # Lua LSP
      efm-langserver # General purpose LSP
      pyright # Python LSP
      typos-lsp # Spell checker LSP

      # Python tools
      ruff # Python linter/formatter with built-in language server

      # Formatters & Linters (used by efm-langserver)
      stylua # Lua formatter
      swift-format # Swift formatter
      hadolint # Dockerfile linter
      actionlint # GitHub Actions linter

      # Node.js-based language servers
      astro-language-server # Astro
      emmet-language-server # Emmet
      prisma-language-server # Prisma
      stylelint # CSS linter
      svelte-language-server # Svelte
      tailwindcss-language-server # Tailwind CSS
      typescript-language-server # TypeScript
      vscode-langservers-extracted # HTML/CSS/JSON/ESLint
      vtsls # TypeScript LSP wrapper
      vue-language-server # Vue.js
      yaml-language-server # YAML
    ];

    # Don't manage init.lua - use the existing one from dotfiles
    # extraLuaConfig is removed to avoid conflicts
  };

  # Create symlink to NeoVim configuration in dotfiles (bypassing Nix store)
  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${helpers.mkLinkForce}
    link_force "${nvimDotfilesDir}" "${nvimConfigDir}"
  '';

  # Install/restore Neovim plugins via Lazy.nvim
  home.activation.installNeovimPlugins = lib.hm.dag.entryAfter [ "linkNvimConfig" ] ''
    LAZY_DIR="$HOME/.local/share/nvim/lazy"
    LAZY_NVIM_DIR="$LAZY_DIR/lazy.nvim"
    LAZY_LOCK="${nvimDotfilesDir}/lazy-lock.json"
    LAZY_LOCK_TIMESTAMP="$LAZY_DIR/.lazy-lock-timestamp"

    # Install Lazy.nvim if not present
    if [[ ! -d "$LAZY_NVIM_DIR" ]]; then
      echo "📦 Installing Lazy.nvim..."
      ${pkgs.git}/bin/git clone --filter=blob:none \
        https://github.com/folke/lazy.nvim.git \
        "$LAZY_NVIM_DIR"
    fi

    # Check if lazy-lock.json has been updated
    SHOULD_RESTORE=0
    if [[ ! -f "$LAZY_LOCK_TIMESTAMP" ]]; then
      # First run or timestamp missing
      SHOULD_RESTORE=1
    elif [[ "$LAZY_LOCK" -nt "$LAZY_LOCK_TIMESTAMP" ]]; then
      # lazy-lock.json is newer than our timestamp
      SHOULD_RESTORE=1
    fi

    # Restore plugins if needed
    if [[ $SHOULD_RESTORE -eq 1 ]]; then
      if [[ -f "$LAZY_LOCK" ]]; then
        echo "📦 Restoring Neovim plugins from lazy-lock.json..."
        ${pkgs.neovim}/bin/nvim --headless "+Lazy! restore" +qa
        echo "✅ Neovim plugins restored!"

        # Update timestamp
        mkdir -p "$LAZY_DIR"
        touch "$LAZY_LOCK_TIMESTAMP"
      fi
    fi
  '';
}
