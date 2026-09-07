{ inputs, constants, ... }:
let
  inherit (inputs)
    home-manager
    fish-na
    nix-index-database
    agent-skills
    ;

  inherit (constants)
    username
    linuxHomedir
    local-skills
    skillRegistry
    ;

  agentSkillsLib = agent-skills.lib.agent-skills;

  mkLinuxHomeConfig =
    system:
    home-manager.lib.homeManagerConfiguration {
      pkgs = import ../../mk-pkgs.nix { inherit inputs system; };
      modules = [
        {
          home.username = username;
          home.homeDirectory = linuxHomedir;
        }
        (
          {
            pkgs,
            config,
            lib,
            ...
          }:
          let
            helpers = import ../../modules/lib/helpers { inherit lib; };
          in
          {
            imports = [
              nix-index-database.hmModules.nix-index
              agent-skills.homeManagerModules.default

              (import ../../modules/home {
                inherit
                  pkgs
                  config
                  lib
                  fish-na
                  ;
                inherit local-skills agentSkillsLib skillRegistry;
                homedir = linuxHomedir;
                inherit system;
                nodePackages = import ../../packages/node { inherit pkgs; };
              })

              (import ../../modules/linux {
                inherit
                  pkgs
                  config
                  lib
                  helpers
                  ;
                homedir = linuxHomedir;
                dotfilesDir = "${linuxHomedir}/ghq/github.com/ryoppippi/dotfiles";
              })
            ];
          }
        )
      ];
    };
in
{
  flake.homeConfigurations = {
    ${username} = mkLinuxHomeConfig "x86_64-linux";
    "${username}-aarch64" = mkLinuxHomeConfig "aarch64-linux";
  };
}
