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
      tailscale

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
      cursor
      dockdoor
      figma
      istherenet
      maestral
      obs
      signal
      stats
      vlc
      zed
      zoom
    ])
    # brew-nix packages requiring overrides
    ++ [
      (pkgs.brewCasks.suspicious-package.overrideAttrs (oldAttrs: {
        src = pkgs.fetchurl {
          url = builtins.head oldAttrs.src.urls;
          hash = "sha256-m80cgWlFj6TjcMHy6mwvmOzW26/pz6cfn84DKg0bV7w=";
        };
      }))
    ];

  launchd.agents = {
    bluesnooze = mkLoginAgent pkgs.brewCasks.bluesnooze "Bluesnooze";
    is-there-net = mkLoginAgent pkgs.brewCasks.istherenet "IsThereNet";
    stats = mkLoginAgent pkgs.brewCasks.stats "Stats";
  };

}
