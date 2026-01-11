# Home Manager configuration for ryoppippi on darwin
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  username = config.home.username;
  homedir = "/Users/${username}";
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";
  system = pkgs.stdenv.hostPlatform.system;
  helpers = import ../../../modules/lib/helpers { inherit lib; };
  nodePackages = import ../../../nix/packages/node { inherit pkgs; };
in
{
  imports = [
    inputs.claude-code-overlay.homeManagerModules.default

    # Common home configuration
    (import ../../../modules/home {
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
    (import ../../../modules/darwin {
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
}
