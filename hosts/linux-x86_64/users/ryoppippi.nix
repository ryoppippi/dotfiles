# Home Manager configuration for ryoppippi on Linux x86_64
{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  username = config.home.username;
  homedir = "/home/${username}";
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
}
