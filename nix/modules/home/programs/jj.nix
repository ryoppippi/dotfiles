{
  pkgs,
  lib,
  config,
  ...
}:
let
  # Share user configuration with Git
  username = config.home.username;
  githubId = "1560508";
  email = "${githubId}+${username}@users.noreply.github.com";
in
{
  # Jujutsu VCS configuration using Home Manager programs.jujutsu module
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = username;
        inherit email;
      };
    };
  };
}
