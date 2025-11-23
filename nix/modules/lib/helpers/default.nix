{ lib }:
{
  # Re-export all helper modules
  activation = import ./activation.nix { inherit lib; };
}
