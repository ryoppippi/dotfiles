{
  pkgs,
  lib,
  config,
  ...
}:
{
  # Ghostty terminal configuration
  # Using Home Manager programs.ghostty module
  # On macOS, Ghostty is installed via Homebrew
  # On Linux, it can be installed via Nix (pkgs.ghostty)
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.isDarwin then pkgs.emptyDirectory else pkgs.ghostty; # Homebrew on macOS, Nix on Linux
    enableFishIntegration = !pkgs.stdenv.isDarwin; # Disable on macOS since package is emptyDirectory
    settings = {
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
  };
}
