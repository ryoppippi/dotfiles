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

    # Kept only on this machine; T3 Code does not sync them. The merge replaces
    # the whole list, so favourites added from the UI need recording here.
    favorites = [
      {
        provider = "claudeAgent";
        model = "claude-opus-5-5";
      }
      {
        provider = "claudeAgent";
        model = "claude-sonnet-5-5";
      }
      {
        provider = "codex";
        model = "gpt-6-astra";
      }
      {
        provider = "codex";
        model = "gpt-6.1-sol";
      }
      {
        provider = "codex";
        model = "gpt-6-luna";
      }
    ];

    autoResumeLimitedThreads = true;
    snoozeLimitedThreads = true;

    # Worktrees always land in ~/.t3/worktrees/<repo>/<branch>; T3 Code has no
    # per-repository location setting.
    defaultThreadEnvMode = "worktree";
    branchNamingMode = "semantic";
    branchNamePrefix = "ryoppippi";
    removeAgentCreditsOnMerge = true;

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

  # Only the bindings that differ from T3 Code's defaults. A user rule for a
  # command replaces every default for that command, and T3 Code backfills the
  # defaults of all other commands on startup.
  #
  # T3 Code has no unbind syntax, so `when = "false"` disables a command. These
  # leave mod+enter in the composer to send, or to steer while a turn runs.
  keybindings =
    map
      (command: {
        key = "mod+alt+enter";
        inherit command;
        when = "false";
      })
      [
        "composer.sendBackground"
        "composer.sendAndNewThread"
      ];

  # Merged rather than linked: T3 Code rewrites these files atomically from its
  # settings UI, which would replace a store symlink with a plain file and break
  # the next switch. What is declared here wins; everything else is left alone.
  mergeJson = filter: name: value: ''
    SETTINGS_FILE="$SETTINGS_DIR/${name}"
    SOURCE_FILE="${pkgs.writeText "t3code-${name}" (builtins.toJSON value)}"
    if [ -f "$SETTINGS_FILE" ]; then
      TEMP_FILE="$(mktemp "$SETTINGS_DIR/.${name}.XXXXXX")"
      if ! ${jq} -s '${filter}' "$SETTINGS_FILE" "$SOURCE_FILE" > "$TEMP_FILE"; then
        rm -f "$TEMP_FILE"
        exit 1
      fi
      chmod 644 "$TEMP_FILE"
      mv "$TEMP_FILE" "$SETTINGS_FILE"
    else
      ${jq} . "$SOURCE_FILE" > "$SETTINGS_FILE"
    fi
  '';
  mergeSettings = mergeJson ".[0] * .[1]";
  # Drops the existing rules for each declared command, mirroring how T3 Code
  # lets a user rule shadow that command's defaults.
  mergeKeybindings = mergeJson "(.[1] | map(.command)) as $declared | [.[0][] | select(.command as $c | $declared | index($c) | not)] + .[1]";
in
{
  home.sessionPath = [ "$HOME/.t3/bin" ];

  home.activation.configureT3codeSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    SETTINGS_DIR="${t3codeStateDir}"
    mkdir -p "$SETTINGS_DIR"

    ${mergeSettings "settings.json" settings}
    ${mergeSettings "client-settings.json" clientSettings}
    ${mergeKeybindings "keybindings.json" keybindings}
  '';
}
