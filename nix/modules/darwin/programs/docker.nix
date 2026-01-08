{
  pkgs,
  ...
}:
let
  jsonFormat = pkgs.formats.json { };

  settings = {
    auths = { };
    credsStore = "osxkeychain";
    currentContext = "orbstack";
    experimental = "enabled";
    stackOrchestrator = "swarm";
  };
in
{
  # Docker configuration for macOS (OrbStack) - prettified
  home.file.".docker/config.json".source = jsonFormat.generate "config.json" settings;
}
