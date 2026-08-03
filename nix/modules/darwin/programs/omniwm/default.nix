{
  omniwmModule,
  ...
}:
{
  imports = [ omniwmModule ];

  programs.omniwm = {
    enable = true;
    settings = ./settings.toml;
    launchd = {
      enable = true;
      keepAlive = true;
    };
  };

  xdg.configFile."omniwm/settings.toml".force = true;
}
