{ pkgs, ... }:
let
  t3Port = 3773;

  # T3 Code's Network access listens on every interface, and on a LAN its
  # traffic is plain HTTP. Remote clients reach it over Tailscale instead
  # (Tailscale HTTPS proxies to loopback; direct tailnet traffic arrives on
  # a utun interface), so the port answers only loopback and utun.
  rules = pkgs.writeText "t3code.pf" ''
    pass in quick on lo0 proto tcp from any to any port ${toString t3Port}
    pass in quick on utun proto tcp from any to any port ${toString t3Port}
    block return in quick proto tcp from any to any port ${toString t3Port}
  '';
in
{
  # Loaded under the com.apple anchor that the stock /etc/pf.conf already
  # evaluates, so the system ruleset is left untouched. `-E` enables pf with
  # a reference that keeps it on.
  launchd.daemons.t3code-firewall.serviceConfig = {
    ProgramArguments = [
      "/sbin/pfctl"
      "-E"
      "-a"
      "com.apple/t3code"
      "-f"
      "${rules}"
    ];
    RunAtLoad = true;
  };
}
