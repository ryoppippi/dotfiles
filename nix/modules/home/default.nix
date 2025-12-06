{
  pkgs,
  config,
  lib,
  homedir,
  dotfilesDir ? "${homedir}/ghq/github.com/ryoppippi/dotfiles",
  claude-code-overlay ? null,
  treefmt-nix ? null,
  system ? null,
  nodePackages ? null,
  ...
}:
let
  # Import common helpers once
  helpers = import ../lib/helpers { inherit lib; };
in
{
  imports = [
    # Common packages
    ./packages.nix

    # Git hooks configuration (treefmt + rebase skip)
    (import ./git-hooks.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        treefmt-nix
        nodePackages
        ;
    })

    # Program configurations (Claude Code, Codex, Neovim, etc.)
    (import ./programs {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        claude-code-overlay
        system
        helpers
        nodePackages
        ;
    })

    # Common dotfiles symlinks
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

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
