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
in
{
  # Plugins are resolved from the lazy.nvim spec by `nvimx-lock` and pinned in
  # nvim/nvimx-lock/flake.lock; lazy.nvim only loads them from the Nix store.
  # See ROADMAP.md for why nvimx replaced lazy2nix.
  programs.nvimx = {
    enable = true;

    # The config is symlinked from the working tree below so edits apply
    # without a switch; nvimx only needs the lock.
    manageConfig = false;
    lockDir = ../../../../../nvim/nvimx-lock;

    lock = {
      projectDir = dotfilesDir;
      configDirRelative = "nvim";
      lockDirRelative = "nvim/nvimx-lock";
    };

    # Own plugins (`dev = true` in the spec) load from the mutable ghq checkout
    devPath = "~/ghq/github.com/ryoppippi";

    plugins.nixpkgsFallback = [
      # its spec build runs `nix develop`, which cannot work in the sandbox
      "parinfer-rust"
    ];

    treesitter.grammars = "all";

    # These packages are only available when NeoVim is running
    extraPackages =
      # buildNpmPackage packages (language servers from npm)
      lib.optionals (nodePackages != null) (
        with nodePackages;
        [
          cssmodules-language-server
          gh-actions-language-server
          unocss-language-server
        ]
      )
      ++ (with pkgs; [

        tree-sitter # CLI needed by nvim-treesitter to install grammars nixpkgs does not ship (e.g. moonbit)

        # Language servers
        lua-language-server # Lua LSP
        nixd # Nix LSP
        typos-lsp # Spell checker LSP
        nushell # Nushell (`nu --lsp` language server)

        # Python tools
        ruff # Python linter/formatter with built-in language server
      ])
      ++ (with pkgs; [

        # Node.js-based language servers
        astro-language-server # Astro
        emmet-language-server # Emmet
        prisma-language-server # Prisma
        svelte-language-server # Svelte
        tailwindcss-language-server # Tailwind CSS
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
        yaml-language-server # YAML
      ]);
  };

  # lazy.nvim used to clone itself here; nvimx links its locked copy to the
  # same path, and checkLinkTargets refuses to replace a real directory.
  home.activation.moveLegacyLazyNvim = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    legacy="${config.xdg.dataHome}/nvim/lazy/lazy.nvim"
    if [ -d "$legacy" ] && [ ! -L "$legacy" ]; then
      run mv "$legacy" "$legacy.pre-nvimx"
    fi
  '';

  # Create symlink to NeoVim configuration in dotfiles (bypassing Nix store)
  home.activation.linkNvimConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${helpers.activation.mkLinkForce}
    link_force "${nvimDotfilesDir}" "${nvimConfigDir}"
  '';
}
