{
  pkgs,
  config,
  homedir,
  ...
}:
let
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";
in
{
  systemd.user.services.kanata = {
    Unit = {
      Description = "Kanata keyboard remapper";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.kanata}/bin/kanata --cfg ${dotfilesDir}/kanata/kanata.kbd";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
