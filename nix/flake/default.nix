{ inputs, lib, ... }:
let
  constants = import ./constants.nix { inherit lib; };
in
{
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.git-hooks.flakeModule

    ./pkgs.nix
    ./formatter.nix
    ./apps
    ./hosts
  ];

  systems = [
    "aarch64-darwin"
    "x86_64-linux"
    "aarch64-linux"
  ];

  _module.args = { inherit constants; };

  perSystem =
    { pkgs, ... }:
    {
      _module.args = { inherit constants; };

      # Expose custom overlay packages as flake outputs so nix-update --flake
      # can target them (e.g. `nix-update --flake git-now`).
      packages = {
        inherit (pkgs)
          git-now
          roots
          gh-user-stars
          gh-triage
          ;
      };
    };
}
