{ pkgs, ... }:
let
  jsonFormat = pkgs.formats.json { };

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

    shortcuts = {
      bindings = {
        focusLeft = "cmd+h";
        focusDown = "cmd+j";
        focusUp = "cmd+k";
        focusRight = "cmd+l";
        toggleSplitZoom = "cmd+z";
        goToWorkspace = "cmd+s";
        nextSidebarTab = "cmd+shift+n";
        prevSidebarTab = "cmd+shift+p";
      };
    };
  };
in
{
  xdg.configFile."cmux/settings.json" = {
    source = jsonFormat.generate "cmux-settings.json" cmuxSettings;
    force = true;
  };
}
