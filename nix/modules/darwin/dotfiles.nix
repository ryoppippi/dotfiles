{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  helpers,
  ...
}:
let
  inherit (config.home) homeDirectory;
in
{
  # macOS-specific dotfile symlinks
  home.activation.linkDotfilesDarwin = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
        ${helpers.activation.mkLinkForce}

      # Homebrew bundle file
      link_force "${dotfilesDir}/Brewfile" "${homeDirectory}/.Brewfile"

      # Xcode key bindings
      $DRY_RUN_CMD mkdir -p "${homeDirectory}/Library/Developer/Xcode/UserData/KeyBindings"
      link_force "${dotfilesDir}/xcode/Default.idekeybindings" "${homeDirectory}/Library/Developer/Xcode/UserData/KeyBindings/Default.idekeybindings"

      # Pip configuration (macOS paths)
      $DRY_RUN_CMD mkdir -p "${homeDirectory}/Library/Application Support/pip"
      link_force "${dotfilesDir}/pip/pip.conf" "${homeDirectory}/Library/Application Support/pip/pip.conf"
    ''
  );
}
