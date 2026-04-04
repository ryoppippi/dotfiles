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
  jsonFormat = pkgs.formats.json { };

  baseSettings = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    cleanupPeriodDays = 876000;
    env = {
      ENABLE_BACKGROUND_TASKS = "1";
      FORCE_AUTO_BACKGROUND_TASKS = "1";
      DISABLE_MICROCOMPACT = "1";

      DISABLE_INTERLEAVED_THINKING = "1";
      DISABLE_ERROR_REPORTING = "1";

      CLAUDE_CODE_NO_FLICKER = "1";
    };
    includeCoAuthoredBy = false;
    statusLine = {
      type = "command";
      command = "${bun} $( ghq root )/github.com/ryoppippi/ccusage/apps/ccusage/src/index.ts statusline --cost-source both";
    };
    alwaysThinkingEnabled = true;
    autoMemoryEnabled = false;
    skipAutoPermissionPrompt = true;
    skipDangerousModePermissionPrompt = true;
    hooks = {
      PreToolUse = [
        {
          matcher = "Bash";
          hooks = [
            {
              type = "command";
              command = builtins.concatStringsSep " " [
                "input=$(cat);"
                "cmd=$(echo \"$input\" | ${jq} -r '.tool_input.command // \"\"');"
                "if echo \"$cmd\" | grep -q 'gh pr create'; then"
                "if [ -f /tmp/.claude-codex-review-done ]; then"
                "rm -f /tmp/.claude-codex-review-done; exit 0;"
                "else"
                "echo 'BLOCKED: You must run the codex-review skill first before creating a PR. Use Skill(codex-review) to review changes against the base branch.' >&2;"
                "exit 2;"
                "fi; fi; exit 0"
              ];
            }
          ];
        }
      ];
      PostToolUse = [
        {
          matcher = "Skill";
          hooks = [
            {
              type = "command";
              command = builtins.concatStringsSep " " [
                "input=$(cat);"
                "skill=$(echo \"$input\" | ${jq} -r '.tool_input.skillName // \"\"');"
                "if [ \"$skill\" = \"codex-review\" ]; then"
                "touch /tmp/.claude-codex-review-done;"
                "fi; exit 0"
              ];
            }
          ];
        }
      ];
    };
  };

  darwinSettings = lib.optionalAttrs pkgs.stdenv.isDarwin {
    permissions = {
      defaultMode = "auto";
    };
  };

  # Deep merge with hook array concatenation
  mergeSettings =
    base: override:
    let
      baseHooks = base.hooks or { };
      overrideHooks = override.hooks or { };
      allHookKeys = lib.unique (lib.attrNames baseHooks ++ lib.attrNames overrideHooks);
      mergedHooks = lib.genAttrs allHookKeys (
        key: (baseHooks.${key} or [ ]) ++ (overrideHooks.${key} or [ ])
      );
    in
    base // override // { hooks = mergedHooks; };

  settings = mergeSettings baseSettings darwinSettings;
in
{
  home = {
    # Claude Code package from overlay
    packages = [ pkgs.claude-code ];

    # Set CLAUDE_CONFIG_DIR environment variable (sourced via hm-session-vars.sh in fish)
    sessionVariables = {
      CLAUDE_CONFIG_DIR = claudeConfigDir;
    };

    # Validate Claude Code settings.json after generation
    activation.validateClaudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      SETTINGS_FILE="${claudeConfigDir}/settings.json"
      SCHEMA_URL=$(${jq} -r '.["$schema"]' "$SETTINGS_FILE")

      echo "🔍 Validating Claude Code settings.json..."
      if ${pkgs.check-jsonschema}/bin/check-jsonschema --schemafile "$SCHEMA_URL" "$SETTINGS_FILE" 2>&1; then
        echo "✅ Claude Code settings.json validation passed"
      else
        echo "⚠️  Claude Code settings.json validation failed (non-blocking, schema may be outdated)" >&2
      fi
    '';
  };

  # Symlink directories and files to ~/.config/claude/
  # Note: All skills (external and local) are managed by agent-skills module
  xdg.configFile = {
    "claude/settings.json".source = jsonFormat.generate "claude-settings.json" settings;
    "claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/CLAUDE.md";
    "claude/commands".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/commands";
    "claude/agents".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/agents";
    "claude/output-styles".source =
      config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/output-styles";
    "claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${claudeDotfilesDir}/rules";
  };
}
