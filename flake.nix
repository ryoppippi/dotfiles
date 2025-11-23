{
  description = "ryoppippi's home-manager configuration";

  nixConfig = {
    extra-substituters = [ "https://numtide.cachix.org" ];
    extra-trusted-public-keys = [ "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE=" ];
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

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
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
      git-hooks,
    }:
    let
      lib = nixpkgs.lib;
      username = "ryoppippi";

      # macOS configuration
      darwinSystem = "aarch64-darwin";
      darwinHomedir = "/Users/${username}";
      darwinHostname = "${username}";

      # Linux configuration
      linuxSystem = "x86_64-linux";
      linuxHomedir = "/home/${username}";

      # Create pkgs with overlays
      mkPkgs =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (import ./nix/overlays.nix {
              inherit ai-tools claude-code-overlay system;
            })
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
                  command = "${nodePackages.nodeDependencies}/lib/node_modules/.bin/renovate-config-validator";
                  options = [ "--strict" ];
                  includes = [
                    ".github/renovate.json"
                    ".github/renovate.json5"
                  ];
                };
              };
            };
          };
        in
        {
          # Check Neovim configuration and install plugins
          nvim-check = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "nvim-check" ''
                # Use DOTFILES_DIR env var, or fall back to default location, or current directory
                : "''${DOTFILES_DIR:=${homedir}/ghq/github.com/ryoppippi/dotfiles}"
                if [ ! -d "$DOTFILES_DIR" ]; then
                  DOTFILES_DIR="$(pwd)"
                fi
                exec ${pkgs.bash}/bin/bash \
                  ${./nix/modules/home/programs/neovim/check.sh} \
                  "$DOTFILES_DIR" \
                  ${pkgs.git}/bin/git \
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

          # Update ai-tools only
          update-ai-tools = {
            type = "app";
            program = toString (
              pkgs.writeShellScript "update-ai-tools" ''
                set -e
                echo "Updating ai-tools input..."
                nix flake update ai-tools
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
                  # Common home-manager configuration
                  (import ./nix/modules/home {
                    inherit
                      pkgs
                      config
                      lib
                      claude-code-overlay
                      treefmt-nix
                      git-hooks
                      ;
                    homedir = darwinHomedir;
                    system = darwinSystem;
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

      # Linux configuration with standalone Home Manager
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
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
                # Common home-manager configuration
                (import ./nix/modules/home {
                  inherit
                    pkgs
                    config
                    lib
                    claude-code-overlay
                    treefmt-nix
                    git-hooks
                    ;
                  homedir = linuxHomedir;
                  system = linuxSystem;
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

      # Apps for common tasks (macOS)
      apps.${darwinSystem} = mkCommonApps darwinSystem darwinHomedir darwinHostname;

      # Apps for Linux
      apps.${linuxSystem} = mkCommonApps linuxSystem linuxHomedir username;
    };
}
