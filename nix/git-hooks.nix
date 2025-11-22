{
  pkgs,
  lib,
  config,
  dotfilesDir,
  ...
}: let
  hookScript = pkgs.writeShellScript "nix-apply-hook" ''
    #!/usr/bin/env bash
    set -e

    # Check if environment variable is set
    check() {
      [ -n "''${!1}" ]
    }

    # Check if running in CI environment
    is_in_ci() {
      check CI || check CONTINUOUS_INTEGRATION || check GITHUB_ACTIONS
    }

    # Skip in CI environments
    if is_in_ci; then
      echo "⏭️  Skipping Nix apply in CI environment"
      exit 0
    fi

    # Check if Nix configuration files were changed
    if git diff HEAD@{1}..HEAD --name-only 2>/dev/null | grep -E '^(flake.nix|flake.lock|nix/|aqua/aqua.yaml)' > /dev/null; then
      echo "🔧 Nix configuration changed. Applying changes..."
      nix run ${dotfilesDir}#switch
    fi
  '';
in {
  # Install git hooks via Home Manager activation
  home.activation.installGitHooks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    DOTFILES_DIR="${dotfilesDir}"
    if [ -d "$DOTFILES_DIR/.git" ]; then
      echo "📦 Installing git hooks for dotfiles..."

      # Create hooks directory if it doesn't exist
      mkdir -p "$DOTFILES_DIR/.git/hooks"

      # Install post-checkout hook
      cat > "$DOTFILES_DIR/.git/hooks/post-checkout" <<'EOF'
    ${builtins.readFile hookScript}
    EOF
      chmod +x "$DOTFILES_DIR/.git/hooks/post-checkout"

      # Install post-merge hook
      cat > "$DOTFILES_DIR/.git/hooks/post-merge" <<'EOF'
    ${builtins.readFile hookScript}
    EOF
      chmod +x "$DOTFILES_DIR/.git/hooks/post-merge"

      echo "✅ Git hooks installed successfully!"
    fi
  '';
}
