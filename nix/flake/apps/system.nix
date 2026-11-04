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

      # hosts/linux.nix registers one Home Manager configuration per
      # architecture, so the bare username is the x86_64 one.
      homeConfigName = if pkgs.stdenv.hostPlatform.isAarch64 then "${username}-aarch64" else username;
      darwinRebuild = lib.getExe inputs.nix-darwin.packages.${system}.darwin-rebuild;
      nom = lib.getExe pkgs.nix-output-monitor;

      kind = if isDarwin then "darwin" else "Home Manager";
      buildTarget =
        if isDarwin then
          "darwinConfigurations.${hostname}.system"
        else
          "homeConfigurations.${homeConfigName}.activationPackage";

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

      nixBuildFlags = lib.optionalString isDarwin " --accept-flake-config";
      darwinBuildFlags = lib.optionalString isDarwin " --option accept-flake-config true";

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

              def --wrapped main [...args: string] {
                print "Building ${kind} configuration..."
                if (is-ai-agent) {
                  ^nix build .#${buildTarget}${nixBuildFlags} ...$args
                } else {
                  ^${nom} build .#${buildTarget}${nixBuildFlags} ...$args
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

              def --wrapped main [...args: string] {
                ${lib.optionalString isDarwin "keep-sudo-alive"}
                print "Building and switching to ${kind} configuration..."
                if (is-ai-agent) {
                  ${
                    if isDarwin then
                      "^sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags} ...$args"
                    else
                      "^nix run nixpkgs#home-manager -- switch --flake .#${homeConfigName} ...$args"
                  }
                } else {
                  ${
                    if isDarwin then
                      "^sudo ${darwinRebuild} switch --flake .#${hostname}${darwinBuildFlags} ...$args o+e>| ^${nom}"
                    else
                      "^nix run nixpkgs#home-manager -- switch --flake .#${homeConfigName} ...$args o+e>| ^${nom}"
                  }
                }
                ${lib.optionalString isDarwin "^/run/current-system/brew-bundle"}
                print "Done!"
              }
            ''
          );
        };
      };
    };
}
