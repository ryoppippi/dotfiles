{
  pkgs,
  config,
  lib,
  homedir,
  dotfilesDir ? "${homedir}/ghq/github.com/ryoppippi/dotfiles",
  claude-code-overlay ? null,
  treefmt-nix ? null,
  git-hooks ? null,
  system ? null,
  ...
}:
let
  # Import common helpers once
  helpers = import ./lib/helpers { inherit lib; };
in
{
  imports = [
    # Git hooks configuration
    (import ./git-hooks.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        treefmt-nix
        ;
    })

    # Program configurations (Claude Code, Codex, Neovim, etc.)
    (import ./programs {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        claude-code-overlay
        system
        helpers
        ;
    })

    # Dotfiles symlinks
    (import ./dotfiles {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        helpers
        ;
    })
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages =
    with pkgs;
    [
      # Essentials
      curl
      devenv
      htop
      fish
      tmux
      # VCS
      git
      bit
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
      typos
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
      terminal-notifier
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
      # Image tools
      imagemagick
    ]
    ++ (
      if pkgs.stdenv.isDarwin then
        [
          # macOS-specific packages
          ghostty-bin
          chafa
          blueutil
          switchaudio-osx
        ]
      else
        [
          # Linux-specific packages can be added here
        ]
    );
}
