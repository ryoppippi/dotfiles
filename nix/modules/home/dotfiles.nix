{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
let
  mkLink = config.lib.file.mkOutOfStoreSymlink;
in
{
  # Common dotfile symlinks for all platforms
  home.file = {
    # IdeaVim configuration
    ".ideavimrc".source = mkLink "${dotfilesDir}/ideavimrc";

    # Fish shell configuration
    ".config/fish".source = mkLink "${dotfilesDir}/fish";

    # Zsh environment
    ".zshenv".source = mkLink "${dotfilesDir}/zshenv";

    # Zsh configuration
    ".zshrc".source = mkLink "${dotfilesDir}/zsh/zshrc";

    # Bash configuration
    ".bash_profile".source = mkLink "${dotfilesDir}/bash/.bash_profile";
    ".bashrc".source = mkLink "${dotfilesDir}/bash/.bashrc";

    # Aqua package manager configuration
    ".config/aquaproj-aqua".source = mkLink "${dotfilesDir}/aqua";

    # WezTerm configuration
    ".config/wezterm".source = mkLink "${dotfilesDir}/wezterm";

    # Scripts directory
    ".scripts".source = mkLink "${dotfilesDir}/my_scripts";

    # EFM Language Server configuration
    ".config/efm-langserver".source = mkLink "${dotfilesDir}/efm-langserver";

    # Pip fallback location (both platforms)
    ".pip/pip.conf".source = mkLink "${dotfilesDir}/pip/pip.conf";
  };
}
