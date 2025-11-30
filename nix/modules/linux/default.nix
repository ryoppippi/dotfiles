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
    # Linux-specific packages
    ./packages.nix

    # Linux-specific dotfiles
    (import ./dotfiles.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        ;
    })
  ];
}
