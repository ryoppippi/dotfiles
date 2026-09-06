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
    # macOS-specific packages
    ./packages.nix

    # macOS-specific dotfiles
    (import ./dotfiles.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        helpers
        ;
    })

    # Docker configuration (OrbStack)
    ./programs/docker.nix

    # Karabiner-Elements config generated from karabiner/karabiner.ts
    ./programs/karabiner
  ];
}
