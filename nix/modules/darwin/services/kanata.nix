{ homedir, ... }:
let
  dotfilesDir = "${homedir}/ghq/github.com/ryoppippi/dotfiles";
  kanataConfigDir = "${dotfilesDir}/kanata";
in
{
  services.kanata = {
    enable = true;
    keyboards = {
      macbook = {
        configFile = "${kanataConfigDir}/macbook.kbd";
        port = 5829;
        vkAgent = {
          enable = true;
          blacklist = [
            "com.hnc.Discord"
            "com.openai.chat"
          ];
        };
      };
      claw44 = {
        configFile = "${kanataConfigDir}/claw44.kbd";
        port = 5830;
        vkAgent = {
          enable = true;
          blacklist = [
            "com.hnc.Discord"
            "com.openai.chat"
          ];
        };
      };
    };
  };
}
