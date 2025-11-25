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
    # AI tools
    ./ai-tools.nix

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

    # Amp configuration
    (import ./amp.nix {
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

    # Git configuration
    (import ./git {
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

    # Cursor CLI configuration
    ./cursor.nix

    # Ghostty terminal configuration
    ./ghostty.nix

    # Zed editor configuration
    ./zed.nix

    # Bat configuration
    ./bat.nix

    # jj configuration
    ./jj.nix
  ];
}
