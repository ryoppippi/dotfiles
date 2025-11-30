{ lib }:
{
  # User configuration (requires config to be passed)
  mkUser = config: import ./user.nix { inherit config; };
}
