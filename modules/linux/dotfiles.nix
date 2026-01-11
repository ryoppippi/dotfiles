{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  helpers,
  ...
}:
let
  inherit (config.xdg) configHome;
in
{
  # Linux-specific dotfile symlinks
  home.activation.linkDotfilesLinux = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.optionalString (!pkgs.stdenv.isDarwin) ''
      ${helpers.activation.mkLinkForce}

      # Pip configuration (Linux paths)
      $DRY_RUN_CMD mkdir -p "${configHome}/pip"
      link_force "${dotfilesDir}/pip/pip.conf" "${configHome}/pip/pip.conf"

      # Ghostty terminal configuration
      link_force "${dotfilesDir}/ghostty" "${configHome}/ghostty"
    ''
  );
}
