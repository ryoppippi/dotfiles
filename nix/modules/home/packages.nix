{ pkgs, lib, ... }:
let
  # Check if we're on a platform that supports certain packages
  isX86Linux = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
  isDarwin = pkgs.stdenv.isDarwin;
in
{
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
      delta
      tre
      vivid
      pastel
      hexyl
      # Development languages
      nodejs_24
      bun
      deno
      # Build systems
      just
      # Package managers
      pnpm
      yarn
      # Shell & TUI
      navi
      # Testing & security
      typos
      uv
      pinact
      license-go
      # Database tools
      xan
      tv
      # Performance & monitoring
      hyperfine
      bottom
      oha
      viddy
      gping
      # Miscellaneous utilities
      sttr
      silicon
      fx
      fixjson
      gist
      glow
      vhs
      gitu
      mmv
      jid
      gibo
      genact
      grex
      watchexec
      rclone
      ttyd
      fastfetch
      yazi
      jujutsu
      xh
      choose
      ast-grep
      t-rec
      jwt-cli
      fq
      tokei
      bsky-cli
      signal-cli
      oglens
      sheep
      similarity-ts
      # Additional CLI tools
      aria2
      cloc
      cmatrix
      ffmpeg
      figlet
      gawk
      pv
      # Image tools
      gyazo-cli

      # GUI applications (cross-platform)
      audacity
      vscode
      zed-editor
    ]
    # Platform-specific GUI applications
    # discord only supports x86_64-linux, x86_64-darwin, aarch64-darwin (not aarch64-linux)
    ++ lib.optionals (isDarwin || isX86Linux) [
      discord
    ];
}
