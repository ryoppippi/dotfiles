{
  description = "ryoppippi's home-manager configuration";

  nixConfig = {
    extra-substituters = [ "https://numtide.cachix.org" ];
    extra-trusted-public-keys = [ "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=" ];
  };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ai-tools = {
      url = "github:numtide/nix-ai-tools";
    };

    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ai-tools,
    claude-code-overlay,
  }: let
    username = "ryoppippi";
    system = "aarch64-darwin";
    homedir = "/Users/${username}";
    hostname = "${username}";
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;

      modules = [
        # Nix configuration
        ({pkgs, lib, ...}: let
          fishPath = "${pkgs.fish}/bin/fish";
        in {
          # Disable nix-darwin's Nix management (using Determinate Nix)
          nix.enable = false;

          # Enable Touch ID for sudo
          security.pam.services.sudo_local.touchIdAuth = true;

          # Set system state version
          system.stateVersion = 5;

          # Set primary user for homebrew
          system.primaryUser = username;

          # Define user
          users.users.${username} = {
            home = homedir;
            shell = pkgs.fish;
            ignoreShellProgramCheck = true;
          };

          # Add fish to system shells
          environment.shells = [ pkgs.fish ];

          # Set user shell on activation
          system.activationScripts.postActivation.text = ''
            echo "Setting login shell to fish..."
            sudo chsh -s ${fishPath} ${username} || true
          '';

          # Homebrew configuration
          homebrew = {
            enable = true;
            onActivation.cleanup = "zap";

            taps = [
              "apple/apple"
              "artginzburg/tap"
              "clojure/tools"
              "danielbayley/alfred"
              "homebrew/bundle"
              "homebrew/services"
              "koekeishiya/formulae"
              "kphrx/personal"
              "kyoh86/tap"
              "libsql/sqld"
              "masutaka/tap"
              "nikitabobko/tap"
              "opencode-ai/tap"
              "sdkman/tap"
              "tursodatabase/tap"
            ];

            brews = [
              "bluetoothconnector"
              "cmigemo"
              "ffmpeg@4"
              "fig2dev"
              "gnuplot"
              "graphicsmagick"
              "imagemagick"
              "leiningen"
              "llvm"
              "mysql-client"
              "openjdk"
              "pam-reattach"
              "python@3.11"
              "python@3.9"
              "screenresolution"
              "smartmontools"
              "swift-format"
              "swift-sh"
              "switchaudio-osx"
              "typos-lsp"
              "artginzburg/tap/sudo-touchid"
              "kyoh86/tap/git-branches"
              "kyoh86/tap/git-vertag"
            ];

            casks = [
              # "aerospace" 
              "alfred"
              "alt-tab"
              "appcleaner"
              "aqua-voice"
              "arc"
              "audacity"
              "background-music"
              "balenaetcher"
              "blackhole-16ch"
              "blu-ray-player-pro"
              "bluesnooze"
              "cloudflare-warp"
              "cyberduck"
              "db-browser-for-sqlite"
              "dbeaver-community"
              "deskpad"
              "discord"
              "font-line-seed-jp"
              "font-udev-gothic"
              "font-udev-gothic-nf"
              "ghostty"
              "google-chrome"
              "google-drive"
              "hammerspoon"
              "imageoptim"
              "jetbrains-toolbox"
              "jettison"
              "jupyter-notebook-viewer"
              "kap"
              "karabiner-elements"
              "keycastr"
              "licecap"
              "lulu"
              "maestral"
              "microsoft-auto-update"
              "min"
              "monitorcontrol"
              "obs"
              "obsidian"
              "ollama"
              "openvpn-connect"
              "orbstack"
              "piphero"
              "processing"
              "qlvideo"
              "quitter"
              "raspberry-pi-imager"
              "raycast"
              "sdformatter"
              "secretive"
              "shortcat"
              "shottr"
              "skim"
              "ssh-tunnel-manager"
              "stats"
              "suspicious-package"
              "symboliclinker"
              "syncthing"
              "touch-bar-simulator"
              "transmission@nightly"
              "visual-studio-code"
              "vlc"
              "wezterm"
              "xquartz"
              "zed"
              "zerotier-one"
              "zoom"
            ];

            masApps = {
              "Accelerate" = 1459809092;
              "Actions" = 1586435171;
              "AdGuard for Safari" = 1440147259;
              "Aiko" = 1672085276;
              "Amphetamine" = 937984704;
              "Be Focused" = 973134470;
              "Blackmagic Disk Speed Test" = 425264550;
              "BlockComment" = 1246672247;
              "Clean" = 418412301;
              "Color Picker" = 1545870783;
              "Command X" = 6448461551;
              "Consent-O-Matic" = 1606897889;
              "CotEditor" = 1024640650;
              "DevCleaner" = 1388020431;
              "Document Generator" = 1437883178;
              "Download Shuttle" = 847809913;
              "DuckDuckGo Privacy for Safari" = 1482920575;
              "Final Cut Pro" = 424389933;
              "FocusRecorder" = 6446467176;
              "Gifski" = 1351639930;
              "GIPHY CAPTURE" = 668208984;
              "Grammarly for Safari" = 1462114288;
              "Hex Fiend" = 1342896380;
              "Hush" = 1544743900;
              "iHosts" = 1102004240;
              "Keepa - Price Tracker" = 1533805339;
              "Keynote" = 409183694;
              "Keyword Search" = 1558453954;
              "Kindle" = 302584613;
              "LadioCast" = 411213048;
              "LanguageTranslator" = 1218781096;
              "Leftovers" = 6746164364;
              "LINE" = 539883307;
              "Mapture" = 1671995907;
              "Mathpix Snipping Tool" = 1349670778;
              "Messenger" = 1480068668;
              "Microsoft Excel" = 462058435;
              "Microsoft Remote Desktop" = 1295203466;
              "Microsoft Word" = 462054704;
              "NamingTranslator" = 1218784832;
              "Pages" = 409201541;
              "PicGIF Lite" = 844918735;
              "PiPifier" = 1160374471;
              "Refined GitHub" = 1519867270;
              "Screegle" = 1591051659;
              "Seashore" = 1448648921;
              "Sequel Ace" = 1518036000;
              "Shareful" = 1522267256;
              "Skitch" = 425955336;
              "Slack" = 803453959;
              "Spaced" = 1666327168;
              "Spark" = 1176895641;
              "Speedtest" = 1153157709;
              "Squirrel" = 1669664068;
              "TabifyIndents" = 1179234554;
              "TestFlight" = 899247664;
              "The Unarchiver" = 425424353;
              "Tunacan" = 980577198;
              "uBlacklist for Safari" = 1547912640;
              "Userscripts" = 1463298887;
              "Velja" = 1607635845;
              "Vimari" = 1480933944;
              "VisBug" = 1538509686;
              "WhatsApp" = 310633997;
              "Xcode" = 497799835;
            };
          };
        })

        # Home Manager integration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {pkgs, ...}: {
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;

            home.packages = with pkgs; [
              # Essentials
              curl
              devenv
              htop
              fish
              neovim
              tmux
              # VCS
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
              # macOS utilities
              chafa
              blueutil
              # Additional CLI tools from Homebrew
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
              switchaudio-osx
            ] ++ [
              claude-code-overlay.packages.${system}.default
            ] ++ (with ai-tools.packages.${system}; [
              codex
              cursor-agent
              opencode
              copilot-cli
              coderabbit-cli
            ]);
          };
        }
      ];
    };

    # Apps for common tasks
    apps.${system} = {
      # Apply darwin configuration
      switch = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "darwin-switch" ''
          set -e
          echo "Building and switching to darwin configuration..."
          sudo nix run nix-darwin -- switch --flake .#${hostname}
        '');
      };

      # Update flake.lock
      update = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "flake-update" ''
          set -e
          echo "Updating flake.lock..."
          nix flake update
          echo "Done! Run 'nix run .#switch' to apply changes."
        '');
      };

      # Update ai-tools only
      update-ai-tools = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "update-ai-tools" ''
          set -e
          echo "Updating ai-tools input..."
          nix flake update ai-tools
          echo "Done! Run 'nix run .#switch' to apply changes."
        '');
      };

      # Build darwin configuration (dry run)
      build = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${system}.writeShellScript "darwin-build" ''
          set -e
          echo "Building darwin configuration..."
          nix build .#darwinConfigurations.${hostname}.system
          echo "Build successful! Run 'nix run .#switch' to apply."
        '');
      };
    };
  };
}
