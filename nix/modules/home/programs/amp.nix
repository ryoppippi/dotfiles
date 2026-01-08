{
  pkgs,
  config,
  ...
}:
let
  # Amp configuration documentation: https://ampcode.com/manual#configuration
  ampConfigDir = "${config.xdg.configHome}/amp";

  jsonFormat = pkgs.formats.json { };

  settings = {
    amp = {
      git = {
        commit = {
          coauthor = {
            enabled = true;
          };
          ampThread = {
            enabled = true;
          };
        };
      };
      todos = {
        enabled = true;
      };
      tab = {
        clipboard = {
          enabled = true;
        };
      };
      updates = {
        mode = "disabled";
      };
    };
  };
in
{
  home.packages = [ pkgs.amp ];

  home.file = {
    "${ampConfigDir}/settings.json".source = jsonFormat.generate "amp-settings" settings;
  };
}
