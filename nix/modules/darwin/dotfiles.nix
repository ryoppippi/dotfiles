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
  # macOS-specific dotfile symlinks
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    # Hammerspoon configuration
    ".hammerspoon".source = mkLink "${dotfilesDir}/hammerspoon";

    # Homebrew bundle file
    ".Brewfile".source = mkLink "${dotfilesDir}/Brewfile";

    # Karabiner Elements configuration
    ".config/karabiner".source = mkLink "${dotfilesDir}/karabiner";

    # Finicky configuration
    ".finicky.js".source = mkLink "${dotfilesDir}/finicky.js";

    # Xcode key bindings
    "Library/Developer/Xcode/UserData/KeyBindings/Default.idekeybindings".source =
      mkLink "${dotfilesDir}/xcode/Default.idekeybindings";

    # Yabai window manager
    ".config/yabai".source = mkLink "${dotfilesDir}/yabai";

    # Skhd hotkey daemon
    ".config/skhd".source = mkLink "${dotfilesDir}/skhd";

    # Pip configuration (macOS paths)
    "Library/Application Support/pip/pip.conf".source = mkLink "${dotfilesDir}/pip/pip.conf";
  };
}
