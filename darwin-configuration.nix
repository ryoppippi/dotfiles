{ config, pkgs, ... }:

{
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  # Enable experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on macOS
  programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = null;

  # macOS System Preferences
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 48;
      orientation = "bottom";
    };
    
    finder = {
      AppleShowAllExtensions = true;
      FXPreferredViewStyle = "clmv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 10;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };
    
    trackpad = {
      Clicking = true;
      TrackpadThreeFingerDrag = true;
    };
  };

  # macOS-specific services
  launchd.user.agents = {
    # Example: Run a script periodically
    # "com.example.hello" = {
    #   path = [ pkgs.coreutils ];
    #   script = ''
    #     echo "Hello, world!"
    #   '';
    #   startInterval = 3600;  # every hour
    # };
  };

  # Fonts
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; })
  ];

  # macOS apps installed via Nix (alternative to brew cask)
  # Note: Most GUI apps should still be managed via brew cask for better integration
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    
    # Taps
    taps = [
      "homebrew/bundle"
      "homebrew/cask-fonts"
      "homebrew/cask-versions"
      "homebrew/services"
    ];
    
    # Casks (GUI applications)
    casks = [
      "aerospace"
      "alfred"
      "arc"
      "db-browser-for-sqlite"
      "ghostty"
      "hammerspoon"
      "karabiner-elements"
      "obsidian"
      "orbstack"
      "pearcleaner"
      "raycast"
      "visual-studio-code"
      "wezterm"
      "zed"
    ];
    
    # Mac App Store apps
    masApps = {
      "Amphetamine" = 937984704;
      "Xcode" = 497799835;
    };
  };

  # Users
  users.users.ryoppippi = {
    name = "ryoppippi";
    home = "/Users/ryoppippi";
  };
}