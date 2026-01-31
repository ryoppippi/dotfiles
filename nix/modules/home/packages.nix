{ pkgs, lib, ... }:
let
  # Check if we're on a platform that supports certain packages
  inherit (pkgs.stdenv) isDarwin isLinux;
  isX86Linux = pkgs.stdenv.hostPlatform.system == "x86_64-linux";
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
      git-now
      git-wt
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
      t-rec
      jwt-cli
      fq
      tokei
      bsky-cli
      signal-cli
      sheep
      roots
      # Additional CLI tools
      aria2
      cloc
      cmatrix
      ffmpeg
      figlet
      gawk
      pv

      # GUI applications (cross-platform)
      audacity
      vscode
    ]
    # Platform-specific GUI applications
    # discord only supports x86_64-linux, x86_64-darwin, aarch64-darwin (not aarch64-linux)
    ++ lib.optionals (isDarwin || isX86Linux) [
      discord
    ]
    # Linux-only GUI applications
    ++ lib.optionals isLinux [
      telegram-desktop
    ];
}
