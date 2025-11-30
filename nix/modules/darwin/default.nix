{
  pkgs,
  config,
  lib,
  homedir,
  dotfilesDir ? "${homedir}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
{
  imports = [
    # macOS-specific packages
    ./packages.nix

    # macOS-specific dotfiles
    (import ./dotfiles.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        ;
    })

    # Docker configuration (OrbStack)
    ./programs/docker.nix
  ];
}
