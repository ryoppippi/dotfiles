{ inputs, constants, ... }:
let
  inherit (inputs)
    nixpkgs
    nix-darwin
    nix-homebrew
    home-manager
    nix-secure-enclave-key
    fish-na
    nix-index-database
    agent-skills
    ;

  inherit (constants)
    username
    darwinHomedir
    local-skills
    skillRegistry
    ;

  system = "aarch64-darwin";
  darwinPkgs = import ../../mk-pkgs.nix { inherit inputs system; };
  agentSkillsLib = agent-skills.lib.agent-skills;
in
{
  flake.darwinConfigurations.${username} = nix-darwin.lib.darwinSystem {
    inherit system;

    modules = [
      nix-homebrew.darwinModules.nix-homebrew
      {
        nix-homebrew = {
          enable = true;
          enableRosetta = false;
          user = username;
          autoMigrate = true;
          mutableTaps = true;
        };
      }

      (import ../../modules/darwin/system.nix {
        pkgs = darwinPkgs;
        inherit (nixpkgs) lib;
        inherit username;
        homedir = darwinHomedir;
      })

      nix-index-database.darwinModules.nix-index

      home-manager.darwinModules.home-manager
      {
        home-manager = {
          backupFileExtension = "before-nix-secure-enclave-key";
          useGlobalPkgs = false;
          useUserPackages = true;
          extraSpecialArgs = {
            pkgs = darwinPkgs;
          };
          users.${username} =
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
                nix-secure-enclave-key.homeManagerModules.default

                agent-skills.homeManagerModules.default

                (import ../../modules/darwin/programs/omniwm {
                  inherit config lib pkgs;
                })

                (import ../../modules/home {
                  inherit
                    pkgs
                    config
                    lib
                    fish-na
                    ;
                  inherit local-skills agentSkillsLib skillRegistry;
                  homedir = darwinHomedir;
                  inherit system;
                  nodePackages = import ../../packages/node { inherit pkgs; };
                })

                (import ../../modules/darwin {
                  inherit
                    pkgs
                    config
                    lib
                    helpers
                    ;
                  homedir = darwinHomedir;
                  dotfilesDir = "${darwinHomedir}/ghq/github.com/ryoppippi/dotfiles";
                })
              ];

              programs.nix-secure-enclave-key = {
                enable = true; # Install the package and configure SSH/Git integration.
                identities = {
                  git-signing = {
                    keyFile = "~/.ssh/id_enclave_key"; # Non-secret SSH stub used for login and signing.
                    label = "nix-secure-enclave-key"; # Reuse the existing CryptoTokenKit identity.
                    protection = "none"; # Avoid Touch ID prompts; "bio" enables biometric protection.
                    autoEnsure = true; # Create the Secure Enclave identity and SSH stub during activation.
                    github = {
                      autoAdd = true; # Register the public key during user activation.
                      type = "both"; # Register both SSH authentication and Git signing.
                      # Omit title to derive a machine- and public-key-specific GitHub title.
                    };
                  };
                };
                signingIdentity = "git-signing"; # Select the identity used for Git SSH signing.
                signByDefault = true; # Sign Git commits with the Secure Enclave-backed key.
              };

              programs.ssh.extraConfig = "Include ~/.orbstack/ssh/config";
            };
        };
      }
    ];
  };
}
