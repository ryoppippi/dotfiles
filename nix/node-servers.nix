{ pkgs, ... }:
let
  # Import node2nix generated expressions
  nodePackages = import ./node2nix {
    inherit pkgs;
    inherit (pkgs) system;
    nodejs = pkgs.nodejs_24; # Use Node.js 24 instead of default 14
  };
in
{
  home.packages = [
    # Install all Node.js language servers and tools
    nodePackages.package
  ];

  # Add node_modules/.bin to PATH for NeoVim
  home.sessionPath = [
    "${nodePackages.nodeDependencies}/lib/node_modules/.bin"
  ];
}
