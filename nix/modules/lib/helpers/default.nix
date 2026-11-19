{ lib }:
{
  # Re-export all helper modules
  activation = import ./activation.nix { inherit lib; };

  trashCommand =
    pkgs: if pkgs.stdenv.hostPlatform.isDarwin then "/usr/bin/trash" else lib.getExe pkgs.trash-cli;

  # User configuration (requires config to be passed)
  mkUser = config: import ./user.nix { inherit config; };
}
