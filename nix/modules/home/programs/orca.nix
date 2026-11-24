{ pkgs, lib, ... }:
let
  telemetryEnv = {
    ORCA_TELEMETRY_DISABLED = "1";
    DO_NOT_TRACK = "1";
  };
in
{
  home.sessionVariables = telemetryEnv;

  # Apps launched from the Dock do not inherit shell session variables, and
  # Orca decides telemetry consent from its own environment.
  launchd.agents.orca-env = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        (lib.concatStringsSep "; " (
          lib.mapAttrsToList (name: value: "/bin/launchctl setenv ${name} ${value}") telemetryEnv
        ))
      ];
      RunAtLoad = true;
    };
  };
}
