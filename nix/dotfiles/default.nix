{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  helpers,
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
        helpers
        ;
    })

    # Platform-specific dotfiles
    (import ./darwin.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        helpers
        ;
    })
    (import ./linux.nix {
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
