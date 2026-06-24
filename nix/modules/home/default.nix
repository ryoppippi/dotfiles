{
  pkgs,
  config,
  lib,
  homedir,
  dotfilesDir ? "${homedir}/ghq/github.com/ryoppippi/dotfiles",
  system ? null,
  nodePackages ? null,
  fish-na ? null,
  ast-grep-skill ? null,
  agent-browser-skill ? null,
  tgrab-skill ? null,
  cmux-skill ? null,
  local-skills ? null,
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

    # Git hooks for auto-switching nix config and treefmt on pre-commit
    (import ./git-hooks.nix {
      inherit lib dotfilesDir;
    })

    # Agent skills for Claude Code (skills from flake inputs)
    (import ./agent-skills.nix {
      inherit
        pkgs
        lib
        ast-grep-skill
        agent-browser-skill
        tgrab-skill
        cmux-skill
        local-skills
        config
        ;
    })

    # Program configurations (Claude Code, Codex, Neovim, etc.)
    (import ./programs {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        system
        helpers
        nodePackages
        fish-na
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
