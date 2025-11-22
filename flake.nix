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
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    ai-tools,
  }: let
    username = "ryoppippi";
    system = "aarch64-darwin";
    homedir = "/Users/${username}";
    hostname = "${username}";
  in {
    darwinConfigurations.${hostname} = nix-darwin.lib.darwinSystem {
      inherit system;

      modules = [
        # Nix configuration
        {
          # Disable nix-darwin's Nix management (using Determinate Nix)
          nix.enable = false;

          # Enable Touch ID for sudo
          security.pam.services.sudo_local.touchIdAuth = true;

          # Set system state version
          system.stateVersion = 5;

          # Define user
          users.users.${username}.home = homedir;
        }

        # Home Manager integration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${username} = {
            home.stateVersion = "25.11";

            programs.home-manager.enable = true;

            home.packages = with nixpkgs.legacyPackages.${system}; [
              curl
            ] ++ (with ai-tools.packages.${system}; [
              claude-code
              codex
              cursor-agent
              opencode
              copilot-cli
              coderabbit-cli
            ]);
          };
        }
      ];
    };
  };
}
