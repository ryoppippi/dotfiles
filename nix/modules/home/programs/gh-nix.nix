{ pkgs, ... }:
let
  # gh-nix: run any command with a GitHub token bridged into Nix's
  # `access-tokens` setting, so Nix can authenticate GitHub-backed flake and
  # fetch operations and avoid the aggressive unauthenticated rate limit.
  #
  # The token is read at runtime from `gh auth token` (gh's keyring/config),
  # never written to shell history, command arguments, or nix.conf. It is
  # prepended to any existing NIX_CONFIG so other settings are preserved.
  #
  # Usage:
  #   gh-nix nix flake update
  #   gh-nix nix run .#build
  gh-nix = pkgs.writeShellApplication {
    name = "gh-nix";
    runtimeInputs = [ pkgs.gh ];
    text = ''
      if [ "$#" -eq 0 ]; then
        echo "usage: gh-nix <command> [args...]" >&2
        exit 2
      fi

      if ! gh auth status >/dev/null 2>&1; then
        echo "gh-nix: gh is not authenticated; run 'gh auth login'" >&2
        exit 1
      fi

      # Prepend our access-tokens line; keep any existing NIX_CONFIG on the
      # following lines (NIX_CONFIG is newline-separated key = value entries).
      exec env NIX_CONFIG="access-tokens = github.com=$(gh auth token)
      ''${NIX_CONFIG:-}" "$@"
    '';
  };
in
{
  home.packages = [ gh-nix ];
}
