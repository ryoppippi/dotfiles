{
  omniwmModule,
  ...
}:
{
  imports = [ omniwmModule ];

  programs.omniwm = {
    enable = true;
    settings = ./omniwm-settings.toml;
    launchd = {
      enable = true;
      keepAlive = true;
    };
  };
}
