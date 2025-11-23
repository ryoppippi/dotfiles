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
    typst
    # Build systems
    just
    ninja
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
    pinact
    license-go
    # Container & Docker
    dive
    act
    # Database tools
    trdsql
    sqls
    usql
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
    ghr
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
    richgo
    iferr
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
    pv
    # Image tools
    imagemagick
    gyazo-cli
  ];
}
