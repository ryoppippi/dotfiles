# docs
# https://cmux.com/docs/configuration

{
  pkgs,
  lib,
  config,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };
  cmuxCli = "/Applications/cmux.app/Contents/Resources/bin/cmux";

  cmuxSettings = {
    "$schema" = "https://raw.githubusercontent.com/manaflow-ai/cmux/main/web/data/cmux.schema.json";
    schemaVersion = 1;

    app = {
      appearance = "dark";
      warnBeforeQuit = true;
      minimalMode = false;
      reorderOnNotification = false;
    };

    automation = {
      claudeCodeIntegration = true;
      socketControlMode = "full";
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
        # cmux binds clearScreenKeepScrollback to cmd+shift+k by default,
        # which shadows focusUp above
        clearScreenKeepScrollback = "none";
        toggleSplitZoom = "cmd+z";
        goToWorkspace = "cmd+s";

        nextSidebarTab = "cmd+shift+f";
        prevSidebarTab = "cmd+shift+b";

        focusBrowserAddressBar = "cmd+l";
        openBrowser = "cmd+shift+o";

        triggerFlash = "cmd+ctrl+h";
      };
    };
  };
in
{
  xdg.configFile."cmux/cmux.json" = {
    source = jsonFormat.generate "cmux.json" cmuxSettings;
    force = true;
  };

  home.activation.installCmuxHooks = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.hm.dag.entryAfter [ "writeBoundary" "writeCodexConfig" ] ''
      # Activation runs without the user profile on PATH, so cmux would skip
      # every agent it cannot resolve there. It also lacks the socket path that
      # cmux exports into its terminals, which grok's install needs to reach
      # the running app.
      PATH="${config.home.path}/bin:$PATH" \
        CMUX_SOCKET_PATH="''${CMUX_SOCKET_PATH:-${config.xdg.stateHome}/cmux/cmux.sock}" \
        ${cmuxCli} hooks setup -y
    ''
  );
}
