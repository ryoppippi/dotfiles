{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
let
  claudeConfigDir = "${config.xdg.configHome}/claude";
  claudeDotfilesDir = "${dotfilesDir}/claude";

  # Binary paths from Nix store
  bun = lib.getExe pkgs.bun;
  jq = lib.getExe pkgs.jq;
  terminal-notifier =
    if pkgs.stdenv.isDarwin then lib.getExe' pkgs.terminal-notifier "terminal-notifier" else "";

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
  # Claude Code package from overlay
  home.packages = [ pkgs.claude-code ];

  # Set CLAUDE_CONFIG_DIR environment variable (sourced via hm-session-vars.sh in fish)
  home.sessionVariables = {
    CLAUDE_CONFIG_DIR = claudeConfigDir;
  };

  # Generate settings.json from JSON file with path replacements
  xdg.configFile."claude/settings.json" = {
    text = settingsJsonText;
  };

  # Symlink directories and files to ~/.config/claude/
  # Note: All skills (external and local) are managed by agent-skills module
  xdg.configFile = {
    "claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/CLAUDE.md";
    "claude/commands".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/commands";
    "claude/agents".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/agents";
    "claude/output-styles".source =
      config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/output-styles";
    "claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/rules";
  };

  # Validate Claude Code settings.json after generation
  home.activation.validateClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    SETTINGS_FILE="${claudeConfigDir}/settings.json"
    SCHEMA_URL=$(${jq} -r '.["$schema"]' "$SETTINGS_FILE")

    echo "🔍 Validating Claude Code settings.json..."
    if ${pkgs.check-jsonschema}/bin/check-jsonschema --schemafile "$SCHEMA_URL" "$SETTINGS_FILE" 2>&1; then
      echo "✅ Claude Code settings.json validation passed"
    else
      echo "❌ Claude Code settings.json validation failed" >&2
      exit 1
    fi
  '';
}
