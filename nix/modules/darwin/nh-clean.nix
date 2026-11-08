{
  config,
  lib,
  pkgs,
  ...
}:
let
  # Only root can delete the system profile's generations, which are what
  # actually fill the store; `nh clean user` from home-manager never touches
  # them. launchd cannot gate a job on power source, so this checks hourly and
  # runs at most once a day, on the first check made on AC power.
  nhClean = pkgs.writers.writeNu "nh-clean" ''
    const stamp = '/var/db/nh-clean.stamp'

    def on-ac-power []: nothing -> bool {
        ^/usr/bin/pmset -g ps | lines | first | str contains "'AC Power'"
    }

    def ran-recently []: nothing -> bool {
        ($stamp | path exists) and ((date now) - (ls $stamp | get 0.modified) < 20hr)
    }

    def main [] {
        if not (on-ac-power) or (ran-recently) { return }
        ^/usr/bin/caffeinate -i ${lib.getExe pkgs.nh} clean all --keep-since 7d --keep 3 --optimise
        touch $stamp
    }
  '';
in
{
  launchd.daemons.nh-clean.serviceConfig = {
    ProgramArguments = [ "${nhClean}" ];
    EnvironmentVariables.PATH = "${config.nix.package}/bin:/usr/bin:/bin";
    StartInterval = 3600;
    StandardOutPath = "/var/log/nh-clean.log";
    StandardErrorPath = "/var/log/nh-clean.log";
    LowPriorityIO = true;
    ProcessType = "Background";
  };
}
