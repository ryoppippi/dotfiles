# Home Manager module for OmniWM.
#
# Vendored from DavSanchez/nix-dotfiles, which exported this as
# `homeModules.omniwm` until it dropped the module in favour of one shipped
# elsewhere. Only that module went away — `overlays.additions` still provides
# `pkgs.omniwm`, so the input stays and only the module lives here now.
#
# The upstream `settings` option is deliberately not carried over: OmniWM
# rewrites settings.toml from the GUI and has no include mechanism, so this
# repository merges the live file during activation with merge-settings.nu
# rather than linking a read-only store path. See README.md.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.omniwm;
in
{
  options.programs.omniwm = {
    enable = lib.mkEnableOption "OmniWM";

    package = lib.mkPackageOption pkgs "omniwm" { };

    launchd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to manage OmniWM with a launchd agent.";
      };

      keepAlive = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether the launchd agent should be kept alive.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      (lib.hm.assertions.assertPlatform "programs.omniwm" pkgs lib.platforms.darwin)
    ];

    home.packages = [ cfg.package ];

    launchd.agents.omniwm = {
      inherit (cfg.launchd) enable;
      config = {
        Program = "${cfg.package}/Applications/OmniWM.app/Contents/MacOS/OmniWM";
        KeepAlive = cfg.launchd.keepAlive;
        RunAtLoad = true;
        StandardOutPath = "/tmp/omniwm.log";
        StandardErrorPath = "/tmp/omniwm.err.log";
      };
    };
  };
}
