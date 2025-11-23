{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
{
  imports = [
    # Common dotfiles for all platforms
    (import ./common.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        ;
    })

    # Platform-specific dotfiles
    (import ./darwin.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        ;
    })
    (import ./linux.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        ;
    })
  ];
}
