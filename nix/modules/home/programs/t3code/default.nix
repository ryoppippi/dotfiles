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
          value = "medium";
        }
      ];
    };
    defaultRuntimeMode = "auto";

    # Worktrees always land in ~/.t3/worktrees/<repo>/<branch>; T3 Code has no
    # per-repository location setting.
    defaultThreadEnvMode = "worktree";

    # `storageCleanup` is the global policy the settings UI edits; a top-level
    # `worktreeCleanup` would override it wholesale, so it is cleared to keep a
    # single source of truth.
    storageCleanup = {
      worktreeKeepWhen = "uncommitted-changes";
      worktreeAfterDays = 14;
      worktreeOnMerge = true;
      worktreeOnDelete = true;
      worktreeUnchanged = true;
      browserArtifactsAfterDays = 30;
      logsAfterDays = 30;
    };
    worktreeCleanup = null;

    # Agent versions are pinned through llm-agents, so upstream update notices
    # are noise.
    enableProviderUpdateChecks = false;

    enableDeviceSupport = true;
    enableAgentDeviceAccess = true;
    cursorKeychainUsageEnabled = true;

    # Pinning store paths stops T3 Code from resolving agents through PATH, where
    # self-updating installs such as ~/.local/bin/cursor-agent would shadow the
    # Nix-managed binaries.
    #
    # T3 Code rejects the whole settings.json when an instance lacks `driver`,
    # so every entry names its driver explicitly. `displayName` is pinned too:
    # T3 Code can persist the resolved binary path as the label, which shows a
    # Nix store path in the UI and survives the merge below.
    providerInstances =
      lib.mapAttrs
        (
          driver: instance:
          {
            inherit driver;
            enabled = true;
          }
          // instance
        )
        {
          claudeAgent = {
            displayName = "Claude";
            config = {
              binaryPath = lib.getExe pkgs.claude-code;
              homePath = sessionVariables.CLAUDE_CONFIG_DIR;
            };
          };
          codex = {
            displayName = "Codex";
            config = {
              binaryPath = lib.getExe pkgs.llm-agents.codex;
              homePath = sessionVariables.CODEX_HOME;
            };
          };
          cursor = {
            displayName = "Cursor";
            config.binaryPath = lib.getExe pkgs.llm-agents.cursor-agent;
          };
          grok = {
            displayName = "Grok";
            config.binaryPath = lib.getExe pkgs.llm-agents.grok;
          };
          opencode = {
            displayName = "OpenCode";
            config.binaryPath = lib.getExe pkgs.llm-agents.opencode2;
          };
          pi = {
            displayName = "Pi";
            config.binaryPath = lib.getExe pkgs.llm-agents.pi;
          };
        };
  };

  # Desktop-only preferences live apart from the server settings.
  clientSettings = {
    confirmQuit = "direct";
    notificationMode = "notifications-and-sound";
    inAppNotificationsEnabled = true;
  };

  # Merged rather than linked: T3 Code rewrites both files atomically from its
  # settings UI, which would replace a store symlink with a plain file and break
  # the next switch. The keys declared here win; everything else is left alone.
  mergeSettings = name: value: ''
    SETTINGS_FILE="$SETTINGS_DIR/${name}"
    SOURCE_FILE="${pkgs.writeText "t3code-${name}" (builtins.toJSON value)}"
    if [ -f "$SETTINGS_FILE" ]; then
      TEMP_FILE="$(mktemp "$SETTINGS_DIR/.${name}.XXXXXX")"
      if ! ${jq} -s '.[0] * .[1]' "$SETTINGS_FILE" "$SOURCE_FILE" > "$TEMP_FILE"; then
        rm -f "$TEMP_FILE"
        exit 1
      fi
      chmod 644 "$TEMP_FILE"
      mv "$TEMP_FILE" "$SETTINGS_FILE"
    else
      ${jq} . "$SOURCE_FILE" > "$SETTINGS_FILE"
    fi
  '';
in
{
  home.packages = [ pkgs.llm-agents.t3code ];

  home.activation.configureT3codeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    SETTINGS_DIR="${t3codeStateDir}"
    mkdir -p "$SETTINGS_DIR"

    ${mergeSettings "settings.json" settings}
    ${mergeSettings "client-settings.json" clientSettings}
  '';
}
