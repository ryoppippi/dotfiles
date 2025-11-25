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
  terminal-notifier = lib.getExe pkgs.terminal-notifier;

  # JSON format for prettified output
  jsonFormat = pkgs.formats.json { };

  # Claude Code settings configuration
  settings = {
    "$schema" = "https://json.schemastore.org/claude-code-settings.json";
    cleanupPeriodDays = 876000;
    env = {
      ENABLE_BACKGROUND_TASKS = "1";
      FORCE_AUTO_BACKGROUND_TASKS = "1";
      DISABLE_MICROCOMPACT = "1";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = "1";
      DISABLE_INTERLEAVED_THINKING = "1";
      DISABLE_ERROR_REPORTING = "1";
    };
    includeCoAuthoredBy = false;
    permissions = {
      allow = [
        "Bash(${terminal-notifier}:*)"
      ];
      defaultMode = "acceptEdits";
    };
    hooks = {
      Notification = [
        {
          matcher = "";
          hooks = [
            {
              type = "command";
              command = "${jq} -r '.message' | xargs -I {} ${terminal-notifier} -message \"{}\" -title \"Claude Hook\" -group \"$(pwd):hook\" -execute \"$(which wezterm) cli activate-pane --pane-id $WEZTERM_PANE\" -activate com.github.wez.wezterm";
            }
          ];
        }
      ];
    };
    statusLine = {
      type = "command";
      command = "${bun} $( ghq root )/github.com/ryoppippi/ccusage/apps/ccusage/src/index.ts statusline --cost-source both";
    };
    alwaysThinkingEnabled = false;
  };
in
{
  # Claude Code package with CLAUDE_CONFIG_DIR wrapper
  home.packages = lib.mkAfter [ claude-code-wrapped ];

  # Generate settings.json via Home Manager (prettified)
  xdg.configFile."claude/settings.json".source = jsonFormat.generate "settings.json" settings;

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
}
