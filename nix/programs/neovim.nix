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
      # Language servers
      lua-language-server # Lua LSP
      efm-langserver # General purpose LSP
      pyright # Python LSP
      typos-lsp # Spell checker LSP

      # Python tools
      ruff # Python linter/formatter with built-in language server

      # Formatters & Linters (used by efm-langserver)
      stylua # Lua formatter
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
}
