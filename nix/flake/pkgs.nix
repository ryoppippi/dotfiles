{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      # Overriding the `pkgs` module argument means every `perSystem` module —
      # including treefmt-nix and git-hooks — sees the overlaid package set.
      _module.args.pkgs = import ../pkgs.nix { inherit inputs system; };
    };
}
