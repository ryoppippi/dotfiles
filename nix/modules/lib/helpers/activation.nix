_: {
  # Helper function to safely create symlinks in activation scripts
  # Removes existing files/directories/links before creating new symlinks
  # to avoid circular symlink issues when target directory already exists
  mkLinkForce = ''
    link_force() {
      local src=$1
      local dst=$2
      $DRY_RUN_CMD rm -rf "$dst"
      $DRY_RUN_CMD ln -sf "$src" "$dst"
    }
  '';
}
