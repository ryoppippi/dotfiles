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

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ai-tools = {
      url = "github:numtide/nix-ai-tools";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    home-manager,
    ai-tools,
  }: let
    username = "ryoppippi";
    homedir = "/Users/${username}";
    system = "aarch64-darwin";

    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        {
          home.stateVersion = "25.11";

          home.username = username;
          home.homeDirectory = homedir;

          programs.home-manager.enable = true;

          home.packages = with pkgs; [
            curl
          ] ++ (with ai-tools.packages.${system}; [
            claude-code
            codex
            cursor-agent
            opencode
            copilot-cli
            coderabbit-cli
          ]);
        }
      ];
    };
  };
}
