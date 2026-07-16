{
  pkgs,
  lib,
  username,
  homedir,
  ...
}:
let
  fishPath = lib.getExe pkgs.fish;
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # nix-darwin's HTML manual builder passes `--sidebar-depth` to
  # `nixos-render-docs manual html`, but the current nixpkgs revision ships a
  # `nixos-render-docs` that rejects that flag, so `darwin-manual-html` fails
  # to build. This is an upstream incompatibility (present even on nix-darwin
  # HEAD). Man pages use a different, working subcommand, so keep those and
  # only drop the HTML manual (`documentation.doc`). The uninstaller
  # internally re-evaluates a full darwin system with default options, which
  # rebuilds the broken manual, so disable it too.
  documentation.doc.enable = false;
  system.tools.darwin-uninstaller.enable = false;

  nix = {
    settings = {
      extra-experimental-features = [
        "nix-command"
        "flakes"
      ];
      always-allow-substitutes = true;
      bash-prompt-prefix = "(nix:$name) ";
      max-jobs = "auto";
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      trusted-users = [
        "root"
        username
      ];
    };
  };

  security.pam.services.sudo_local.text = ''
    auth       optional       ${pkgs.pam-reattach}/lib/pam/pam_reattach.so
    auth       sufficient     pam_tid.so
    auth       sufficient     ${pkgs.pam-watchid}/lib/pam_watchid.so
  '';

  system = {
    # Set system state version
    stateVersion = 5;

    # Set primary user for homebrew
    primaryUser = username;

    activationScripts.homebrew.text = lib.mkBefore ''
      if ! /usr/sbin/pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto >/dev/null 2>&1; then
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
      fi

      xcodebuild=/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild
      if [ -x "$xcodebuild" ] && ! "$xcodebuild" -license check >/dev/null 2>&1; then
        "$xcodebuild" -license accept
      fi

      if [ -t 0 ]; then
        /usr/bin/sudo --user=${username} --set-home /usr/bin/sudo --validate
      fi
    '';

    # Set user shell on activation
    activationScripts.postActivation.text = ''
      echo "Setting login shell to fish..."
      sudo chsh -s ${fishPath} ${username} || true

      # Remove quarantine attribute from Arto.app (third-party tap)
      if [ -e "/Applications/Arto.app" ]; then
        echo "Removing quarantine from Arto.app..."
        xattr -dr com.apple.quarantine /Applications/Arto.app 2>/dev/null || true
      fi
    '';

    # macOS system defaults
    defaults = {
      # Dock settings
      dock = {
        autohide = true; # Automatically hide and show the Dock
        launchanim = true;
        magnification = false;
        tilesize = 45; # Icon size
        persistent-apps = [ ]; # Remove all pinned applications
        persistent-others = [
          {
            folder = {
              path = "${homedir}/Dropbox/Screenshots";
              arrangement = "date-added";
              showas = "fan";
            };
          }
          {
            folder = {
              path = "${homedir}/Dropbox/Downloads";
              arrangement = "date-added";
              showas = "fan";
            };
          }
        ];
        show-recents = false; # Don't show recent applications
        show-process-indicators = true;
        mineffect = "genie";
        orientation = "bottom"; # Dock position
        showAppExposeGestureEnabled = true;
        showDesktopGestureEnabled = true;
        showMissionControlGestureEnabled = true;
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
        AppleShowScrollBars = "Automatic";
        AppleScrollerPagingBehavior = false;
        NSTableViewDefaultSizeMode = 2;

        # Keyboard
        ApplePressAndHoldEnabled = true;
        KeyRepeat = 2; # Fast key repeat (1-2 is very fast)
        InitialKeyRepeat = 25; # Initial key repeat delay

        # Trackpad speed (0.0 = slowest, 3.0 = fastest)
        AppleEnableSwipeNavigateWithScrolls = true;
        "com.apple.swipescrolldirection" = true;
        "com.apple.trackpad.forceClick" = true;
        "com.apple.trackpad.scaling" = 1.3;

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

      screensaver = {
        askForPassword = true;
        askForPasswordDelay = 0;
      };

      # Trackpad settings
      trackpad = {
        Clicking = false;
        ActuationStrength = 1;
        ActuateDetents = true;
        FirstClickThreshold = 0;
        ForceSuppressed = false;
        SecondClickThreshold = 0;
        TrackpadFourFingerHorizSwipeGesture = 2;
        TrackpadFourFingerPinchGesture = 2;
        TrackpadFourFingerVertSwipeGesture = 2;
        TrackpadPinch = true;
        TrackpadRightClick = true;
        TrackpadRotate = true;
        TrackpadThreeFingerDrag = false;
        TrackpadThreeFingerHorizSwipeGesture = 2;
        TrackpadThreeFingerTapGesture = 0;
        TrackpadThreeFingerVertSwipeGesture = 2;
        TrackpadTwoFingerDoubleTapGesture = true;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
      };

      # Custom preferences for settings not available in system.defaults
      CustomUserPreferences = {
        NSGlobalDomain = {
          AppleAccentColor = -1;
          AppleReduceDesktopTinting = false;
        };
        "com.apple.WindowManager" = {
          EnableStandardClickToShowDesktop = false;
          EnableTilingByEdge = false;
          EnableTopTilingByEdge = false;
          EnableTilingOptionAccelerator = false;
          EnableTiledWindowMargins = false;
          GloballyEnabled = false;
          StageManagerHideDesktopIcons = true;
          StageManagerHideWidgets = true;
          StandardHideDesktopIcons = true;
          StandardHideWidgets = true;
        };
        "com.apple.dock" = {
          appswitcher-all-displays = true; # Show app switcher on all displays
          wvous-br-corner = 1;
        };
      };
    };
  };

  # Define user
  users.users.${username} = {
    home = homedir;
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };

  # Add fish to system shells
  environment.shells = [ pkgs.fish ];

  # Font configuration
  fonts = {
    packages = with pkgs; [
      udev-gothic
      udev-gothic-nf
    ];
  };

  programs = {
    # 1Password CLI (GUI is managed via Homebrew cask - requires /Applications)
    _1password.enable = true;

    # nix-index for command-not-found and comma
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
  };

  # Homebrew configuration
  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "uninstall";
    };

    taps = [
      "arto-app/tap"
      "typewhisper/tap"
    ];

    brews = [
      "mas"
    ];

    casks = [
      "1password"
      "alfred"
      "arc"
      "arto-app/tap/arto"
      "audacity"
      "blackhole-16ch"
      "blu-ray-player-pro"
      "cleanshot"
      "claude"
      "codex-app"
      "cotypist"
      "cmux"
      "cloudflare-warp"
      "discord"
      "google-chrome"
      "google-drive"
      "karabiner-elements"
      "ollama-app"
      "openvpn-connect"
      "orbstack"
      "raycast"
      "secretive"
      "steam"
      "telegram"
      "typewhisper/tap/typewhisper"
    ];

    masApps = {
      "Accelerate" = 1459809092;
      "Actions" = 1586435171;
      "AdGuard for Safari" = 1440147259;
      "Amphetamine" = 937984704;
      "Blackmagic Disk Speed Test" = 425264550;
      "Command X" = 6448461551;
      "Consent-O-Matic" = 1606897889;
      "DevCleaner" = 1388020431;
      "Document Generator" = 1437883178;
      "Gifski" = 1351639930;
      "Hush" = 1544743900;
      "Keepa - Price Tracker" = 1533805339;
      "Keynote" = 361285480;
      "Kindle" = 302584613;
      "LINE" = 539883307;
      "LanguageTranslator" = 1218781096;
      "Microsoft Remote Desktop" = 1295203466;
      "NamingTranslator" = 1218784832;
      "Pages" = 361309726;
      "Refined GitHub" = 1519867270;
      "Shareful" = 1522267256;
      "Slack" = 803453959;
      "Spark" = 1176895641;
      "TabifyIndents" = 1179234554;
      "TestFlight" = 899247664;
      "The Unarchiver" = 425424353;
      "Userscripts" = 1463298887;
      "Velja" = 1607635845;
      "WhatsApp" = 310633997;
      "Xcode" = 497799835;
      "uBlacklist for Safari" = 1547912640;
    };
  };
}
