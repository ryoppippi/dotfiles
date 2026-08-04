{
  pkgs,
  lib,
  config,
  tgrab,
  ...
}:
let
  codexHomeDir = "${config.home.homeDirectory}/.codex";
  codexXdgDir = "${config.xdg.configHome}/codex";

  tomlFormat = pkgs.formats.toml { };

  # Reachable by a delegated subagent through shell_environment_policy below,
  # which passes this PATH into the sandboxed shell. ax and tgrab live only in
  # the web-fetch skill directory otherwise, out of reach of a codex process
  # started from an arbitrary cwd; rg and fd are how it investigates a codebase.
  subagentTools = [
    pkgs.llm-agents.ax
    tgrab.packages.${pkgs.stdenv.hostPlatform.system}.default
    pkgs.llm-agents.grok
    pkgs.bun
    pkgs.ripgrep
    pkgs.fd
  ];

  # Grunt work — searching, page reading, codebase investigation, summarising —
  # delegated off the calling agent's context and onto the Codex subscription.
  # The flags keep it throwaway: nothing persisted, no goals or memories, and a
  # reasoning effort well below the interactive config's. Effort stays at medium
  # because low answered a "latest release version" search from stale knowledge.
  # multi_agent must stay enabled: native web search runs through it, and
  # disabling it makes any search task hang indefinitely.
  codex-sub = pkgs.writeShellApplication {
    name = "codex-sub";
    runtimeInputs = subagentTools;
    text = ''
      transcript=$(mktemp)
      digest=$(mktemp)
      trap 'rm -f "$transcript" "$digest"' EXIT

      # Only the final message reaches the caller: the transcript echoes every
      # command and page the subagent touched, which is the bulk this wrapper
      # exists to keep out. It is also the only clue when codex itself fails,
      # so a failure prints it on stderr rather than swallowing it.
      if ${lib.getExe pkgs.llm-agents.codex} exec \
        --skip-git-repo-check \
        --ephemeral \
        --sandbox "''${CODEX_SUB_SANDBOX:-workspace-write}" \
        --disable goals \
        --disable memories \
        -m "''${CODEX_SUB_MODEL:-gpt-5.6-luna}" \
        -c approval_policy=never \
        -c model_reasoning_effort="''${CODEX_SUB_EFFORT:-medium}" \
        -c sandbox_workspace_write.network_access=true \
        -c web_search_request=true \
        -o "$digest" \
        "$@" >"$transcript" 2>&1; then
        # codex writes the last message without a trailing newline.
        printf '%s\n' "$(cat "$digest")"
      else
        cat "$transcript" >&2
        exit 1
      fi
    '';
  };

  # Global instructions are assembled from the Codex-specific file plus the
  # shared fragments in agents/shared/, which are the single source of truth
  # also imported by claude/CLAUDE.md. Codex has no import mechanism, so the
  # final AGENTS.md is generated at switch time instead of symlinked.
  agentsMdText = lib.concatMapStringsSep "\n" builtins.readFile [
    ../../../../codex/AGENTS.md
    ../../../../agents/shared/code-comments.md
    ../../../../agents/shared/command-privacy.md
    ../../../../agents/shared/git-worktrees.md
    ../../../../agents/shared/delegate-work.md
  ];

  settings = {
    model = "gpt-5.6-luna";
    approval_policy = "on-request";
    approvals_reviewer = "auto_review";
    allow_login_shell = true;
    model_reasoning_effort = "max";
    web_search_request = true;
    personality = "pragmatic";
    service_tier = "fast"; # "standard" or "fast"
    project_doc_fallback_filenames = [ "CLAUDE.md" ];

    shell_environment_policy = {
      "inherit" = "all";
      experimental_use_profile = true;
    };

    features = {
      goals = true;
      memories = true;
      multi_agent = true;
    };

    notice.fast_default_opt_out = false;

    desktop = {
      preventSleepWhileRunning = true;
      "show-context-window-usage" = true;
      "hotkey-window-projectless-default-enabled" = false;
      "enabled-reasoning-efforts" = [
        "low"
        "medium"
        "high"
        "xhigh"
        "ultra"
        "max"
      ];
    };

    plugins."github@openai-curated" = {
      enabled = true;
    };
  };
in
{
  launchd.agents.codex-home = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/launchctl"
        "setenv"
        "CODEX_HOME"
        codexHomeDir
      ];
      RunAtLoad = true;
    };
  };

  home = {
    packages = [
      pkgs.llm-agents.codex
      codex-sub
    ];

    sessionVariables = {
      CODEX_HOME = codexHomeDir;
    };

    activation.linkCodexXdgDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -e "${codexXdgDir}" ] && [ ! -L "${codexXdgDir}" ]; then
        echo "Refusing to replace non-symlink ${codexXdgDir}" >&2
        exit 1
      fi

      mkdir -p "${codexHomeDir}" "$(dirname "${codexXdgDir}")"
      ln -sfn "${codexHomeDir}" "${codexXdgDir}"
    '';

    activation.writeCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${codexHomeDir}"
      cp --no-preserve=mode,ownership ${tomlFormat.generate "codex-config" settings} "${codexHomeDir}/config.toml"
      chmod 644 "${codexHomeDir}/config.toml"
    '';

    file."${codexHomeDir}/AGENTS.md".text = agentsMdText;
  };
}
