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

    # macOS GUI applications (not available on Linux in nixpkgs)
    cyberduck
    keycastr
    monitorcontrol
    obsidian
    raycast
  ];
}
