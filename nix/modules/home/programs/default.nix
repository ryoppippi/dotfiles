{
  pkgs,
  lib,
  config,
  dotfilesDir,
  helpers,
  nodePackages ? null,
  fish-na,
  ...
}:
{
  imports = [
    # AI tools
    ./ai-tools.nix

    # Fish shell plugin configuration
    (import ./fish {
      inherit
        pkgs
        fish-na
        lib
        config
        ;
    })

    # Claude Code configuration
    (import ./claude-code {
      inherit
        pkgs
        lib
        config
        dotfilesDir
        ;
    })

    # Codex configuration
    (import ./codex.nix {
      inherit
        pkgs
        lib
        config
        dotfilesDir
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
        helpers
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
        nodePackages
        ;
    })

    # Cursor CLI configuration
    ./cursor.nix

    # Ghostty terminal configuration
    ./ghostty.nix

    # Bat configuration
    ./bat.nix

    # Direnv configuration with nix-direnv
    ./direnv.nix

    # jj configuration
    (import ./jj.nix {
      inherit
        pkgs
        lib
        config
        helpers
        ;
    })

    # Lazygit configuration
    (import ./lazygit {
      inherit
        pkgs
        lib
        ;
    })

    # OpenCode configuration
    (import ./opencode {
      inherit
        pkgs
        lib
        config
        ;
    })

    # Pip configuration
    ./pip.nix
  ];
}
