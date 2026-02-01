{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # macOS-specific packages
      ghostty-bin
      chafa
      blueutil
      bluetooth-connector
      switchaudio-osx
      terminal-notifier
      mas
      audio-priority-bar

      # macOS GUI applications (not available on Linux in nixpkgs)
      google-chrome
      cyberduck
      keycastr
      monitorcontrol
      obsidian
    ]
    # brew-nix packages (Homebrew casks managed via Nix)
    # Note: imageoptim excluded due to tar.xz extraction issues with brew-nix
    ++ (with pkgs.brewCasks; [
      alt-tab
      appcleaner
      beekeeper-studio
      bluesnooze
      chatgpt
      cursor
      deskpad
      figma
      glance-chamburr
      homerow
      istherenet
      kap
      maestral
      marta
      obs
      postman
      processing
      qlvideo
      raycast
      shottr
      signal
      stats
      vlc
      yaak
      zed
      zoom
    ])
    # brew-nix packages requiring hash override
    ++ [
      (pkgs.brewCasks.quitter.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-ZzxJmteqohGDVIQMTtGIoUuAHUp9vOX3tRg/sqsD1mk=";
        };
      }))
      (pkgs.brewCasks.suspicious-package.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-SJcXqQR/di3T8K3uNKv00QkLsmDGJNU9NQEIpDSqYJM=";
        };
      }))
    ];
}
