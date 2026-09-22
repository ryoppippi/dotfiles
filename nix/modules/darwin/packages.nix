{ pkgs, ... }:
let
  mkLoginAgent = package: appName: {
    enable = true;
    config = {
      ProgramArguments = [
        "${package}/Applications/${appName}.app/Contents/MacOS/${appName}"
      ];
      ProcessType = "Interactive";
      RunAtLoad = true;
    };
  };
in
{
  # macOS-specific Nix packages (home-manager)
  home.packages =
    with pkgs;
    [
      # CLI tools
      blueutil
      audio-priority-bar
      xcodes

      # GUI applications (available in nixpkgs)
      cyberduck
      keycastr
      obsidian
    ]
    # brew-nix packages (Homebrew casks managed via Nix)
    ++ (with pkgs.brewCasks; [
      appcleaner
      beekeeper-studio
      betterdisplay
      cursor
      dockdoor
      figma
      istherenet
      maestral
      obs
      signal
      vlc
      zed
      zoom
    ])
    # brew-nix packages requiring overrides
    ++ [
      (pkgs.brewCasks.suspicious-package.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-y+F7GhwdYTfo82RDYihjdzcJ1BXAruxo5Bspzj+tKX8=";
        };
      }))
    ];

  launchd.agents = {
    is-there-net = mkLoginAgent pkgs.brewCasks.istherenet "IsThereNet";
  };

}
