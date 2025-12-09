{
  description = "ryoppippi's home-manager configuration";

  # Note: cachix configuration is defined in nix/cachix.nix
  # but nixConfig must be a literal set, so we inline it here
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://numtide.cachix.org"
      "https://devenv.cachix.org"
      "https://ryoppippi.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "numtide.cachix.org-1:2uk1h3hh8XGkFfQJSTgNTg/WRNsE+lTZYOB+VkZdvJo="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ai-tools = {
      url = "github:numtide/nix-ai-tools";
    };

    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gh-nippou = {
      url = "github:ryoppippi/gh-nippou";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-nix = {
      url = "github:BatteredBunny/brew-nix";
      inputs.brew-api.follows = "brew-api";
      inputs.nix-darwin.follows = "nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    brew-api = {
      url = "github:BatteredBunny/brew-api";
      flake = false;
    };

    rs-arto = {
      url = "github:lambdalisue/rs-arto";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ai-tools,
      claude-code-overlay,
      treefmt-nix,
      gh-nippou,
      brew-nix,
      brew-api,
      rs-arto,
    }:
    let
      lib = nixpkgs.lib;
      username = "ryoppippi";

      # macOS configuration
      darwinSystem = "aarch64-darwin";
      darwinHomedir = "/Users/${username}";
      darwinHostname = "${username}";

      # Linux configuration
      linuxSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      linuxHomedir = "/home/${username}";

      # Create pkgs with overlays
      mkPkgs =
        system:
        let
          isDarwin = builtins.match ".*-darwin" system != null;
        in
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              _ai-tools = ai-tools;
              _claude-code-overlay = claude-code-overlay;
              arto = rs-arto.packages.${system}.default;
            })
            gh-nippou.overlays.default
            (import ./nix/overlays/default.nix)
          ]
          ++ lib.optionals isDarwin [
            brew-nix.overlays.default
          ];
        };

      # Common apps for both Darwin and Linux
      mkCommonApps =
        system: homedir: hostname:
        let
          pkgs = mkPkgs system;
          isDarwin = pkgs.stdenv.isDarwin;
          # Import node2nix packages including secretlint
          nodePackages = import ./nix/node2nix {
            inherit pkgs;
            inherit (pkgs) system;
            nodejs = pkgs.nodejs_24;
          };
          treefmtWrapper = treefmt-nix.lib.mkWrapper pkgs {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt = {
                enable = true;
                package = pkgs.nixfmt-rfc-style;
              };
              stylua.enable = true;
            };
            settings = {
              global.excludes = [
                ".git/**"
                "*.lock"
              ];
              # Custom formatters/linters
              formatter = {
                secretlint = {
                  command = "${nodePackages.nodeDependencies}/lib/node_modules/.bin/secretlint";
                  includes = [ "*" ];
                };
                renovate-validator = {
                  command = "${pkgs.renovate}/bin/renovate-config-validator";
                  options = [ "--strict" ];
                  includes = [
                    ".github/renovate.json5"
                  ];
                };
              };
            };
          };
        in
        {
          # Restore Neovim plugins from lock file
          nvim-restore = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "nvim-restore" ''
                : "''${DOTFILES_DIR:=${homedir}/ghq/github.com/ryoppippi/dotfiles}"
                if [ ! -d "$DOTFILES_DIR" ]; then
                  DOTFILES_DIR="$(pwd)"
                fi
                exec ${pkgs.bash}/bin/bash \
                  ${./nix/modules/home/programs/neovim/check.sh} \
                  "$DOTFILES_DIR/nvim" \
                  "$HOME/.local/share/nvim/lazy" \
                  ${pkgs.neovim}/bin/nvim
              ''
            );
          };

          # Build configuration (platform-specific)
          build = {
            type = "app";
            program = toString (
              pkgs.writeShellScript (if isDarwin then "darwin-build" else "home-manager-build") ''
                set -e
                echo "Building ${if isDarwin then "darwin" else "Home Manager"} configuration..."
                nix build .#${
                  if isDarwin then
                    "darwinConfigurations.${hostname}.system"
                  else
                    "homeConfigurations.${username}.activationPackage"
                }
                echo "Build successful! Run 'nix run .#switch' to apply."
              ''
            );
          };

          # Apply configuration (platform-specific)
          switch = {
            type = "app";
            program = toString (
              pkgs.writeShellScript (if isDarwin then "darwin-switch" else "home-manager-switch") ''
                set -e
                echo "Building and switching to ${if isDarwin then "darwin" else "Home Manager"} configuration..."
                ${
                  if isDarwin then
                    "sudo nix run nix-darwin -- switch --flake .#${hostname}"
                  else
                    "nix run nixpkgs#home-manager -- switch --flake .#${username}"
                }
              ''
            );
          };

          # Update flake.lock
          update = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "flake-update" ''
                set -e
                echo "Updating flake.lock..."
                nix flake update
                echo "Done! Run 'nix run .#switch' to apply changes."
              ''
            );
          };

          # Update ai-tools and claude-code-overlay
          update-ai-tools = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "update-ai-tools" ''
                set -e
                echo "Updating AI tools inputs..."
                nix flake update ai-tools claude-code-overlay
                echo "Done! Run 'nix run .#switch' to apply changes."
              ''
            );
          };

          # Format code with treefmt
          fmt = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "treefmt-wrapper" ''
                exec ${treefmtWrapper}/bin/treefmt "$@"
              ''
            );
          };

          # Regenerate node2nix expressions
          update-node2nix = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "update-node2nix" ''
                set -e
                cd nix/node2nix
                exec ${pkgs.node2nix}/bin/node2nix -l package-lock.json "$@"
              ''
            );
          };
        };

      # Helper to create Linux home configuration
      mkLinuxHomeConfig =
        linuxSystem:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs linuxSystem;
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
                helpers = import ./nix/modules/lib/helpers { inherit lib; };
              in
              {
                imports = [
                  # Claude Code home-manager module from overlay
                  claude-code-overlay.homeManagerModules.default

                  # Common home-manager configuration
                  (import ./nix/modules/home {
                    inherit
                      pkgs
                      config
                      lib
                      claude-code-overlay
                      treefmt-nix
                      ;
                    homedir = linuxHomedir;
                    system = linuxSystem;
                    nodePackages = import ./nix/node2nix {
                      inherit pkgs;
                      inherit (pkgs) system;
                      nodejs = pkgs.nodejs_24;
                    };
                  })

                  # Linux-specific home-manager configuration
                  (import ./nix/modules/linux {
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
      # macOS configuration with nix-darwin
      darwinConfigurations.${darwinHostname} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;

        modules = [
          # Darwin-specific system configuration
          (import ./nix/modules/darwin/system.nix {
            pkgs = mkPkgs darwinSystem;
            lib = nixpkgs.lib;
            username = username;
            homedir = darwinHomedir;
          })

          # Home Manager integration for macOS
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = {
              pkgs = mkPkgs darwinSystem;
            };
            home-manager.users.${username} =
              {
                pkgs,
                config,
                lib,
                ...
              }:
              let
                helpers = import ./nix/modules/lib/helpers { inherit lib; };
              in
              {
                imports = [
                  # Claude Code home-manager module from overlay
                  claude-code-overlay.homeManagerModules.default

                  # Common home-manager configuration
                  (import ./nix/modules/home {
                    inherit
                      pkgs
                      config
                      lib
                      claude-code-overlay
                      treefmt-nix
                      ;
                    homedir = darwinHomedir;
                    system = darwinSystem;
                    nodePackages = import ./nix/node2nix {
                      inherit pkgs;
                      inherit (pkgs) system;
                      nodejs = pkgs.nodejs_24;
                    };
                  })

                  # macOS-specific home-manager configuration
                  (import ./nix/modules/darwin {
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
              };
          }
        ];
      };

      # Linux configurations with standalone Home Manager
      homeConfigurations = {
        # x86_64-linux configuration (for most Linux servers/desktops)
        ${username} = mkLinuxHomeConfig "x86_64-linux";
        # aarch64-linux configuration (for ARM Linux like Raspberry Pi, cloud VMs)
        "${username}-aarch64" = mkLinuxHomeConfig "aarch64-linux";
      };

      # Apps for common tasks
      apps = {
        ${darwinSystem} = mkCommonApps darwinSystem darwinHomedir darwinHostname;
        "x86_64-linux" = mkCommonApps "x86_64-linux" linuxHomedir username;
        "aarch64-linux" = mkCommonApps "aarch64-linux" linuxHomedir username;
      };
    };
}
