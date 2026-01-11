# Home Manager configuration for ryoppippi on darwin
{
  pkgs,
  lib,
  config,
  inputs,
  perSystem,
  ...
}:
let
  homedir = "/Users/ryoppippi";
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";
  system = pkgs.stdenv.hostPlatform.system;
  helpers = import ../../../nix/modules/lib/helpers { inherit lib; };
  nodePackages = import ../../../nix/packages/node { inherit pkgs; };
in
{
  imports = [
    inputs.claude-code-overlay.homeManagerModules.default

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

    # Darwin-specific home configuration
    (import ../../../nix/modules/darwin {
      inherit
        pkgs
        config
        lib
        helpers
        homedir
        dotfilesDir
        ;
    })
  ];

  home.username = "ryoppippi";
  home.homeDirectory = homedir;
}
