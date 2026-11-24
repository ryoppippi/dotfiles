{
  pkgs,
  lib,
  config,
  ...
}:
let
  jq = lib.getExe pkgs.jq;

  telemetryEnv = {
    ORCA_TELEMETRY_DISABLED = "1";
    DO_NOT_TRACK = "1";
  };

  # Every Claude profile the agents run under, so Agent Session History lists
  # all of them. Orca otherwise scans only its own CLAUDE_CONFIG_DIR and the
  # folders it has seen a hooked session write to.
  claudeConfigDirs = [
    config.home.sessionVariables.CLAUDE_CONFIG_DIR
    "${config.xdg.configHome}/claude-personal-0"
    "${config.xdg.configHome}/claude-personal-1"
  ];
in
{
  home.sessionVariables = telemetryEnv;

  # Apps launched from the Dock do not inherit shell session variables, and
  # Orca decides telemetry consent from its own environment.
  launchd.agents.orca-env = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        (lib.concatStringsSep "; " (
          lib.mapAttrsToList (name: value: "/bin/launchctl setenv ${name} ${value}") telemetryEnv
        ))
      ];
      RunAtLoad = true;
    };
  };

  # Orca keeps the folders it has observed in this file and prepends new ones,
  # so the declared folders are merged in rather than replacing the list.
  home.activation.seedOrcaClaudeConfigDirs = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      ORCA_DATA="$HOME/Library/Application Support/orca"
      OBSERVED="$ORCA_DATA/claude-observed-config-dirs.json"
      DECLARED='${builtins.toJSON claudeConfigDirs}'
      mkdir -p "$ORCA_DATA"
      if [ -f "$OBSERVED" ]; then
        MERGED="$(${jq} -c --argjson declared "$DECLARED" '. + ($declared - .)' "$OBSERVED")"
      else
        MERGED="$DECLARED"
      fi
      TEMP_FILE="$(mktemp "$ORCA_DATA/.claude-observed-config-dirs.XXXXXX")"
      printf '%s' "$MERGED" > "$TEMP_FILE"
      chmod 600 "$TEMP_FILE"
      mv "$TEMP_FILE" "$OBSERVED"
    ''
  );

  # Orca's managed Claude accounts all share the login shell's
  # CLAUDE_CONFIG_DIR projects folder, so sessions recorded under the personal
  # profiles could be listed but not resumed. Linking each transcript entry
  # into that folder lets any account resume them; the originals stay put.
  home.activation.linkClaudeTranscriptsForOrca = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
    lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      SHARED="${config.home.sessionVariables.CLAUDE_CONFIG_DIR}/projects"
      for SOURCE in ${
        lib.escapeShellArgs (
          map (dir: "${dir}/projects") (
            lib.remove config.home.sessionVariables.CLAUDE_CONFIG_DIR claudeConfigDirs
          )
        )
      }; do
        [ -d "$SOURCE" ] || continue
        for SLUG_DIR in "$SOURCE"/*/; do
          SLUG="$(basename "$SLUG_DIR")"
          mkdir -p "$SHARED/$SLUG"
          for ENTRY in "$SLUG_DIR"*; do
            [ -e "$ENTRY" ] || continue
            TARGET="$SHARED/$SLUG/$(basename "$ENTRY")"
            [ -e "$TARGET" ] || [ -L "$TARGET" ] || ln -s "$ENTRY" "$TARGET"
          done
        done
      done
    ''
  );
}
