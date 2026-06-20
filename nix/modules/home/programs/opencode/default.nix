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

  # Read settings from external JSON file
  settingsJsonText = builtins.readFile ./settings.json;
  tuiSettingsJsonText = builtins.readFile ./tui.json;
in
{
  # OpenCode package
  home.packages = lib.mkAfter [ pkgs.llm-agents.opencode ];

  # Generate opencode.json from settings file
  xdg.configFile."opencode/opencode.json" = {
    text = settingsJsonText;
  };
  xdg.configFile."opencode/tui.json" = {
    text = tuiSettingsJsonText;
    force = true;
  };

  # Validate OpenCode opencode.json after generation
  home.activation.validateOpenCodeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
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
