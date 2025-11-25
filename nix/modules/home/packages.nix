{ pkgs, ... }:
{
  home.packages = with pkgs; [
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
    nodejs_24
    bun
    deno
    # Build systems
    just
    # Package managers
    pnpm
    yarn
    # Shell & TUI
    direnv
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
    ctop
    oha
    viddy
    hwatch
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
    oglens
    sheep
    similarity-ts
    # Cloud tools
    pscale
    cloudflared
    # Password managers
    _1password-cli
    # AI tools
    claude-code-acp
    # Additional CLI tools
    aria2
    cloc
    cmatrix
    ffmpeg
    figlet
    fortune
    gawk
    pv
    # Image tools
    imagemagick
    gyazo-cli
  ];
}
