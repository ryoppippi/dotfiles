{
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  helpers,
  ...
}:
let
  inherit (config.home) homeDirectory;
  inherit (config.xdg) configHome;
in
{
  # Common dotfile symlinks for all platforms
  home.activation.linkDotfilesCommon = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${helpers.activation.mkLinkForce}

    # IdeaVim configuration
    link_force "${dotfilesDir}/ideavimrc" "${homeDirectory}/.ideavimrc"

    # Fish shell configuration
    link_force "${dotfilesDir}/fish" "${configHome}/fish"

    # Zsh environment
    link_force "${dotfilesDir}/zshenv" "${homeDirectory}/.zshenv"

    # Zsh configuration
    link_force "${dotfilesDir}/zsh/zshrc" "${homeDirectory}/.zshrc"

    # Bash configuration
    link_force "${dotfilesDir}/bash/.bash_profile" "${homeDirectory}/.bash_profile"
    link_force "${dotfilesDir}/bash/.bashrc" "${homeDirectory}/.bashrc"

    # Aqua package manager configuration
    link_force "${dotfilesDir}/aqua" "${configHome}/aquaproj-aqua"

    # WezTerm configuration
    link_force "${dotfilesDir}/wezterm" "${configHome}/wezterm"

    # Scripts directory
    link_force "${dotfilesDir}/my_scripts" "${homeDirectory}/.scripts"

    # EFM Language Server configuration
    link_force "${dotfilesDir}/efm-langserver" "${configHome}/efm-langserver"

    # Pip fallback location (both platforms)
    $DRY_RUN_CMD mkdir -p "${homeDirectory}/.pip"
    link_force "${dotfilesDir}/pip/pip.conf" "${homeDirectory}/.pip/pip.conf"
  '';
}
