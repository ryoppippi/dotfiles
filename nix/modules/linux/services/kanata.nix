{
  pkgs,
  lib,
  config,
  homedir,
  ...
}:
let
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";
  kanata = lib.getExe pkgs.kanata;
in
{
  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${kanata} --cfg ${dotfilesDir}/kanata/kanata.kbd";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
