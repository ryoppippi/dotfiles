{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # macOS-specific packages
    ghostty-bin
    chafa
    blueutil
    switchaudio-osx
    terminal-notifier
    mas
  ];
}
