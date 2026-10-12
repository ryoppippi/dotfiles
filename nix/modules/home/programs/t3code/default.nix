{
  pkgs,
  lib,
  config,
  ...
}:
let
  t3codeStateDir = "$HOME/.t3/userdata";
  jq = lib.getExe pkgs.jq;
  inherit (config.home) sessionVariables;

  settings = {
    defaultModelSelection = {
      instanceId = "claudeAgent";
      model = "claude-opus-5-5";
      options = [
        {
          id = "effort";
          value = "high";
        }
      ];
    };
    defaultRuntimeMode = "auto";

    # Worktrees always land in ~/.t3/worktrees/<repo>/<branch>; T3 Code has no
    # per-repository location setting.
    defaultThreadEnvMode = "worktree";
    worktreeCleanup = {
      mode = "custom";
      rules = {
        worktreeAfterDays = 14;
        worktreeOnMerge = true;
        worktreeOnDelete = true;
        worktreeUnchanged = true;
      };
    };

    # Agent versions are pinned through llm-agents, so upstream update notices
    # are noise.
    enableProviderUpdateChecks = false;

    # Pinning store paths stops T3 Code from resolving agents through PATH, where
    # self-updating installs such as ~/.local/bin/cursor-agent would shadow the
    # Nix-managed binaries.
    # T3 Code rejects the whole settings.json when an instance lacks `driver`,
    # so every entry names its driver explicitly.
    providerInstances = lib.mapAttrs (driver: instance: { inherit driver; } // instance) {
      claudeAgent.config = {
        binaryPath = lib.getExe pkgs.claude-code;
        homePath = sessionVariables.CLAUDE_CONFIG_DIR;
      };
      codex.config = {
        binaryPath = lib.getExe pkgs.llm-agents.codex;
        homePath = sessionVariables.CODEX_HOME;
      };
      cursor.config.binaryPath = lib.getExe pkgs.llm-agents.cursor-agent;
      grok.config.binaryPath = lib.getExe pkgs.llm-agents.grok;
      opencode.config.binaryPath = lib.getExe pkgs.llm-agents.opencode;
    };
  };
  settingsFile = pkgs.writeText "t3code-settings.json" (builtins.toJSON settings);
in
{
  home.packages = [ pkgs.llm-agents.t3code ];

  # Merged rather than linked: T3 Code rewrites settings.json atomically from
  # its settings UI, which would replace a store symlink with a plain file and
  # break the next switch. The keys above win; everything else is left alone.
  home.activation.configureT3codeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    SETTINGS_DIR="${t3codeStateDir}"
    SETTINGS_FILE="$SETTINGS_DIR/settings.json"
    mkdir -p "$SETTINGS_DIR"

    if [ -f "$SETTINGS_FILE" ]; then
      TEMP_FILE="$(mktemp "$SETTINGS_DIR/.settings.json.XXXXXX")"
      if ! ${jq} -s '.[0] * .[1]' "$SETTINGS_FILE" "${settingsFile}" > "$TEMP_FILE"; then
        rm -f "$TEMP_FILE"
        exit 1
      fi
      chmod 644 "$TEMP_FILE"
      mv "$TEMP_FILE" "$SETTINGS_FILE"
    else
      ${jq} . "${settingsFile}" > "$SETTINGS_FILE"
    fi
  '';
}
