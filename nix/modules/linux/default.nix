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

    # Kanata service
    (import ./services/kanata.nix {
      inherit
        pkgs
        config
        homedir
        ;
    })
  ];

  # nix-index for command-not-found and comma
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;
}
