{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Linux-specific packages
    ghostty

    # 1Password (on macOS, managed via nix-darwin programs._1password*)
    _1password-cli
    _1password-gui
  ];
}
