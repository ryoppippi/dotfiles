{ inputs, constants, ... }:
{
  perSystem =
    {
      pkgs,
      lib,
      system,
      writeNu,
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

      # nix-output-monitor redraws a live TUI, which is unreadable once it lands
      # in an agent transcript, so agents get the plain builder output instead.
      isAgentCheck = ''
        def is-ai-agent [] {
          [
            CLAUDE_CODE
            CLAUDECODE
            CODEX_SANDBOX
            CODEX_THREAD_ID
            GEMINI_CLI
            OPENCODE
            AUGMENT_AGENT
            GOOSE_PROVIDER
            CURSOR_AGENT
            AI_AGENT
          ] | any {|name| $env | get --optional $name | default "" | is-not-empty }
        }
      '';

      nixBuildFlags = lib.optionalString isDarwin " --accept-flake-config --print-build-logs --show-trace";
      darwinBuildFlags = lib.optionalString isDarwin " --option accept-flake-config true --print-build-logs --show-trace";

      # A full rebuild outlasts sudo's timestamp timeout, so keep refreshing it.
      # The job is a thread inside this process rather than bash's detached
      # subshell, so it needs no exit trap — it dies when the script does.
      sudoKeepAlive = lib.optionalString isDarwin ''
        def keep-sudo-alive [] {
          if (is-terminal --stdin) {
            ^sudo --validate
            job spawn {
              loop {
                sleep 60sec
                try { ^sudo --non-interactive --validate } catch { break }
              }
            } | ignore
          }
        }
      '';
    in
    {
      apps = {
        build = {
          type = "app";
          program = toString (
            writeNu (if isDarwin then "darwin-build" else "home-manager-build") ''
              ${isAgentCheck}

              def main [] {
                print "Building ${kind} configuration..."
                if (is-ai-agent) {
                  ^nix build .#${buildTarget}${nixBuildFlags}
                } else {
                  ^${nom} build .#${buildTarget}${nixBuildFlags}
                }
                print "Build successful! Run 'nix run .#switch' to apply."
              }
            ''
          );
        };

        switch = {
          type = "app";
          program = toString (
            writeNu (if isDarwin then "darwin-switch" else "home-manager-switch") ''
              ${isAgentCheck}
              ${sudoKeepAlive}

              def main [] {
                ${lib.optionalString isDarwin "keep-sudo-alive"}
                print "Building and switching to ${kind} configuration..."
                if (is-ai-agent) {
                  ${
                    if isDarwin then
                      "^sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags}"
                    else
                      "^nix run nixpkgs#home-manager -- switch --flake .#${username}"
                  }
                } else {
                  ${
                    if isDarwin then
                      "^sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags} o+e>| ^${nom}"
                    else
                      "^nix run nixpkgs#home-manager -- switch --flake .#${username} o+e>| ^${nom}"
                  }
                }
                print "Clearing fish cache..."
                let tmpdir = $env | get --optional TMPDIR | default ""
                if ($tmpdir | is-not-empty) {
                  rm --recursive --force ($tmpdir | path join "fish-cache")
                }
                print "Done!"
              }
            ''
          );
        };
      };
    };
}
