{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  claude-code-overlay,
  system,
  helpers,
  ...
}:
let
  claudeConfigDir = "${config.xdg.configHome}/claude";
  claudeDotfilesDir = "${dotfilesDir}/claude";

  # Get claude-code directly from overlay
  base-claude-code = (claude-code-overlay.overlays.default pkgs pkgs).claude-code;

  # Wrap Claude Code with CLAUDE_CONFIG_DIR environment variable
  claude-code-wrapped = pkgs.symlinkJoin {
    name = "claude-code-wrapped";
    paths = [ base-claude-code ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude \
        --set CLAUDE_CONFIG_DIR ${claudeConfigDir}
    '';
  };

  # Binary paths from Nix store
  bun = lib.getExe pkgs.bun;
  jq = lib.getExe pkgs.jq;
  terminal-notifier = if pkgs.stdenv.isDarwin then lib.getExe pkgs.terminal-notifier else "";

  # Generate settings JSON using Bun merge script
  settingsJsonText = builtins.readFile (
    pkgs.runCommand "claude-settings.json"
      {
        buildInputs = [ pkgs.bun ];
        BASE_SETTINGS = ./settings.json;
        DARWIN_SETTINGS = if pkgs.stdenv.isDarwin then ./settings-darwin.json else "";
        BUN_PATH = bun;
        TERMINAL_NOTIFIER_PATH = terminal-notifier;
        JQ_PATH = jq;
        IS_DARWIN = if pkgs.stdenv.isDarwin then "1" else "0";
      }
      ''
        ${pkgs.bun}/bin/bun run ${./merge-settings.ts} > $out
      ''
  );

in
{
  # Claude Code package with CLAUDE_CONFIG_DIR wrapper
  home.packages = lib.mkAfter [ claude-code-wrapped ];

  # Generate settings.json from JSON file with path replacements
  xdg.configFile."claude/settings.json" = {
    text = settingsJsonText;
  };

  # Create direct symlinks to Claude Code configuration files (bypassing Nix store)
  home.activation.linkClaudeCodeConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${helpers.activation.mkLinkForce}
    $DRY_RUN_CMD mkdir -p "${claudeConfigDir}"
    link_force "${claudeDotfilesDir}/CLAUDE.md" "${claudeConfigDir}/CLAUDE.md"
    link_force "${claudeDotfilesDir}/commands" "${claudeConfigDir}/commands"
    link_force "${claudeDotfilesDir}/agents" "${claudeConfigDir}/agents"
    link_force "${claudeDotfilesDir}/output-styles" "${claudeConfigDir}/output-styles"
    link_force "${claudeDotfilesDir}/skills" "${claudeConfigDir}/skills"
  '';

  # Validate Claude Code settings.json after generation
  home.activation.validateClaudeSettings = lib.hm.dag.entryAfter [ "linkClaudeCodeConfig" ] ''
    SETTINGS_FILE="${claudeConfigDir}/settings.json"
    SCHEMA_URL="https://json.schemastore.org/claude-code-settings.json"

    if [ -f "$SETTINGS_FILE" ]; then
      echo "🔍 Validating Claude Code settings.json..."
      if ${pkgs.check-jsonschema}/bin/check-jsonschema --schemafile "$SCHEMA_URL" "$SETTINGS_FILE" 2>&1; then
        echo "✅ Claude Code settings.json validation passed"
      else
        echo "❌ Claude Code settings.json validation failed" >&2
        exit 1
      fi
    fi
  '';
}
