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
  # Linux-specific dotfile symlinks
  home.file = lib.mkIf (!pkgs.stdenv.isDarwin) {
    # Pip configuration (Linux paths)
    ".config/pip/pip.conf".source = mkLink "${dotfilesDir}/pip/pip.conf";

    # Ghostty terminal configuration
    ".config/ghostty".source = mkLink "${dotfilesDir}/ghostty";
  };
}
