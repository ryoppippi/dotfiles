{
  pkgs,
  lib,
  ...
}:
let
  # Read the YAML config file from the same directory (relative path for pure eval)
  lazygitConfigYaml = builtins.readFile ./config.yml;

  # Replace the hardcoded 'delta' with the full Nix store path
  # This ensures lazygit uses the Nix-managed delta binary
  lazygitConfigWithDeltaPath =
    builtins.replaceStrings [ "pager: delta " ] [ "pager: ${lib.getExe pkgs.delta} " ]
      lazygitConfigYaml;
in
{
  # lazygit package is installed via packages.nix
  # We only manage the config file here with custom delta path substitution
  xdg.configFile."lazygit/config.yml" = {
    text = lazygitConfigWithDeltaPath;
  };
}
