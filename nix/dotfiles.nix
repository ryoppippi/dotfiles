{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}: let
  homeDir = config.home.homeDirectory;
  configHome = config.xdg.configHome;
in {
  # Create direct symlinks to dotfiles (bypassing Nix store)
  home.activation.linkDotfiles = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Hammerspoon configuration (macOS only, but harmless on Linux)
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/hammerspoon" "${homeDir}/.hammerspoon"

    # Homebrew bundle file (macOS only, but harmless on Linux)
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/Brewfile" "${homeDir}/.Brewfile"

    # IdeaVim configuration
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/ideavimrc" "${homeDir}/.ideavimrc"

    # LazyGit configuration
    $DRY_RUN_CMD mkdir -p "${configHome}"
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/lazygit" "${configHome}/lazygit"

    # Fish shell configuration
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/fish" "${configHome}/fish"

    # Zsh environment
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/zshenv" "${homeDir}/.zshenv"

    # Aqua package manager configuration
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/aqua" "${configHome}/aquaproj-aqua"

    # Zed editor configuration
    $DRY_RUN_CMD mkdir -p "${configHome}/zed"
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/zed/settings.json" "${configHome}/zed/settings.json"

    # Karabiner Elements configuration (macOS only, but harmless on Linux)
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/karabiner" "${configHome}/karabiner"

    # WezTerm configuration
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/wezterm" "${configHome}/wezterm"

    # Bash profile
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/bash/.bash_profile" "${homeDir}/.bash_profile"

    # Starship prompt configuration
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/starship.toml" "${configHome}/starship.toml"

    # Bat configuration
    $DRY_RUN_CMD ln -sf "${dotfilesDir}/bat" "${configHome}/bat"
  '';
}
