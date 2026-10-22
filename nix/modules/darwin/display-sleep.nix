{ pkgs, ... }:
let
  # The Mac stays awake on AC (system.nix), but the display should still go
  # dark — and so lock, as the screensaver asks for the password immediately.
  # Apps keep it lit with display-sleep assertions that outlive any real use:
  # audio streams left open to a monitor's speakers hold coreaudiod's for days,
  # and Electron apps hold Blink wake locks for hours. displaysleepnow is not
  # subject to assertions, so this applies the idle timeout itself.
  enforceDisplaySleep = pkgs.writers.writeNu "enforce-display-sleep" ''
    # Seconds since the last real keyboard or pointer input
    def idle-seconds []: nothing -> int {
        ^/usr/sbin/ioreg -c IOHIDSystem -d 4
        | parse --regex '"HIDIdleTime" = (?<ns>\d+)'
        | get 0.ns
        | into int
        | $in // 1_000_000_000
    }

    # The idle timeout pmset applies on the current power source, in seconds
    def display-sleep-seconds []: nothing -> int {
        ^/usr/bin/pmset -g
        | parse --regex '(?m)^\s*displaysleep\s+(?<minutes>\d+)'
        | get 0.minutes
        | into int
        | $in * 60
    }

    # Someone watching a video, sitting in a call, or presenting is idle on
    # purpose. These apps release their assertion when that ends — Zoom holds
    # "Describe Activity Type" only for the length of a meeting — unlike the
    # stale ones this agent exists to override.
    def watched-on-purpose []: nothing -> bool {
        let honoured_apps = [zoom.us FaceTime MSTeams Keynote 'CleanShot X']
        ^/usr/bin/pmset -g assertions
        | parse --regex 'pid \d+\((?<process>[^)]+)\): \[\S+\] \S+ (?<type>\w+) named: "(?<name>[^"]*)"'
        | where type in [NoDisplaySleepAssertion PreventUserIdleDisplaySleep]
        | any {|a| $a.name == 'Video Wake Lock' or $a.process in $honoured_apps }
    }

    def main [] {
        let timeout = display-sleep-seconds
        # 0 means the user turned display sleep off
        if $timeout > 0 and (idle-seconds) >= $timeout and not (watched-on-purpose) {
            ^/usr/bin/pmset displaysleepnow
        }
    }
  '';
in
{
  launchd.agents.enforce-display-sleep = {
    enable = true;
    config = {
      ProgramArguments = [ "${enforceDisplaySleep}" ];
      StartInterval = 60;
      ProcessType = "Background";
    };
  };
}
