{ pkgs, ... }:
let
  # On AC power the Mac never sleeps, lid closed included, so T3 Code stays
  # reachable through T3 Connect. `pmset -c sleep 0` cannot do this: it only
  # covers idle sleep, and clamshell sleep ignores it. disablesleep does cover
  # the lid but is global rather than per power source, so it has to follow
  # the power source here, and be cleared the moment the Mac is unplugged.
  acAwake = pkgs.writers.writeNu "ac-awake" ''
    def on-ac-power []: nothing -> bool {
        ^/usr/bin/pmset -g ps | lines | first | str contains "'AC Power'"
    }

    def sleep-disabled []: nothing -> bool {
        ^/usr/bin/pmset -g | parse --regex 'SleepDisabled\s+(?<value>\d)' | get 0.value | $in == '1'
    }

    def lid-closed []: nothing -> bool {
        ^/usr/sbin/ioreg -r -k AppleClamshellState -d 1 | str contains '"AppleClamshellState" = Yes'
    }

    def main [] {
        let ac = on-ac-power
        if $ac != (sleep-disabled) {
            ^/usr/bin/pmset -a disablesleep (if $ac { 1 } else { 0 })
        }
        # Unplugged with the lid already shut, nothing else would put it to
        # sleep until the lid opens again, e.g. inside a bag.
        if not $ac and (lid-closed) {
            ^/usr/bin/pmset sleepnow
        }
    }
  '';

  # Closing the lid normally locks the Mac by putting it to sleep, which
  # disablesleep prevents, so turn the display off instead: the screensaver
  # asks for the password immediately. IOPMrootDomain reports the lid as it
  # moves, so the lock does not wait for a polling interval.
  lockOnLidClose = pkgs.runCommandCC "lock-on-lid-close" { } ''
    mkdir -p $out/bin
    $CC -Wall -Wextra -Werror -O2 -framework IOKit -framework CoreFoundation \
      ${./lock-on-lid-close.c} -o $out/bin/lock-on-lid-close
  '';
in
{
  launchd.daemons.lock-on-lid-close.serviceConfig = {
    ProgramArguments = [ "${lockOnLidClose}/bin/lock-on-lid-close" ];
    RunAtLoad = true;
    KeepAlive = true;
    StandardOutPath = "/var/log/lock-on-lid-close.log";
    StandardErrorPath = "/var/log/lock-on-lid-close.log";
  };

  launchd.daemons.ac-awake.serviceConfig = {
    ProgramArguments = [ "${acAwake}" ];
    LaunchEvents."com.apple.notifyd.matching".power-source.Notification =
      "com.apple.system.powersources.source";
    RunAtLoad = true;
    StartInterval = 60;
    StandardOutPath = "/var/log/ac-awake.log";
    StandardErrorPath = "/var/log/ac-awake.log";
    ProcessType = "Background";
  };
}
