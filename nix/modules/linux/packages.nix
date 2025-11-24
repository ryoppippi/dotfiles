{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Linux-specific packages
    ghostty
    # Password managers
    _1password-gui
  ];
}
