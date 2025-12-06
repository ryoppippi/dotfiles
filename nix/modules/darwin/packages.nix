{ pkgs, ... }:
{
  home.packages =
    with pkgs;
    [
      # macOS-specific packages
      ghostty-bin
      chafa
      blueutil
      switchaudio-osx
      terminal-notifier
      mas

      # macOS GUI applications (not available on Linux in nixpkgs)
      arto
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
      deskpad
      figma
      glance-chamburr
      hammerspoon
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
