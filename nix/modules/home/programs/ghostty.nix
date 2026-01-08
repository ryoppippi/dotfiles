{
  pkgs,
  lib,
  ...
}:
let
  ghosttySettings = {
    font-family = "UDEV Gothic 35LG";
    font-size = 13;
    font-feature = [ "-dlig" ];

    background-opacity = 0.70;
    background-blur-radius = 20;

    theme = "Kanagawa Dragon";

    shell-integration = "fish";
    shell-integration-features = "no-cursor";

    cursor-style = "block";
    cursor-style-blink = false;

    mouse-hide-while-typing = true;

    working-directory = "inherit";
  };
in
{
  # Ghostty terminal configuration
  # On macOS, Ghostty is installed via Homebrew, so we use xdg.configFile directly
  # On Linux, we use the full programs.ghostty module with pkgs.ghostty
  programs.ghostty = lib.mkIf (!pkgs.stdenv.isDarwin) {
    enable = true;
    package = pkgs.ghostty;
    enableFishIntegration = true;
    settings = ghosttySettings;
  };

  # On macOS, just generate the config file (Ghostty installed via Homebrew)
  xdg.configFile."ghostty/config" = lib.mkIf pkgs.stdenv.isDarwin {
    text = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        name: value:
        if builtins.isList value then
          lib.concatMapStringsSep "\n" (v: "${name} = ${toString v}") value
        else if builtins.isBool value then
          "${name} = ${if value then "true" else "false"}"
        else
          "${name} = ${toString value}"
      ) ghosttySettings
    );
  };
}
