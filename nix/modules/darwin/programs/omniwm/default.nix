{
  lib,
  pkgs,
  ...
}:
let
  nu = lib.getExe pkgs.nushell;
in
{
  programs.omniwm = {
    enable = true;
    launchd = {
      enable = true;
      keepAlive = true;
    };
  };

  # merge-settings.nu explains why this is a merge rather than a copy: the
  # monitor settings in the live file are keyed by display UUID and belong to
  # the machine, not to this repository.
  home.activation.writeOmniWMSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${nu} ${./merge-settings.nu} ${./settings.toml} "$HOME/.config/omniwm/settings.toml"
  '';
}
