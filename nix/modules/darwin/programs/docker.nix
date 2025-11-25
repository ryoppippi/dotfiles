{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Docker configuration for macOS (OrbStack)
  home.file.".docker/config.json".text = builtins.toJSON {
    auths = { };
    credsStore = "osxkeychain";
    currentContext = "orbstack";
    experimental = "enabled";
    stackOrchestrator = "swarm";
  };
}
