{
  description = "ryoppippi's home-manager configuration";

  nixConfig = {
    extra-substituters = ["https://numtide.cachix.org"];
    extra-trusted-public-keys = ["numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="];
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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ai-tools,
    claude-code-overlay,
  }: let
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
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (import ./nix/overlays.nix {
            inherit ai-tools claude-code-overlay system;
          })
        ];
      };
  in {
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
          home-manager.users.${username} = {
            pkgs,
            config,
            lib,
            ...
          }:
            import ./nix/home.nix {
              inherit pkgs config lib;
              inherit claude-code-overlay;
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
        ({
          pkgs,
          config,
          lib,
          ...
        }:
          import ./nix/home.nix {
            inherit pkgs config lib;
            inherit claude-code-overlay;
            homedir = linuxHomedir;
            system = linuxSystem;
          })
      ];
    };

    # Apps for common tasks (macOS)
    apps.${darwinSystem} = {
      # Apply darwin configuration
      switch = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "darwin-switch" ''
          set -e
          echo "Building and switching to darwin configuration..."
          sudo nix run nix-darwin -- switch --flake .#${darwinHostname}
        '');
      };

      # Update flake.lock
      update = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "flake-update" ''
          set -e
          echo "Updating flake.lock..."
          nix flake update
          echo "Done! Run 'nix run .#switch' to apply changes."
        '');
      };

      # Update ai-tools only
      update-ai-tools = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "update-ai-tools" ''
          set -e
          echo "Updating ai-tools input..."
          nix flake update ai-tools
          echo "Done! Run 'nix run .#switch' to apply changes."
        '');
      };

      # Build darwin configuration (dry run)
      build = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${darwinSystem}.writeShellScript "darwin-build" ''
          set -e
          echo "Building darwin configuration..."
          nix build .#darwinConfigurations.${darwinHostname}.system
          echo "Build successful! Run 'nix run .#switch' to apply."
        '');
      };

    };

    # Apps for Linux
    apps.${linuxSystem} = {
      # Apply Home Manager configuration for Linux
      switch = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${linuxSystem}.writeShellScript "home-manager-switch" ''
          set -e
          echo "Building and switching to Home Manager configuration..."
          nix run nixpkgs#home-manager -- switch --flake .#${username}
        '');
      };

      # Build Home Manager configuration (dry run)
      build = {
        type = "app";
        program = toString (nixpkgs.legacyPackages.${linuxSystem}.writeShellScript "home-manager-build" ''
          set -e
          echo "Building Home Manager configuration..."
          nix build .#homeConfigurations.${username}.activationPackage
          echo "Build successful! Run 'nix run .#switch' to apply."
        '');
      };
    };
  };
}
