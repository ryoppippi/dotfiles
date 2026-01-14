{
  pkgs,
  lib,
  config,
  dotfilesDir,
  helpers,
  nodePackages ? null,
  ...
}:
let
  nvimDotfilesDir = "${dotfilesDir}/nvim";
  nvimConfigDir = "${config.xdg.configHome}/nvim";

  # Pre-built plugins by Nix
  treesitterGrammars = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
  telescopeFzfNative = pkgs.vimPlugins.telescope-fzf-native-nvim;
  telescopeFzyNative = pkgs.vimPlugins.telescope-fzy-native-nvim;
  sqlitePath = "${pkgs.sqlite.out}/lib/libsqlite3.dylib";
in
{
  programs.neovim = {
    enable = true;

    # Set environment variables only for Neovim session
    extraWrapperArgs = [
      "--set"
      "TREESITTER_GRAMMARS"
      "${treesitterGrammars}"
      "--set"
      "TELESCOPE_FZF_NATIVE"
      "${telescopeFzfNative}"
      "--set"
      "TELESCOPE_FZY_NATIVE"
      "${telescopeFzyNative}"
      "--set"
      "SQLITE_CLIB_PATH"
      "${sqlitePath}"
    ];

    # These packages are only available when NeoVim is running
    extraPackages =
      with pkgs;
      [

        # Pre-built plugins (to avoid build steps)
        telescopeFzfNative # telescope-fzf-native.nvim pre-built by Nix
        telescopeFzyNative # telescope-fzy-native.nvim pre-built by Nix
      ]
      # buildNpmPackage packages (language servers from npm)
      ++ lib.optionals (nodePackages != null) (
        with nodePackages;
        [
          unocss-language-server
        ]
      )
      ++ (with pkgs; [

        # Plugin build dependencies (lazy.nvim build steps)
        cmake # some plugins requiring cmake

        # Language servers
        lua-language-server # Lua LSP
        nixd # Nix LSP
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
        stylelint-lsp # Stylelint LSP
        svelte-language-server # Svelte
        tailwindcss-language-server # Tailwind CSS
        textlint # Natural language linter
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
        vue-language-server # Vue.js
        yaml-language-server # YAML
      ]);

  };

  # Create symlink to NeoVim configuration in dotfiles (bypassing Nix store)
  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${helpers.activation.mkLinkForce}
    link_force "${nvimDotfilesDir}" "${nvimConfigDir}"
  '';

  # Restore Neovim plugins via Lazy.nvim when lock file changes
  # (Lazy.nvim itself is auto-installed by Lua config)
  home.activation.restoreNeovimPlugins = lib.hm.dag.entryAfter [ "linkNvimConfig" ] ''
    LAZY_DIR="$HOME/.local/share/nvim/lazy"
    LAZY_LOCK="${nvimDotfilesDir}/lazy-lock.json"
    LAZY_LOCK_TIMESTAMP="$LAZY_DIR/.lazy-lock-timestamp"

    # Only restore if lock file has been updated
    if [[ ! -f "$LAZY_LOCK_TIMESTAMP" ]] || [[ "$LAZY_LOCK" -nt "$LAZY_LOCK_TIMESTAMP" ]]; then
      ${pkgs.bash}/bin/bash \
        ${./check.sh} \
        "${nvimDotfilesDir}" \
        "$LAZY_DIR" \
        ${pkgs.neovim}/bin/nvim
    fi
  '';
}
