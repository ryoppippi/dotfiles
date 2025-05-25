{
  description = "ryoppippi's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }:
    let
      system = "aarch64-darwin"; # macOS ARM64
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      homeConfigurations."ryoppippi" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home.nix ];
      };

      # Add x86_64-darwin support as well
      homeConfigurations."ryoppippi-x86" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-darwin";
        modules = [ ./home.nix ];
      };

      # Development shell
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          home-manager
          nix
        ];
        shellHook = ''
          echo "Nix development environment loaded!"
          echo "To apply home-manager configuration, run:"
          echo "  home-manager switch --flake ."
        '';
      };
    };
}