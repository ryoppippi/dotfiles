{ inputs, constants, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      ...
    }:
    let
      inherit (constants) username;
      inherit (pkgs.stdenv.hostPlatform) isDarwin;

      hostname = username;
      darwinRebuild = lib.getExe inputs.nix-darwin.packages.${system}.darwin-rebuild;
      nom = lib.getExe pkgs.nix-output-monitor;

      kind = if isDarwin then "darwin" else "Home Manager";
      buildTarget =
        if isDarwin then
          "darwinConfigurations.${hostname}.system"
        else
          "homeConfigurations.${username}.activationPackage";

      # Detect AI agent environments to skip nix-output-monitor
      isAgentCheck = ''
        IS_AI_AGENT=false
        for var in CLAUDE_CODE CLAUDECODE CODEX_SANDBOX CODEX_THREAD_ID GEMINI_CLI OPENCODE AUGMENT_AGENT GOOSE_PROVIDER CURSOR_AGENT AI_AGENT; do
          eval "val=\''${!var:-}"
          if [ -n "$val" ]; then
            IS_AI_AGENT=true
            break
          fi
        done
      '';
      nixBuildFlags = lib.optionalString isDarwin " --accept-flake-config --print-build-logs --show-trace";
      darwinBuildFlags = lib.optionalString isDarwin " --option accept-flake-config true --print-build-logs --show-trace";
      sudoKeepAlive = lib.optionalString isDarwin ''
        if [ -t 0 ]; then
          sudo -v
          (
            while kill -0 "$$" 2>/dev/null; do
              sudo -n -v || exit 0
              sleep 60
            done
          ) &
          SUDO_KEEPALIVE_PID=$!
          trap 'kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true' EXIT
        fi
      '';
    in
    {
      apps = {
        build = {
          type = "app";
          program = toString (
            pkgs.writeShellScript (if isDarwin then "darwin-build" else "home-manager-build") ''
              set -e
              ${isAgentCheck}
              echo "Building ${kind} configuration..."
              if [ "$IS_AI_AGENT" = true ]; then
                nix build .#${buildTarget}${nixBuildFlags}
              else
                ${nom} build .#${buildTarget}${nixBuildFlags}
              fi
              echo "Build successful! Run 'nix run .#switch' to apply."
            ''
          );
        };

        switch = {
          type = "app";
          program = toString (
            pkgs.writeShellScript (if isDarwin then "darwin-switch" else "home-manager-switch") ''
              set -eo pipefail
              ${isAgentCheck}
              ${sudoKeepAlive}
              echo "Building and switching to ${kind} configuration..."
              if [ "$IS_AI_AGENT" = true ]; then
                ${
                  if isDarwin then
                    "sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags}"
                  else
                    "nix run nixpkgs#home-manager -- switch --flake .#${username}"
                }
              else
                ${
                  if isDarwin then
                    "sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags} |& ${nom}"
                  else
                    "nix run nixpkgs#home-manager -- switch --flake .#${username} |& ${nom}"
                }
              fi
              echo "Clearing fish cache..."
              rm -rf "$TMPDIR/fish-cache"
              echo "Done!"
            ''
          );
        };
      };
    };
}
