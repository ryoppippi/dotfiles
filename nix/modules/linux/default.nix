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

  # nix-index for command-not-found and comma
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
