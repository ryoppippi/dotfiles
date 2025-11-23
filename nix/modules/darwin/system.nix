{
  pkgs,
  lib,
  username,
  homedir,
  ...
}:
let
  fishPath = "${pkgs.fish}/bin/fish";
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Disable nix-darwin's Nix management (using Determinate Nix)
  nix.enable = false;

  # Enable Touch ID for sudo (including tmux support via pam-reattach)
  security.pam.services.sudo_local.touchIdAuth = true;
  security.pam.services.sudo_local.reattach = true;

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

  # Font configuration
  fonts = {
    packages = with pkgs; [
      jetbrains-mono
      nerd-fonts.jetbrains-mono
      udev-gothic
      udev-gothic-nf
    ];
  };

  # macOS system defaults
  system.defaults = {
    # Dock settings
    dock = {
      autohide = true; # Automatically hide and show the Dock
      tilesize = 45; # Icon size
      persistent-apps = [ ]; # Remove all pinned applications
      show-recents = false; # Don't show recent applications
      mineffect = "scale"; # Minimise effect
      orientation = "bottom"; # Dock position
    };

    # Finder settings
    finder = {
      AppleShowAllExtensions = true; # Show all file extensions
      AppleShowAllFiles = true; # Show hidden files
      ShowPathbar = true; # Show path bar
      ShowStatusBar = true; # Show status bar
      FXEnableExtensionChangeWarning = false; # Disable extension change warning
      FXPreferredViewStyle = "Nlsv"; # List view by default
    };

    # Global macOS settings
    NSGlobalDomain = {
      # Appearance
      AppleInterfaceStyle = "Dark"; # Dark mode
      AppleShowAllExtensions = true; # Show all file extensions

      # Keyboard
      KeyRepeat = 2; # Fast key repeat (1-2 is very fast)
      InitialKeyRepeat = 25; # Initial key repeat delay

      # Disable auto-correct and substitutions
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;

      # Menu bar spacing (replaces Menu Bar Spacing app)
      NSStatusItemSpacing = 2; # Space between menu bar items
      NSStatusItemSelectionPadding = 2; # Padding for selected items
    };

    # Screenshot settings
    screencapture = {
      location = "~/Pictures/Screenshots";
      type = "png";
    };

    # Trackpad settings
    trackpad = {
      Clicking = true; # Tap to click
    };

    # Custom preferences for settings not available in system.defaults
    CustomUserPreferences = {
      "com.apple.AppleMultitouchTrackpad" = {
        # Click threshold: 0 = light, 1 = medium, 2 = firm
        FirstClickThreshold = 0;
        SecondClickThreshold = 0;
      };
    };
  };

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation.cleanup = "zap";

    taps = [ ];

    brews = [
      "bluetoothconnector"
      "leiningen"
      "mas"
      "screenresolution"
      "swift-sh"
      "switchaudio-osx"
    ];

    casks = [
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
      "visual-studio-code"
      "vlc"
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
      "Blackmagic Disk Speed Test" = 425264550;
      "Command X" = 6448461551;
      "Consent-O-Matic" = 1606897889;
      "CotEditor" = 1024640650;
      "DevCleaner" = 1388020431;
      "Document Generator" = 1437883178;
      "DuckDuckGo Privacy for Safari" = 1482920575;
      "Final Cut Pro" = 424389933;
      "FocusRecorder" = 6446467176;
      "Gifski" = 1351639930;
      "Hex Fiend" = 1342896380;
      "Hush" = 1544743900;
      "iHosts" = 1102004240;
      "Keepa - Price Tracker" = 1533805339;
      "Keynote" = 409183694;
      "Kindle" = 302584613;
      "LadioCast" = 411213048;
      "LanguageTranslator" = 1218781096;
      "Leftovers" = 6746164364;
      "LINE" = 539883307;
      "Messenger" = 1480068668;
      "Microsoft Excel" = 462058435;
      "Microsoft Remote Desktop" = 1295203466;
      "Microsoft Word" = 462054704;
      "NamingTranslator" = 1218784832;
      "Pages" = 409201541;
      "Refined GitHub" = 1519867270;
      "Screegle" = 1591051659;
      "Seashore" = 1448648921;
      "Sequel Ace" = 1518036000;
      "Shareful" = 1522267256;
      "Slack" = 803453959;
      "Spark" = 1176895641;
      "Speedtest" = 1153157709;
      "Squirrel" = 1669664068;
      "TabifyIndents" = 1179234554;
      "TestFlight" = 899247664;
      "The Unarchiver" = 425424353;
      "uBlacklist for Safari" = 1547912640;
      "Userscripts" = 1463298887;
      "Velja" = 1607635845;
      "WhatsApp" = 310633997;
      "Xcode" = 497799835;
    };
  };
}
