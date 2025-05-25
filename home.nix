{ config, pkgs, lib, isDarwin ? false, isLinux ? false, system ? "aarch64-darwin", ... }:

let
  # Custom Node packages for Neovim LSP servers
  nodePackages = pkgs.nodePackages // {
    # Some LSP servers might need to be built from source
    # or use specific versions
  };
  
  # Platform-specific home directory
  homeDir = if isDarwin then "/Users/ryoppippi" else "/home/ryoppippi";
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ryoppippi";
  home.homeDirectory = homeDir;

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
  home.packages = with pkgs; (
    # Common packages for all platforms
    [
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
    
    # === Migrated from Homebrew ===
    # Core Development Tools
    libpng
    libyaml
    autoconf
    bash
    bash-completion
    bison
    bluetoothconnector
    boost
    freetype
    fontconfig
    glib
    cairo
    clang-format
    cloc
    cmake
    cmatrix
    cmigemo
    ruby
    coreutils
    curl
    gcc
    
    # Image & Graphics Libraries
    openjpeg
    leptonica
    tesseract
    ghostscript
    imagemagick
    graphicsmagick
    graphviz
    
    # Multimedia Libraries
    libogg
    flac
    lame
    libass
    libbluray
    libvorbis
    mpg123
    libsndfile
    libsoxr
    libssh
    libvidstab
    libvpx
    sdl2
    zeromq
    ffmpeg
    ffmpeg_4
    
    # Scientific & Math Tools
    openmpi
    fftw
    glpk
    gnuplot
    hdf5
    lapack
    metis
    qhull
    qrupdate
    suite-sparse
    sundials
    
    # Terminal & Shell Tools
    eza
    figlet
    fish
    fortune
    gawk
    gnused
    parallel
    pv
    rlwrap
    rsync
    sl
    smartmontools
    telnet
    terminal-notifier
    tldr
    trash
    
    # Programming Language Tools
    python311
    python39
    leiningen
    llvm
    
    # System Libraries
    libffi
    libtool
    libuv
    libzip
    msgpack
    zlib
    
    # Database Tools
    mysql80
    
    # Other Tools
    aria2
    coreutils
    git-now
    gd
    icoutils
    media-info
    plotutils
    poppler
    utf8proc
    wget
    
    # === Migrated from devbox (already included above) ===
    # yarn (use yarn from nodePackages)
    # nodejs (already included as nodejs_24)
    # pnpm (already included)
    
    # === Neovim LSP Node Packages ===
    nodePackages."@astrojs/language-server"
    nodePackages."@prisma/language-server"
    nodePackages."@tailwindcss/language-server"
    nodePackages."@vue/language-server"
    nodePackages.cssmodules-language-server
    nodePackages.emmet-ls
    nodePackages.sql-language-server
    nodePackages.stylelint
    nodePackages.svelte-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    nodePackages.yarn
  ] ++ lib.optionals isDarwin [
    # macOS-specific packages
    cocoapods
    darwin.cctools
    mas
    swift-format
    screenresolution
    wallpaper
  ] ++ lib.optionals isLinux [
    # Linux-specific packages
    # Add Linux-specific tools here
  ]);

  # Configure git with all settings from git/config
  programs.git = {
    enable = true;
    userName = "ryoppippi";
    userEmail = "ryoppippi@gmail.com";
    
    aliases = {
      a = "add";
      aa = "add .";
      amend = "commit --amend";
      b = "branch";
      ba = "branch -a";
      c = "commit";
      ca = "commit -a";
      cam = "commit -a -m";
      cm = "commit -m";
      co = "checkout";
      d = "diff";
      dc = "diff --cached";
      f = "fetch";
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      la = "log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      pl = "pull";
      ps = "push";
      s = "status";
      st = "status";
    };
    
    extraConfig = {
      core = {
        editor = "nvim";
        pager = "delta";
      };
      color = {
        ui = "auto";
      };
      push = {
        default = "simple";
        autoSetupRemote = true;
      };
      pull = {
        rebase = true;
      };
      init = {
        defaultBranch = "main";
      };
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      interactive = {
        diffFilter = "delta --color-only";
      };
      delta = {
        navigate = true;
        light = false;
        line-numbers = true;
        syntax-theme = "Dracula";
      };
    };
    
    ignores = [
      ".DS_Store"
      "*.swp"
      "*~"
      ".idea"
      ".vscode"
      "node_modules"
      ".env"
      ".env.local"
    ];
  };

  # Configure fish shell
  programs.fish = {
    enable = true;
    
    # Shell aliases and abbreviations
    shellAbbrs = {
      g = "git";
      ga = "git add";
      gc = "git commit";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
      gs = "git status";
      
      l = "eza -la";
      ll = "eza -l";
      la = "eza -a";
      lt = "eza --tree";
      
      v = "nvim";
      vim = "nvim";
      
      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
    
    interactiveShellInit = ''
      # Set fish greeting
      set -g fish_greeting
      
      # Set editor
      set -gx EDITOR nvim
      set -gx VISUAL nvim
      
      # FZF configuration
      set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
      set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
      
      # Source custom functions if they exist
      if test -d $HOME/.config/fish/user_functions
        for f in $HOME/.config/fish/user_functions/*.fish
          source $f
        end
      end
    '';
    
    plugins = [
      # Fish plugins can be managed here
    ];
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
    config = {
      theme = "Dracula";
      pager = "less -FR";
    };
  };
  
  # Configure other dotfiles
  home.file = {
    # Karabiner configuration
    ".config/karabiner" = {
      source = ./karabiner;
      recursive = true;
    };
    
    # Neovim configuration (keeping as-is for now)
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    
    # Wezterm configuration
    ".config/wezterm" = {
      source = ./wezterm;
      recursive = true;
    };
    
    # Ghostty configuration
    ".config/ghostty" = {
      source = ./ghostty;
      recursive = true;
    };
    
    # Lazygit configuration
    ".config/lazygit" = {
      source = ./lazygit;
      recursive = true;
    };
  } // lib.optionalAttrs isDarwin {
    # macOS-specific configurations
    ".config/hammerspoon" = {
      source = ./hammerspoon;
      recursive = true;
    };
  };
  
  # SSH configuration
  programs.ssh = {
    enable = true;
    compression = true;
    controlMaster = "auto";
    controlPersist = "10m";
  };
  
  # tmux configuration (if you want to add it)
  programs.tmux = {
    enable = false; # Set to true if you use tmux
    terminal = "screen-256color";
    keyMode = "vi";
  };
}