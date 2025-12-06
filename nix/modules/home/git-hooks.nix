{
  pkgs,
  lib,
  config,
  dotfilesDir,
  ...
}:
{
  # Install lefthook git hooks via Home Manager activation
  home.activation.installGitHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DOTFILES_DIR="${dotfilesDir}"
    if [ -d "$DOTFILES_DIR/.git" ] && [ -f "$DOTFILES_DIR/lefthook.yml" ]; then
      echo "📦 Installing lefthook git hooks for dotfiles..."
      cd "$DOTFILES_DIR" && ${pkgs.lefthook}/bin/lefthook install
      echo "✅ Lefthook git hooks installed successfully!"
    fi
  '';
}
