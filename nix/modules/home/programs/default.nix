{
  pkgs,
  lib,
  config,
  dotfilesDir,
  claude-code-overlay,
  system,
  helpers,
  ...
}:
{
  imports = [
    # Claude Code configuration
    (import ./claude-code.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        claude-code-overlay
        system
        helpers
        ;
    })

    # Codex configuration
    (import ./codex.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        helpers
        ;
    })

    # GitHub CLI configuration
    (import ./gh.nix {
      inherit
        pkgs
        lib
        config
        ;
    })

    # Neovim configuration
    (import ./neovim {
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
