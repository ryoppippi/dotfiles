{ config, pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    package = pkgs.direnv.overrideAttrs {
      checkPhase = ''
        runHook preCheck
        make test-go test-bash test-fish
        runHook postCheck
      '';
    };
    nix-direnv.enable = true;
    config = {
      global = {
        warn_timeout = "0s";
        hide_env_diff = true;
      };
      whitelist.prefix = map (dir: "${config.home.homeDirectory}/${dir}") [
        "ghq/github.com/rorkai"
        ".t3/worktrees/rorkai"
      ];
    };
    stdlib = ''
      export DIRENV_LOG_FORMAT=""
    '';
  };
}
