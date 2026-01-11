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
  programs.lazygit = {
    enable = true;
  };

  # Override the generated config with our YAML (schema + delta path replaced)
  xdg.configFile."lazygit/config.yml" = {
    text = lazygitConfigWithDeltaPath;
  };
}
