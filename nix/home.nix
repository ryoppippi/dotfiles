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
  ];

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  # Symlink dotfiles to their proper locations
  home.file = {
    # Hammerspoon configuration (macOS only, but harmless on Linux)
    ".hammerspoon".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hammerspoon";

    # Homebrew bundle file (macOS only, but harmless on Linux)
    ".Brewfile".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/Brewfile";

    # IdeaVim configuration
    ".ideavimrc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/ideavimrc";

    # LazyGit configuration
    ".config/lazygit".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/lazygit";

    # Fish shell configuration
    ".config/fish".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/fish";

    # Zsh environment
    ".zshenv".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zshenv";

    # Aqua package manager configuration
    ".config/aquaproj-aqua".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/aqua";

    # Zed editor configuration
    ".config/zed/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/zed/settings.json";

    # Karabiner Elements configuration (macOS only, but harmless on Linux)
    ".config/karabiner".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/karabiner";

    # WezTerm configuration
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/wezterm";

    # Bash profile
    ".bash_profile".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/bash/.bash_profile";

    # Starship prompt configuration
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/starship.toml";

    # Bat configuration
    ".config/bat".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/bat";
  };

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
