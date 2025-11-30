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

    # Linux-specific dotfiles
    (import ./dotfiles.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        helpers
        ;
    })
  ];
}
