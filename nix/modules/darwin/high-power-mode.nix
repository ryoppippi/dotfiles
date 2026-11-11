{ pkgs, ... }:
let
  # Energy Mode is High Power only while plugged in with charge to spare, and
  # Automatic otherwise, so a nearly flat battery charges at full speed rather
  # than feeding the extra draw. pmset cannot condition on charge level, so
  # this follows both the power source and the level.
  minBatteryPercent = 20;

  highPowerMode = pkgs.writers.writeNu "high-power-mode" ''
    const min_battery = ${toString minBatteryPercent}

    def on-ac-power []: nothing -> bool {
        ^/usr/bin/pmset -g ps | lines | first | str contains "'AC Power'"
    }

    def battery-percent []: nothing -> int {
        ^/usr/bin/pmset -g batt
        | parse --regex '(?<percent>\d+)%'
        | get percent.0?
        | default '100'
        | into int
    }

    def current-mode []: nothing -> int {
        ^/usr/bin/pmset -g | parse --regex 'powermode\s+(?<value>\d)' | get 0.value | into int
    }

    def main [] {
        let wanted = if (on-ac-power) and (battery-percent) >= $min_battery { 2 } else { 0 }
        if $wanted != (current-mode) {
            ^/usr/bin/pmset -a powermode $wanted
        }
    }
  '';
in
{
  launchd.daemons.high-power-mode.serviceConfig = {
    ProgramArguments = [ "${highPowerMode}" ];
    LaunchEvents."com.apple.notifyd.matching".power-source.Notification =
      "com.apple.system.powersources.source";
    RunAtLoad = true;
    StartInterval = 60;
    StandardOutPath = "/var/log/high-power-mode.log";
    StandardErrorPath = "/var/log/high-power-mode.log";
    ProcessType = "Background";
  };
}
