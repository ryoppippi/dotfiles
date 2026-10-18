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

  settingsFile = builtins.toFile "opencode-settings.json" (builtins.readFile ./settings.json);
  cliSettingsFile = builtins.toFile "opencode-cli.json" (builtins.readFile ./cli.json);

  # llm-agents installs v2 as `opencode2` so it can coexist with v1; we only
  # install v2, so expose it under its upstream name as well.
  opencode = pkgs.symlinkJoin {
    name = "opencode-${pkgs.llm-agents.opencode2.version}";
    paths = [ pkgs.llm-agents.opencode2 ];
    postBuild = ''
      ln -s opencode2 $out/bin/opencode
    '';
    meta.mainProgram = "opencode";
  };

  # OpenCode writes back to its own config (cli.json holds TUI state), so merge
  # the managed keys into a mutable file instead of symlinking a store path.
  mergeJson = name: source: ''
    TARGET="${opencodeConfigDir}/${name}"
    if [ -f "$TARGET" ] && [ ! -L "$TARGET" ]; then
      TEMP_FILE="$(mktemp "${opencodeConfigDir}/.${name}.XXXXXX")"
      if ! ${jq} -s '.[0] * .[1]' "$TARGET" "${source}" > "$TEMP_FILE"; then
        rm -f "$TEMP_FILE"
        exit 1
      fi
      mv "$TEMP_FILE" "$TARGET"
    else
      rm -f "$TARGET"
      cp "${source}" "$TARGET"
      chmod 600 "$TARGET"
    fi
  '';

  validateJson = name: ''
    TARGET="${opencodeConfigDir}/${name}"
    SCHEMA_URL=$(${jq} -r '.["$schema"]' "$TARGET")

    echo "🔍 Validating OpenCode ${name}..."
    if ${checkJsonschema} --schemafile "$SCHEMA_URL" "$TARGET" 2>&1; then
      echo "✅ OpenCode ${name} validation passed"
    else
      echo "❌ OpenCode ${name} validation failed" >&2
      exit 1
    fi
  '';
in
{
  home.packages = lib.mkAfter [ opencode ];

  home.activation.configureOpenCodeSettings =
    lib.hm.dag.entryAfter
      ([ "linkGeneration" ] ++ lib.optional pkgs.stdenv.hostPlatform.isDarwin "installCmuxHooks")
      ''
        mkdir -p "${opencodeConfigDir}"
        ${mergeJson "opencode.json" settingsFile}
        ${mergeJson "cli.json" cliSettingsFile}
      '';

  home.activation.validateOpenCodeSettings = lib.hm.dag.entryAfter [ "configureOpenCodeSettings" ] ''
    ${validateJson "opencode.json"}
    ${validateJson "cli.json"}
  '';
}
