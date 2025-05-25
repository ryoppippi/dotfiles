{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ryoppippi";
  home.homeDirectory = "/Users/ryoppippi";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # Version Control & Git Tools
    gh
    git-lfs
    lazygit
    ghq
    gist
    ghr
    
    # Development Tools
    go
    go-tools
    gotools
    gomock
    deno
    bun
    nodejs_24
    pnpm
    lua-language-server
    efm-langserver
    stylua
    zls
    
    # Search & File Navigation
    fzf
    ripgrep
    fd
    zoxide
    bat
    eza
    yazi
    
    # System Monitoring & Performance
    bottom
    hyperfine
    tokei
    dust
    duf
    procs
    gping
    viddy
    
    # Container & Cloud Tools
    dive
    lazydocker
    ctop
    dockle
    trivy
    hadolint
    
    # Text Processing & Data Tools
    jq
    yq-go
    fx
    jnv
    xsv
    fq
    jid
    grex
    choose
    
    # Network Tools
    cloudflared
    httpx
    xh
    oha
    ttyd
    
    # Terminal & Shell
    starship
    direnv
    navi
    tre-command
    
    # Development Utilities
    watchexec
    act
    actionlint
    cobra-cli
    gotestsum
    richgo
    iferr
    
    # Documentation & Presentation
    hugo
    marp-cli
    glow
    
    # Media & Graphics
    silicon
    vhs
    asciinema
    freeze
    genact
    pastel
    hexyl
    
    # Database Tools
    usql
    sqls
    trdsql
    
    # Security & Encryption
    sccache
    jwt-cli
    secretlint
    
    # File Management
    rclone
    mmv
    gibo
    
    # Rust Tools
    ruff
    
    # Miscellaneous CLI Tools
    wakatime
    gocloc
    delta
    vivid
    license
    gitu
    jj
    fastfetch
    typst
    uv
    pingu
    vim-startuptime
    tv
    whalebrew
    ojichat
    sttr
    srss
    dotfiles
    
    # Build Tools
    ninja
    
    # Recording Tools
    t-rec
    
    # Package Management
    devbox
    aqua
    
    # Wasm
    wasmer
    
    # Other Tools
    mitmproxy
    github-comment
    cmdx
    sheep
    afx
    gyazo
    bsky
    zig
  ];

  # Configure git
  programs.git = {
    enable = true;
    userName = "ryoppippi";
    userEmail = "ryoppippi@gmail.com";
  };

  # Configure fish shell
  programs.fish = {
    enable = true;
  };

  # Configure starship
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };

  # Configure direnv
  programs.direnv = {
    enable = true;
    enableFishIntegration = true;
    nix-direnv.enable = true;
  };

  # Configure fzf
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  # Configure zoxide
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Configure bat
  programs.bat = {
    enable = true;
  };
}