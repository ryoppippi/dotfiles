{
  pkgs,
  config,
  lib,
  homedir,
  dotfilesDir ? "${homedir}/ghq/github.com/ryoppippi/dotfiles",
  helpers,
  ...
}:
{
  imports = [
    # Linux-specific packages
    ./packages.nix
  ];

  # nix-index for command-not-found; comma is comma-auto-pick in home.packages
  programs.nix-index.enable = true;
}
