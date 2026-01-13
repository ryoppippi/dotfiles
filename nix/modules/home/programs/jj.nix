{
  config,
  helpers,
  ...
}:
let
  # User configuration (shared with git)
  user = helpers.mkUser config;
in
{
  # Jujutsu VCS configuration using Home Manager programs.jujutsu module
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = user.username;
        inherit (user) email;
      };
    };
  };
}
