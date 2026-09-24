{
  pkgs,
  omniwmLib,
  ...
}:
let
  # Chat and dictionary applications open narrow beside whatever has focus.
  narrowCompanion = {
    initialContainerPrimarySpan = 0.2;
    minHeight = 200.0;
    minWidth = 320.0;
  };
in
{
  programs.omniwm = {
    enable = true;
    package = pkgs.omniwm;
    launchd.enable = true;
    # The module's default lets a deliberate quit stick. OmniWM is load bearing
    # for every window shortcut here, so restart it unconditionally.
    launchd.keepAlive = true;

    # Keyed by display UUID, and the external display differs between home and
    # the office, so these belong to the machine rather than this repository.
    # `routing` is the whole table: the arrangement map and the mode selecting it.
    preserveSettings = [
      "monitorBarOverrides"
      "monitorDwindleOverrides"
      "monitorGapOverrides"
      "monitorNiriOverrides"
      "monitorOrientationOverrides"
      "routing"
    ];

    # Only the settings that differ from the packaged OmniWM version's own
    # defaults; the module merges them over the full schema. The keys OmniWM
    # derives from the hardware — the monitor overrides and the routing map —
    # are deliberately absent, because preserveSettings carries them over
    # instead. See the README for why they cannot be committed.
    settings = {
      appearance.mode = "automatic";
      borders.enabled = false;

      focus = {
        followsMouse = true;
        followsWindowToMonitor = true;
        raiseOnMouseFocus = true;
      };

      # omniwmctl drives the Karabiner rules that cross a display boundary.
      general.ipcEnabled = true;

      # Four-finger horizontal swipes switch workspaces. macOS' own four-finger
      # gestures are disabled in system.nix so Spaces cannot intercept them.
      gestures = {
        workspaceSwipeEnabled = true;
        workspaceSwipeAxis = "horizontal";
        workspaceSwipeFingerCount = 4;
      };

      niri = {
        centerFocusedColumn = "onOverflow";
        # The extra 0.25 preset is the width the chat applications start at.
        containerPrimarySpanPresets = [
          0.25
          0.3333333333333333
          0.5
          0.6666666666666666
        ];
        infiniteLoop = true;
        visibleContainerCount = 3;
      };

      overview.backdrop.alpha = 1.0;

      # Ghostty is the terminal here, launched by cmux rather than by OmniWM.
      quakeTerminal.enabled = false;

      statusBar = {
        showAppNames = true;
        useWorkspaceId = true;
      };

      workspaceBar = {
        # Menu-bar-only applications own no window, so their icons would sit in
        # the bar permanently.
        excludedBundleIDs = [
          "com.1password.1password"
          "com.apple.ActivityMonitor"
          "com.apple.Passwords"
          "com.apple.ScreenContinuity"
          "jp.kiok.nani"
          "pl.maketheweb.cleanshotx"
        ];
        hideInNativeFullscreen = true;
      };

      # Workspaces 1 and 2 follow the main display and 3 and 4 the first
      # non-main one. Using `main`/`secondary` rather than a specific display
      # means replacing the external monitor needs no change here, and keeps
      # opening the lid from pulling workspace 2 onto the built-in display.
      workspaces = omniwmLib.workspaces [
        { }
        { }
        { monitorAssignment.type = "secondary"; }
        { monitorAssignment.type = "secondary"; }
      ];

      appRules = [
        (omniwmLib.appRule "com.openai.codex" {
          minHeight = 400.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "com.cmuxterm.app" {
          assignToWorkspace = "2";
          initialContainerPrimarySpan = 1.0;
          minHeight = 400.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "com.eltima.cmd1.pro.mas" {
          minHeight = 550.0;
          minWidth = 950.0;
        })
        (omniwmLib.appRule "com.google.Chrome" {
          minHeight = 375.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "dev.zed.Zed" {
          minHeight = 240.0;
          minWidth = 360.0;
        })
        (omniwmLib.appRule "com.apple.Safari" {
          minHeight = 220.0;
          minWidth = 574.0;
        })
        (omniwmLib.appRule "app.zen-browser.zen" {
          minHeight = 495.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "org.mozilla.firefox" {
          minHeight = 120.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "company.thebrowser.dia" {
          minHeight = 420.0;
          minWidth = 500.0;
        })
        (omniwmLib.appRule "com.spotify.client" {
          minHeight = 600.0;
          minWidth = 800.0;
        })
        (omniwmLib.appRule "com.hnc.Discord" {
          initialContainerPrimarySpan = 0.25;
          minHeight = 200.0;
          minWidth = 320.0;
        })
        (omniwmLib.appRule "com.mitchellh.ghostty" {
          minHeight = 48.0;
          minWidth = 90.0;
        })
        (omniwmLib.appRule "com.microsoft.Outlook" {
          minHeight = 650.0;
          minWidth = 930.0;
        })
        (omniwmLib.appRule "com.apple.MobileSMS" narrowCompanion)
        (omniwmLib.appRule "jp.naver.line.mac" narrowCompanion)
        (omniwmLib.appRule "com.tinyspeck.slackmacgap" (narrowCompanion // { minHeight = 600.0; }))
        (omniwmLib.appRule "com.apple.Dictionary" narrowCompanion)
      ];

      # Everything within one workspace lives on Hyper. Everything that crosses
      # a workspace or display boundary lives on Ctrl in karabiner.ts, or on the
      # Option+Command+Shift bindings below that the CLAW44's Workspace layer
      # and karabiner.ts both reach. The README maps each to physical keys.
      hotkeys = omniwmLib.hotkeys {
        "focus.left" = "Hyper+H";
        "focus.down" = "Hyper+J";
        "focus.up" = "Hyper+K";
        "focus.right" = "Hyper+L";
        "focusPrevious" = "Hyper+Tab";

        "move.left" = "Hyper+N";
        "move.right" = "Hyper+M";
        "moveColumn.left" = "Hyper+Left Arrow";
        "moveColumn.right" = "Hyper+Right Arrow";
        "moveWindowDown" = "Hyper+Down Arrow";
        "moveWindowUp" = "Hyper+Up Arrow";

        "setContainerPrimarySpan.decrease10Percent" = "Hyper+Y";
        "setContainerPrimarySpan.increase10Percent" = "Hyper+O";
        "setWindowSecondarySpan.decrease10Percent" = "Hyper+U";
        "setWindowSecondarySpan.increase10Percent" = "Hyper+I";
        "resetWindowSecondarySpan" = "Hyper+R";
        "toggleContainerFullPrimarySpan" = "Hyper+F";
        "toggleColumnTabbed" = "Hyper+T";
        "toggleFocusedWindowFloating" = "Hyper+D";
        "openCommandPalette" = "Hyper+Space";

        "moveToWorkspace.1" = "Option+Command+Shift+Up Arrow";
        "moveToWorkspace.3" = "Option+Command+Shift+Down Arrow";
        "moveWindowToWorkspaceUp" = "Option+Command+Shift+Left Arrow";
        "moveWindowToWorkspaceDown" = "Option+Command+Shift+Right Arrow";
        "workspaceBackAndForth" = "Option+Command+Shift+Tab";
        "toggleOverview" = "Option+Command+Shift+Space";
      };
    };
  };
}
