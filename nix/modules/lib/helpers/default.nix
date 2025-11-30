{ lib }:
{
  # Re-export all helper modules
  activation = import ./activation.nix { inherit lib; };

  # User configuration (requires config to be passed)
  mkUser = config: import ./user.nix { inherit config; };
}
