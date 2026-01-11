{
  pkgs,
  lib,
  config,
  ...
}:
let
  opencodeConfigDir = "${config.xdg.configHome}/opencode";

  # Read settings from external JSON file
  settingsJsonText = builtins.readFile ./settings.json;
in
{
  # OpenCode package
  home.packages = lib.mkAfter [ pkgs.opencode ];

  # Generate opencode.json from settings file
  xdg.configFile."opencode/opencode.json" = {
    text = settingsJsonText;
  };

  # Validate OpenCode opencode.json after generation
  home.activation.validateOpenCodeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS_FILE="${opencodeConfigDir}/opencode.json"
    SCHEMA_URL=$(${pkgs.jq}/bin/jq -r '.["$schema"]' "$SETTINGS_FILE")

    echo "🔍 Validating OpenCode opencode.json..."
    if ${pkgs.check-jsonschema}/bin/check-jsonschema --schemafile "$SCHEMA_URL" "$SETTINGS_FILE" 2>&1; then
      echo "✅ OpenCode opencode.json validation passed"
    else
      echo "❌ OpenCode opencode.json validation failed" >&2
      exit 1
    fi
  '';
}
