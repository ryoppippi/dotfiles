{
  config,
  pkgs,
  lib,
  ...
}:
{
  home.file.".config/pip/pip.conf" = {
    text = ''
      [global]
      require-virtualenv = true
    '';
  };
}
