{
  pkgs,
  lib,
  config,
  ...
}:
let
  opencodeConfigDir = "${config.xdg.configHome}/opencode";
  checkJsonschema = lib.getExe pkgs.check-jsonschema;
  jq = lib.getExe pkgs.jq;

  settingsJsonText = builtins.readFile ./settings.json;
  settingsFile = builtins.toFile "opencode-settings.json" settingsJsonText;
  tuiSettingsJsonText = builtins.readFile ./tui.json;
in
{
  home.packages = lib.mkAfter [ pkgs.llm-agents.opencode ];

  xdg.configFile."opencode/tui.json" = {
    text = tuiSettingsJsonText;
    force = true;
  };

  home.activation.configureOpenCodeSettings =
    lib.hm.dag.entryAfter
      ([ "linkGeneration" ] ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin "installCmuxHooks")
      ''
        SETTINGS_FILE="${opencodeConfigDir}/opencode.json"
        mkdir -p "${opencodeConfigDir}"

        if [ -f "$SETTINGS_FILE" ]; then
          TEMP_FILE="$(mktemp "${opencodeConfigDir}/.opencode.json.XXXXXX")"
          if ! ${jq} -s '.[0] * .[1]' "$SETTINGS_FILE" "${settingsFile}" > "$TEMP_FILE"; then
            rm -f "$TEMP_FILE"
            exit 1
          fi
          mv "$TEMP_FILE" "$SETTINGS_FILE"
        else
          cp "${settingsFile}" "$SETTINGS_FILE"
        fi
      '';

  home.activation.validateOpenCodeSettings = lib.hm.dag.entryAfter [ "configureOpenCodeSettings" ] ''
    SETTINGS_FILE="${opencodeConfigDir}/opencode.json"
    SCHEMA_URL=$(${jq} -r '.["$schema"]' "$SETTINGS_FILE")

    echo "🔍 Validating OpenCode opencode.json..."
    if ${checkJsonschema} --schemafile "$SCHEMA_URL" "$SETTINGS_FILE" 2>&1; then
      echo "✅ OpenCode opencode.json validation passed"
    else
      echo "❌ OpenCode opencode.json validation failed" >&2
      exit 1
    fi
  '';
}
