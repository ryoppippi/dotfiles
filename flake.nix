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
    in
    {
      # macOS configuration with nix-darwin
      darwinConfigurations.${darwinHostname} = nix-darwin.lib.darwinSystem {
        system = darwinSystem;

        modules = [
          # Darwin-specific configuration
          (import ./nix/darwin.nix {
            pkgs = mkPkgs darwinSystem;
            lib = nixpkgs.lib;
            username = username;
            homedir = darwinHomedir;
          })

          # Home Manager integration for macOS
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} =
              {
                pkgs,
                config,
                lib,
                ...
              }:
              import ./nix/home.nix {
                inherit pkgs config lib;
                inherit claude-code-overlay treefmt-nix git-hooks;
                homedir = darwinHomedir;
                system = darwinSystem;
              };
          }
        ];
      };

      # Linux configuration with standalone Home Manager
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs linuxSystem;
        modules = [
          (
            {
              pkgs,
              config,
              lib,
              ...
            }:
            import ./nix/home.nix {
              inherit pkgs config lib;
              inherit claude-code-overlay treefmt-nix git-hooks;
              homedir = linuxHomedir;
              system = linuxSystem;
            }
          )
        ];
      };

      # Apps for common tasks (macOS)
      apps.${darwinSystem} = {
        # Apply darwin configuration
        switch = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "darwin-switch" ''
              set -e
              echo "Building and switching to darwin configuration..."
              sudo nix run nix-darwin -- switch --flake .#${darwinHostname}
            ''
          );
        };

        # Update flake.lock
        update = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "flake-update" ''
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
            nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "update-ai-tools" ''
              set -e
              echo "Updating ai-tools input..."
              nix flake update ai-tools
              echo "Done! Run 'nix run .#switch' to apply changes."
            ''
          );
        };

        # Build darwin configuration (dry run)
        build = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "darwin-build" ''
              set -e
              echo "Building darwin configuration..."
              nix build .#darwinConfigurations.${darwinHostname}.system
              echo "Build successful! Run 'nix run .#switch' to apply."
            ''
          );
        };

        # Format code with treefmt
        fmt =
          let
            pkgs = mkPkgs darwinSystem;
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
              # Add secretlint to PATH for treefmt
              settings.global.excludes = [
                ".git/**"
                "*.lock"
              ];
            };
          in
          {
            type = "app";
            program = toString (
              pkgs.writeShellScript "treefmt-with-secretlint" ''
                export PATH="${nodePackages.nodeDependencies}/lib/node_modules/.bin:$PATH"
                exec ${treefmtWrapper}/bin/treefmt "$@"
              ''
            );
          };

        # Check Neovim configuration and install plugins
        nvim-check = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "nvim-check" ''
              exec ${nixpkgs.legacyPackages.${darwinSystem}.bash}/bin/bash \
                ${./nix/programs/neovim/check.sh} \
                ${darwinHomedir}/ghq/github.com/ryoppippi/dotfiles \
                ${nixpkgs.legacyPackages.${darwinSystem}.git}/bin/git \
                ${nixpkgs.legacyPackages.${darwinSystem}.neovim}/bin/nvim
            ''
          );
        };
      };

      # Apps for Linux
      apps.${linuxSystem} = {
        # Apply Home Manager configuration for Linux
        switch = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${linuxSystem}.writeShellScript "home-manager-switch" ''
              set -e
              echo "Building and switching to Home Manager configuration..."
              nix run nixpkgs#home-manager -- switch --flake .#${username}
            ''
          );
        };

        # Build Home Manager configuration (dry run)
        build = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${linuxSystem}.writeShellScript "home-manager-build" ''
              set -e
              echo "Building Home Manager configuration..."
              nix build .#homeConfigurations.${username}.activationPackage
              echo "Build successful! Run 'nix run .#switch' to apply."
            ''
          );
        };

        # Check Neovim configuration and install plugins
        nvim-check = {
          type = "app";
          program = toString (
            nixpkgs.legacyPackages.${linuxSystem}.writeShellScript "nvim-check" ''
              exec ${nixpkgs.legacyPackages.${linuxSystem}.bash}/bin/bash \
                ${./nix/programs/neovim/check.sh} \
                ${linuxHomedir}/ghq/github.com/ryoppippi/dotfiles \
                ${nixpkgs.legacyPackages.${linuxSystem}.git}/bin/git \
                ${nixpkgs.legacyPackages.${linuxSystem}.neovim}/bin/nvim
            ''
          );
        };
      };
    };
}
