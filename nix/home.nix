{
  pkgs,
  config,
  lib,
  homedir,
  dotfilesDir ? "${homedir}/ghq/github.com/ryoppippi/dotfiles",
  claude-code-overlay ? null,
  system ? null,
  ...
}: {
  imports = [
    (import ./git-hooks.nix {
      inherit pkgs lib config dotfilesDir;
    })
    (import ./programs/claude-code.nix {
      inherit pkgs lib config dotfilesDir claude-code-overlay system;
    })
    (import ./programs/codex.nix {
      inherit pkgs lib config dotfilesDir;
    })
    (import ./dotfiles.nix {
      inherit pkgs lib config dotfilesDir;
    })
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs;
    [
      # Essentials
      curl
      devenv
      htop
      fish
      neovim
      tmux
      # VCS
      git
      bit
      gh
      git-lfs
      ghq
      lazygit
      lazydocker
      # Search & file utilities
      ripgrep
      fd
      fzf
      zoxide
      bat
      eza
      wezterm
      jq
      dust
      duf
      delta
      tre
      vivid
      pastel
      hexyl
      # Development languages
      go
      nodejs_24
      bun
      deno
      tinygo
      typst
      # Build systems
      just
      ninja
      # Language servers
      lua-language-server
      stylua
      efm-langserver

      # NeoVim language servers (Node.js-based)
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
      # Go tooling
      gotools
      mockgen
      gotestsum
      cobra-cli
      golines
      # Package managers
      pnpm
      yarn
      # Shell & TUI
      starship
      direnv
      navi
      # Testing & security
      hadolint
      actionlint
      ruff
      uv
      # Container & Docker
      dive
      act
      # Database tools
      trdsql
      sqls
      usql
      # Performance & monitoring
      hyperfine
      bottom
      ctop
      oha
      viddy
      hwatch
      # Miscellaneous utilities
      sttr
      silicon
      fx
      gist
      glow
      vhs
      marp-cli
      gitu
      mmv
      jid
      gibo
      genact
      grex
      gping
      ghr
      watchexec
      rclone
      ttyd
      wasmer
      fastfetch
      yazi
      jujutsu
      xh
      choose
      ast-grep
      t-rec
      richgo
      iferr
      jwt-cli
      fq
      tokei
      # Cloud tools
      pscale
      cloudflared
      # Additional CLI tools
      aria2
      autoconf
      bison
      clang-tools
      cloc
      cmatrix
      ffmpeg
      figlet
      fortune
      gawk
      gnumake
      mas
      pv
    ]
    ++ (
      if pkgs.stdenv.isDarwin
      then [
        # macOS-specific packages
        ghostty-bin
        chafa
        blueutil
        switchaudio-osx
      ]
      else [
        # Linux-specific packages can be added here
      ]
    );
}
