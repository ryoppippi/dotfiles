{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  helpers,
  ...
}:
let
  homeDir = config.home.homeDirectory;
  configHome = config.xdg.configHome;
in
{
  # Common dotfile symlinks for all platforms
  home.activation.linkDotfilesCommon = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${helpers.activation.mkLinkForce}

    # IdeaVim configuration
    link_force "${dotfilesDir}/ideavimrc" "${homeDir}/.ideavimrc"

    # LazyGit configuration
    $DRY_RUN_CMD mkdir -p "${configHome}"
    link_force "${dotfilesDir}/lazygit" "${configHome}/lazygit"

    # Fish shell configuration
    link_force "${dotfilesDir}/fish" "${configHome}/fish"

    # Zsh environment
    link_force "${dotfilesDir}/zshenv" "${homeDir}/.zshenv"

    # Zsh configuration
    link_force "${dotfilesDir}/zsh/zshrc" "${homeDir}/.zshrc"

    # Bash configuration
    link_force "${dotfilesDir}/bash/.bash_profile" "${homeDir}/.bash_profile"
    link_force "${dotfilesDir}/bash/.bashrc" "${homeDir}/.bashrc"

    # Aqua package manager configuration
    link_force "${dotfilesDir}/aqua" "${configHome}/aquaproj-aqua"

    # Zed editor configuration
    $DRY_RUN_CMD mkdir -p "${configHome}/zed"
    link_force "${dotfilesDir}/zed/settings.json" "${configHome}/zed/settings.json"

    # WezTerm configuration
    link_force "${dotfilesDir}/wezterm" "${configHome}/wezterm"

    # Starship prompt configuration
    link_force "${dotfilesDir}/starship.toml" "${configHome}/starship.toml"

    # Bat configuration
    link_force "${dotfilesDir}/bat" "${configHome}/bat"

    # Scripts directory
    link_force "${dotfilesDir}/my_scripts" "${homeDir}/.scripts"

    # EFM Language Server configuration
    link_force "${dotfilesDir}/efm-langserver" "${configHome}/efm-langserver"

    # Jujutsu VCS configuration
    link_force "${dotfilesDir}/jj" "${configHome}/jj"

    # OpenCode configuration
    link_force "${dotfilesDir}/opencode" "${configHome}/opencode"

    # Pip fallback location (both platforms)
    $DRY_RUN_CMD mkdir -p "${homeDir}/.pip"
    link_force "${dotfilesDir}/pip/pip.conf" "${homeDir}/.pip/pip.conf"
  '';
}
