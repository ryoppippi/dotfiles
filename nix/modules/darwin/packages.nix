{ pkgs, ... }:
{
  # macOS-specific Nix packages (home-manager)
  home.packages =
    with pkgs;
    [
      # CLI tools
      chafa
      blueutil
      bluetooth-connector
      switchaudio-osx
      terminal-notifier
      mas
      audio-priority-bar

      # GUI applications (available in nixpkgs)
      cyberduck
      keycastr
      obsidian
    ]
    # brew-nix packages (Homebrew casks managed via Nix)
    ++ (with pkgs.brewCasks; [
      alt-tab
      appcleaner
      beekeeper-studio
      betterdisplay
      bluesnooze
      chatgpt
      cursor
      deskpad
      figma
      glance-chamburr
      homerow
      istherenet
      maestral
      marta
      obs
      signal
      stats
      vlc
      yaak
      zed
      zoom
    ])
    # brew-nix packages requiring overrides
    ++ [
      (pkgs.brewCasks.imageoptim.overrideAttrs (o: {
        nativeBuildInputs = o.nativeBuildInputs ++ [
          pkgs.gnutar
          pkgs.xz
        ];
        unpackPhase = "tar -xf $src";
      }))
      (pkgs.brewCasks.quitter.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-ZzxJmteqohGDVIQMTtGIoUuAHUp9vOX3tRg/sqsD1mk=";
        };
      }))
      (pkgs.brewCasks.suspicious-package.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-J7WsseJWcrWK9ztLF7FZwtqkqFIxtmqG01ps7+jLVWE=";
        };
      }))
    ];

}
