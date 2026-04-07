{ pkgs, lib, ... }:
let
  jsonFormat = pkgs.formats.json { };

  cmuxApp = pkgs.brewCasks.cmux.overrideAttrs (_: {
    meta.priority = 10;
  });

  cmuxCli = pkgs.runCommand "cmux-cli" { } ''
    mkdir -p $out/bin
    ln -s ${cmuxApp}/Applications/cmux.app/Contents/Resources/bin/cmux $out/bin/cmux
  '';

  cmuxSettings = {
    "$schema" =
      "https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux-settings.schema.json";
    schemaVersion = 1;

    app = {
      appearance = "dark";
      warnBeforeQuit = true;
      minimalMode = false;
    };

    automation = {
      claudeCodeIntegration = true;
    };

    notifications = {
      dockBadge = true;
      showInMenuBar = true;
      unreadPaneRing = true;
      paneFlash = true;
    };

    sidebar = {
      showPorts = true;
      showPullRequests = true;
      showProgress = true;
      showLog = true;
      showBranchDirectory = true;
      showSSH = true;
      branchLayout = "inline";
      openPullRequestLinksInCmuxBrowser = true;
      openPortLinksInCmuxBrowser = true;
    };

    sidebarAppearance = {
      matchTerminalBackground = true;
    };

    workspaceColors = {
      indicatorStyle = "washRail";
    };

    browser = {
      openTerminalLinksInCmuxBrowser = true;
      interceptTerminalOpenCommandInCmuxBrowser = true;
      defaultSearchEngine = "google";
      showSearchSuggestions = true;
    };

    shortcuts = {
      bindings = {
        focusLeft = "cmd+shift+h";
        focusDown = "cmd+shift+j";
        focusUp = "cmd+shift+k";
        focusRight = "cmd+shift+l";
        toggleSplitZoom = "cmd+z";
        goToWorkspace = "cmd+s";

        nextSidebarTab = "cmd+shift+f";
        prevSidebarTab = "cmd+shift+b";

        focusBrowserAddressBar = "cmd+l";
        openBrowser = "cmd+shift+o";
      };
    };
  };
in
{
  home.packages = lib.mkIf pkgs.stdenv.isDarwin [
    cmuxApp
    cmuxCli
  ];

  xdg.configFile."cmux/settings.json" = {
    source = jsonFormat.generate "cmux-settings.json" cmuxSettings;
    force = true;
  };
}
