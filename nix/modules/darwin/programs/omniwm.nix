{
  omniwmModule,
  ...
}:
{
  imports = [ omniwmModule ];

  programs.omniwm = {
    enable = true;
    launchd = {
      enable = true;
      keepAlive = true;
    };
  };
}
