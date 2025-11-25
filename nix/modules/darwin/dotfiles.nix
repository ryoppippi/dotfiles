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
  # macOS-specific dotfile symlinks
  home.activation.linkDotfilesDarwin = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.optionalString pkgs.stdenv.isDarwin ''
        ${helpers.activation.mkLinkForce}

      # Hammerspoon configuration
      link_force "${dotfilesDir}/hammerspoon" "${homeDir}/.hammerspoon"

      # Homebrew bundle file
      link_force "${dotfilesDir}/Brewfile" "${homeDir}/.Brewfile"

      # Karabiner Elements configuration
      link_force "${dotfilesDir}/karabiner" "${configHome}/karabiner"

      # Finicky configuration
      link_force "${dotfilesDir}/finicky.js" "${homeDir}/.finicky.js"

      # Xcode key bindings
      $DRY_RUN_CMD mkdir -p "${homeDir}/Library/Developer/Xcode/UserData/KeyBindings"
      link_force "${dotfilesDir}/xcode/Default.idekeybindings" "${homeDir}/Library/Developer/Xcode/UserData/KeyBindings/Default.idekeybindings"

      # Yabai window manager
      link_force "${dotfilesDir}/yabai" "${configHome}/yabai"

      # Skhd hotkey daemon
      link_force "${dotfilesDir}/skhd" "${configHome}/skhd"

      # Pip configuration (macOS paths)
      $DRY_RUN_CMD mkdir -p "${homeDir}/Library/Application Support/pip"
      link_force "${dotfilesDir}/pip/pip.conf" "${homeDir}/Library/Application Support/pip/pip.conf"
    ''
  );
}
