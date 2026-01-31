{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Linux-specific packages
    kanata
    ghostty

    # 1Password (on macOS, managed via nix-darwin programs._1password*)
    _1password-cli
    _1password-gui

    # Note: beekeeper-studio removed due to Electron EOL (insecure package)
    # On macOS, it's managed via Homebrew cask
  ];
}
