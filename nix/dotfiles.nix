{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
let
  homeDir = config.home.homeDirectory;
  configHome = config.xdg.configHome;
  helpers = import ./lib/activation-helpers.nix { inherit lib; };
in
{
  # Create direct symlinks to dotfiles (bypassing Nix store)
  # Run after linkGeneration to ensure Home Manager files are in place first
  home.activation.linkDotfiles = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    ${helpers.mkLinkForce}

    # Hammerspoon configuration (macOS only, but harmless on Linux)
    link_force "${dotfilesDir}/hammerspoon" "${homeDir}/.hammerspoon"

    # Homebrew bundle file (macOS only, but harmless on Linux)
    link_force "${dotfilesDir}/Brewfile" "${homeDir}/.Brewfile"

    # IdeaVim configuration
    link_force "${dotfilesDir}/ideavimrc" "${homeDir}/.ideavimrc"

    # LazyGit configuration
    $DRY_RUN_CMD mkdir -p "${configHome}"
    link_force "${dotfilesDir}/lazygit" "${configHome}/lazygit"

    # Fish shell configuration
    link_force "${dotfilesDir}/fish" "${configHome}/fish"

    # Zsh environment
    link_force "${dotfilesDir}/zshenv" "${homeDir}/.zshenv"

    # Aqua package manager configuration
    link_force "${dotfilesDir}/aqua" "${configHome}/aquaproj-aqua"

    # Zed editor configuration
    $DRY_RUN_CMD mkdir -p "${configHome}/zed"
    link_force "${dotfilesDir}/zed/settings.json" "${configHome}/zed/settings.json"

    # Karabiner Elements configuration (macOS only, but harmless on Linux)
    link_force "${dotfilesDir}/karabiner" "${configHome}/karabiner"

    # WezTerm configuration
    link_force "${dotfilesDir}/wezterm" "${configHome}/wezterm"

    # Bash profile
    link_force "${dotfilesDir}/bash/.bash_profile" "${homeDir}/.bash_profile"

    # Starship prompt configuration
    link_force "${dotfilesDir}/starship.toml" "${configHome}/starship.toml"

    # Bat configuration
    link_force "${dotfilesDir}/bat" "${configHome}/bat"

    # Scripts directory
    link_force "${dotfilesDir}/my_scripts" "${homeDir}/.scripts"

    # Finicky configuration (macOS only, but harmless on Linux)
    link_force "${dotfilesDir}/finicky.js" "${homeDir}/.finicky.js"

    # Xcode key bindings (macOS only, but harmless on Linux)
    $DRY_RUN_CMD mkdir -p "${homeDir}/Library/Developer/Xcode/UserData/KeyBindings"
    link_force "${dotfilesDir}/xcode/Default.idekeybindings" "${homeDir}/Library/Developer/Xcode/UserData/KeyBindings/Default.idekeybindings"

    # Yabai window manager (macOS only, but harmless on Linux)
    link_force "${dotfilesDir}/yabai" "${configHome}/yabai"

    # Skhd hotkey daemon (macOS only, but harmless on Linux)
    link_force "${dotfilesDir}/skhd" "${configHome}/skhd"

    # Pip configuration
    $DRY_RUN_CMD mkdir -p "${homeDir}/Library/Application Support/pip"
    link_force "${dotfilesDir}/pip/pip.conf" "${homeDir}/Library/Application Support/pip/pip.conf"
    $DRY_RUN_CMD mkdir -p "${homeDir}/.pip"
    link_force "${dotfilesDir}/pip/pip.conf" "${homeDir}/.pip/pip.conf"

    # Docker configuration
    $DRY_RUN_CMD mkdir -p "${homeDir}/.docker"
    link_force "${dotfilesDir}/docker/config.json" "${homeDir}/.docker/config.json"

    # EFM Language Server configuration
    link_force "${dotfilesDir}/efm-langserver" "${configHome}/efm-langserver"

    # Jujutsu VCS configuration
    link_force "${dotfilesDir}/jj" "${configHome}/jj"

    # OpenCode configuration
    link_force "${dotfilesDir}/opencode" "${configHome}/opencode"

    # Cursor configuration
    $DRY_RUN_CMD mkdir -p "${configHome}/cursor"
    link_force "${dotfilesDir}/cursor/cli-config.json" "${configHome}/cursor/cli-config.json"

    # Zsh configuration
    link_force "${dotfilesDir}/zsh/zshrc" "${homeDir}/.zshrc"

    # Bash configuration
    link_force "${dotfilesDir}/bash/.bashrc" "${homeDir}/.bashrc"

    # Git configuration
    link_force "${dotfilesDir}/git" "${configHome}/git"

    # Ghostty terminal configuration (macOS only, but harmless on Linux)
    link_force "${dotfilesDir}/ghostty" "${configHome}/ghostty"
  '';
}
