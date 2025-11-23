{
  pkgs,
  lib,
  config,
  dotfilesDir,
  treefmt-nix ? null,
  ...
}:
let
  # Post-checkout/merge hook for Nix auto-apply
  nixApplyHook = pkgs.writeShellScript "nix-apply-hook" ''
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

  # Pre-commit hook for formatting and linting
  preCommitHook = pkgs.writeShellScript "pre-commit-hook" ''
    #!/usr/bin/env bash
    set -e

    # Get list of staged files
    files=$(git diff --cached --name-only --diff-filter=ACM)

    if [ -z "$files" ]; then
      exit 0
    fi

    # Run treefmt via nix run .#fmt on staged files
    echo "🎨 Formatting staged files..."
    cd ${dotfilesDir}
    echo "$files" | xargs -r ${pkgs.nix}/bin/nix run .#fmt -- || {
      echo "❌ Formatting failed. Please fix the issues and try again."
      exit 1
    }
    # Re-add formatted files
    echo "$files" | xargs -r ${pkgs.git}/bin/git add

    # Run secretlint on all tracked files (as original does)
    echo "🔒 Checking for secrets..."
    all_files=$(${pkgs.git}/bin/git ls-files)
    if [ -n "$all_files" ]; then
      if command -v secretlint &> /dev/null; then
        secretlint $all_files || {
          echo "❌ Secret check failed. Please remove sensitive data and try again."
          exit 1
        }
      else
        echo "⚠️  secretlint not found (install via aqua), skipping secret check"
      fi
    fi

    echo "✅ Pre-commit checks passed"
  '';
in
{
  # Install git hooks via Home Manager activation
  home.activation.installGitHooks = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DOTFILES_DIR="${dotfilesDir}"
    if [ -d "$DOTFILES_DIR/.git" ]; then
      echo "📦 Installing git hooks for dotfiles..."

      # Create hooks directory if it doesn't exist
      mkdir -p "$DOTFILES_DIR/.git/hooks"

      # Unset core.hooksPath to use default .git/hooks
      cd "$DOTFILES_DIR" && ${pkgs.git}/bin/git config --unset core.hooksPath || true

      # Install pre-commit hook
      cat > "$DOTFILES_DIR/.git/hooks/pre-commit" <<'EOF'
    ${builtins.readFile preCommitHook}
    EOF
      chmod +x "$DOTFILES_DIR/.git/hooks/pre-commit"

      # Install post-checkout hook
      cat > "$DOTFILES_DIR/.git/hooks/post-checkout" <<'EOF'
    ${builtins.readFile nixApplyHook}
    EOF
      chmod +x "$DOTFILES_DIR/.git/hooks/post-checkout"

      # Install post-merge hook
      cat > "$DOTFILES_DIR/.git/hooks/post-merge" <<'EOF'
    ${builtins.readFile nixApplyHook}
    EOF
      chmod +x "$DOTFILES_DIR/.git/hooks/post-merge"

      echo "✅ Git hooks installed successfully!"
    fi
  '';
}
