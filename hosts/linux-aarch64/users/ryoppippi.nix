# Home Manager configuration for ryoppippi on Linux aarch64
{
  pkgs,
  lib,
  config,
  inputs,
  perSystem,
  ...
}:
let
  homedir = "/home/ryoppippi";
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";
  system = pkgs.stdenv.hostPlatform.system;
  helpers = import ../../../nix/modules/lib/helpers { inherit lib; };
  nodePackages = import ../../../nix/packages/node { inherit pkgs; };
in
{
  imports = [
    inputs.claude-code-overlay.homeManagerModules.default
    inputs.nix-index-database.hmModules.nix-index

    # Common home configuration
    (import ../../../nix/modules/home {
      inherit
        pkgs
        config
        lib
        dotfilesDir
        system
        helpers
        nodePackages
        homedir
        ;
      fish-na = inputs.fish-na;
    })

    # Linux-specific home configuration
    (import ../../../nix/modules/linux {
      inherit
        pkgs
        config
        lib
        helpers
        dotfilesDir
        homedir
        ;
    })
  ];

  home.username = "ryoppippi";
  home.homeDirectory = homedir;
}
