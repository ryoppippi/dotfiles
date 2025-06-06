{
  description = "ryoppippi's dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, flake-utils, ... }:
    let
      # Support multiple systems
      supportedSystems = [
        "aarch64-darwin"  # Apple Silicon
        "x86_64-darwin"   # Intel Mac
        "x86_64-linux"    # Linux x86_64
        "aarch64-linux"   # Linux ARM64
      ];
      
      # Helper function to generate outputs for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # System-specific configurations
      homeConfiguration = system: 
        let
          pkgs = nixpkgs.legacyPackages.${system};
          isDarwin = builtins.match ".*-darwin" system != null;
          isLinux = builtins.match ".*-linux" system != null;
        in
        home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ 
            ./home.nix
            {
              # Pass system info to home.nix
              _module.args = {
                inherit isDarwin isLinux system;
              };
            }
          ];
        };
    in
    {
      # Home configurations for each supported system
      homeConfigurations = {
        "ryoppippi@aarch64-darwin" = homeConfiguration "aarch64-darwin";
        "ryoppippi@x86_64-darwin" = homeConfiguration "x86_64-darwin";
        "ryoppippi@x86_64-linux" = homeConfiguration "x86_64-linux";
        "ryoppippi@aarch64-linux" = homeConfiguration "aarch64-linux";
      };

      # Darwin system configuration (optional, for deeper macOS integration)
      darwinConfigurations."ryoppippi-darwin" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./darwin-configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.ryoppippi = import ./home.nix;
          }
        ];
      };

      # Development shells for each system
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              home-manager
              nix
            ] ++ pkgs.lib.optionals (builtins.match ".*-darwin" system != null) [
              darwin.cctools
            ];
            shellHook = ''
              echo "Nix development environment loaded for ${system}!"
              echo "To apply home-manager configuration, run:"
              echo "  home-manager switch --flake .#ryoppippi@${system}"
            '';
          };
        }
      );
    };
}