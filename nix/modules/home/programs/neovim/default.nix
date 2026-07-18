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
  #
  # nvim-treesitter's `withAllGrammars` ships no compiled `parser/*.so` on the
  # main branch (it only carries the plugin source + `runtime/queries`), so
  # loading it alone leaves every non-builtin language without a parser. Join
  # the per-language `grammarPlugins` (each provides `parser/<lang>.so`) and
  # graft the plugin's `runtime/queries` in as `queries/` so both the parsers
  # and the matching highlight queries resolve from a single runtimepath entry.
  treesitterGrammars = pkgs.symlinkJoin {
    name = "nvim-treesitter-grammars-with-queries";
    paths = builtins.attrValues pkgs.vimPlugins.nvim-treesitter.grammarPlugins;
    postBuild = ''
      ln -s ${pkgs.vimPlugins.nvim-treesitter}/runtime/queries $out/queries
    '';
  };
  # Plugins served from the Nix store instead of lazy.nvim's git clones
  #
  # plugins.nix maps lazy.nvim plugin directory names to nixpkgs vimPlugins
  # attributes; each mapped plugin is linked into one farm whose entry names
  # lazy.nvim's `dev.path` resolves directly. Plugins absent from the map
  # (not packaged in nixpkgs, or intentionally excluded) keep being cloned
  # by lazy.nvim at the lazy-lock.json commit (`dev.fallback = true` on the
  # Lua side). The farm must NOT be derived from lazy-lock.json: lazy.nvim
  # drops dev-served plugins from the lock file on the next lock update, so
  # keying the farm off the lock would unserve everything after one restore.
  lazyNixPlugins = pkgs.linkFarm "lazy-nix-plugins" (
    lib.mapAttrsToList (name: attr: {
      inherit name;
      path = pkgs.vimPlugins.${attr};
    }) (import ./plugins.nix)
  );

  bash = lib.getExe pkgs.bash;
  # the wrapped neovim, NOT pkgs.neovim: the activation-time `Lazy! restore`
  # needs the wrapper's LAZY_NIX_PLUGINS (otherwise lazy.nvim treats every
  # Nix-served plugin as a missing git plugin, clones all of them at HEAD and
  # rewrites lazy-lock.json) and the wrapper's extraPackages on PATH
  nvim = lib.getExe config.programs.neovim.finalPackage;
in
{
  programs.neovim = {
    enable = true;

    # Keep legacy provider defaults (Neovim 0.11 era) — silences the
    # home-manager warning that fires when home.stateVersion < "26.05".
    withRuby = true;
    withPython3 = true;

    # Set environment variables only for Neovim session
    extraWrapperArgs = [
      "--set"
      "TREESITTER_GRAMMARS"
      "${treesitterGrammars}"
      "--set"
      "LAZY_NIX_PLUGINS"
      "${lazyNixPlugins}"
    ];

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

        # Plugin build dependencies (lazy.nvim build steps)
        cmake # some plugins requiring cmake

        # Language servers
        lua-language-server # Lua LSP
        nixd # Nix LSP
        efm-langserver # General purpose LSP
        typos-lsp # Spell checker LSP
        nushell # Nushell (`nu --lsp` language server)

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
        svelte-language-server # Svelte
        tailwindcss-language-server # Tailwind CSS
        textlint # Natural language linter
        vscode-langservers-extracted # HTML/CSS/JSON/ESLint
        yaml-language-server # YAML
      ]);

  };

  xdg.configFile."nvim/init.lua".enable = lib.mkForce false;

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
      ${bash} \
        ${./check.sh} \
        "${nvimDotfilesDir}" \
        "$LAZY_DIR" \
        ${nvim}
    fi
  '';
}
