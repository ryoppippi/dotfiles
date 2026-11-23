{ pkgs, lib, ... }:
let
  kache = lib.getExe pkgs.kache;
in
{
  home.packages = [ pkgs.kache ];

  # An environment variable rather than `build.rustc-wrapper` in
  # ~/.cargo/config.toml, so build tools that unset RUSTC_WRAPPER to bypass
  # caching still can.
  home.sessionVariables.RUSTC_WRAPPER = kache;

  xdg.configFile."kache/config.toml".source = (pkgs.formats.toml { }).generate "kache-config.toml" {
    cache = {
      local_max_size = "50GiB";
      auto_clean_idle_targets_days = 14;
      auto_recover_min_free_bytes = "50GiB";
      auto_recover_targets = true;
    };
  };

  # The daemon enforces the limits above; without it nothing is ever evicted.
  launchd.agents.kache = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        kache
        "daemon"
        "run"
      ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
      ThrottleInterval = 5;
    };
  };
}
