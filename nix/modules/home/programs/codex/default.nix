{
  pkgs,
  lib,
  config,
  ...
}:
let
  codexHomeDir = "${config.home.homeDirectory}/.codex";
  codexXdgDir = "${config.xdg.configHome}/codex";

  tomlFormat = pkgs.formats.toml { };

  nu = lib.getExe pkgs.nushell;

  # Global instructions are assembled from the Codex-specific file plus the
  # shared fragments in agents/shared/, which are the single source of truth
  # also imported by claude/CLAUDE.md. Codex has no import mechanism, so the
  # final AGENTS.md is generated at switch time instead of symlinked.
  agentsMdText = lib.concatMapStringsSep "\n" builtins.readFile [
    ../../../../../codex/AGENTS.md
    ../../../../../agents/shared/code-comments.md
    ../../../../../agents/shared/command-privacy.md
    ../../../../../agents/shared/git-staging.md
    ../../../../../agents/shared/git-worktrees.md
    ../../../../../agents/shared/delegate-work.md
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

    agents = {
      max_concurrent_threads_per_session = 100;
      default_subagent_model = "gpt-5.6-luna";
      default_subagent_reasoning_effort = "max";
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
    packages = [ pkgs.llm-agents.codex ];

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

    # merge-config.nu explains why this is a merge rather than a copy: the
    # ChatGPT desktop app stores its plugin and MCP wiring in the same file.
    activation.writeCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      ${nu} ${./merge-config.nu} ${tomlFormat.generate "codex-config" settings} "${codexHomeDir}/config.toml"
      chmod 644 "${codexHomeDir}/config.toml"
    '';

    file."${codexHomeDir}/AGENTS.md".text = agentsMdText;
  };
}
