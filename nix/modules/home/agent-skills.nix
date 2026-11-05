# Agent skills configuration for Claude Code
# https://github.com/Kyure-A/agent-skills-nix
#
# All skills (external and local) are managed here via agent-skills-nix.
# Skills are deployed to ~/.agents (standard location) and ~/.config/claude/skills
{
  pkgs,
  config,
  lib,
  agentSkillsLib,
  skillRegistry,
  local-skills,
  ...
}:
let
  # External skill repositories are pinned in registry/sources/*.nix rather than
  # as flake inputs, so `nix run .#skills-sources-lock` updates them all without
  # touching flake.lock. Each manifest also carries its own subdir, idPrefix,
  # and depth filter.
  externalSources = agentSkillsLib.sourcesFromLock skillRegistry;

  localSkillsDir = "${local-skills}/agents/skills";

  localSkillNames =
    if local-skills == null then [ ] else builtins.attrNames (builtins.readDir localSkillsDir);

  # `metadata.agents` in a local SKILL.md lists the targets that receive it.
  # Nix cannot parse YAML, so only the one-line flow form
  # `  agents: [claude, agents]` is read; any other spelling fails evaluation
  # rather than silently installing the skill everywhere.
  skillAgents =
    name:
    let
      lines = lib.splitString "\n" (builtins.readFile "${localSkillsDir}/${name}/SKILL.md");
      body = lib.drop 1 lines;
      frontmatterEnd = lib.lists.findFirstIndex (line: line == "---") null body;
      frontmatter =
        if lib.head lines == "---" && frontmatterEnd != null then lib.take frontmatterEnd body else [ ];
      metadataStart = lib.lists.findFirstIndex (line: line == "metadata:") null frontmatter;
      afterMetadata = if metadataStart == null then [ ] else lib.drop (metadataStart + 1) frontmatter;
      metadataEnd = lib.lists.findFirstIndex (
        line: builtins.match "[[:space:]].*" line == null
      ) (builtins.length afterMetadata) afterMetadata;
      agentsLines = lib.filter (line: builtins.match "[[:space:]]+agents:.*" line != null) (
        lib.take metadataEnd afterMetadata
      );
      parsed = builtins.match "[[:space:]]+agents:[[:space:]]*\\[([^]]*)]" (lib.head agentsLines);
      names = lib.filter (agent: agent != "") (map lib.trim (lib.splitString "," (lib.head parsed)));
      fail = reason: throw "agent-skills: ${name}/SKILL.md metadata.agents ${reason}";
    in
    if agentsLines == [ ] then
      null
    else if builtins.length agentsLines > 1 then
      fail "is declared more than once"
    else if parsed == null then
      fail "must be a one-line list such as [claude, agents]"
    else if !lib.all (agent: builtins.match "[A-Za-z0-9_-]+" agent != null) names then
      fail "entries must be bare target names"
    else
      names;
in
{
  # Explicit rather than skills.enable: only explicit skills can carry the
  # per-target `agents` allowlist.
  imports = [
    {
      programs.agent-skills.skills.explicit = lib.genAttrs localSkillNames (name: {
        from = "local";
        path = name;
        agents = skillAgents name;
      });
    }
    {
      # tstack's file-pr and sol-loop are not installed: create-pr and
      # review-loop do their jobs here, so references to them are renamed.
      programs.agent-skills.skills.explicit =
        lib.genAttrs [ "babysit-pr" "full-send" "full-stop" "leaving-pr-comments" "modernize" "takeover" ]
          (name: {
            from = "tstack";
            path = name;
            transform =
              { original, ... }:
              builtins.replaceStrings [ "`file-pr`" "`sol-loop`" ] [ "`create-pr`" "`review-loop`" ] original;
          });
    }
  ];

  programs.agent-skills = {
    enable = true;

    # External sources come from the pin registry; only this repo's own skills
    # stay a direct path. `local` keeps bare IDs because skills.explicit names
    # its skills by plain name.
    sources = externalSources // {
      local = {
        path = local-skills;
        subdir = "agents/skills";
        filter.maxDepth = 1;
      };
    };

    skills.explicit.ast-grep =
      let
        astGrepBin = lib.getExe pkgs.ast-grep;
      in
      {
        from = "ast-grep";
        path = "ast-grep";
        packages = [ pkgs.ast-grep ];
        # Opt out of auto command rewriting: this skill rewrites bare names to
        # absolute Nix store paths via transform below, not to ./name. Leaving
        # rewriteCommands on would mangle the frontmatter name and prose, and
        # double-prefix command paths (.//nix/store/...).
        rewriteCommands = false;
        transform =
          { original, dependencies }:
          let
            patched =
              builtins.replaceStrings
                [ "| ast-grep " "ast-grep scan " "ast-grep run " ]
                [ "| ${astGrepBin} " "${astGrepBin} scan " "${astGrepBin} run " ]
                original;
          in
          ''
            ${patched}

            ${dependencies}
          '';
      };

    skills.explicit.web-fetch = {
      packages = [
        pkgs.llm-agents.ax
        pkgs.llm-agents.tgrab
      ];
      rewriteCommands = false;
    };

    skills.explicit.gh-stack = {
      from = "gh-stack";
      path = "gh-stack";
    };

    # The binary comes from ai-tools.nix via the t3-limits flake input, so the
    # skill's plain `t3-limits` commands resolve on PATH.
    skills.explicit.t3-limits = {
      from = "t3-limits";
      path = "t3-limits";
    };

    skills.explicit.agent-browser =
      let
        agentBrowserBin = "${config.home.homeDirectory}/.agents/skills/agent-browser/agent-browser";
      in
      {
        from = "agent-browser";
        path = "agent-browser";
        packages = [ pkgs.llm-agents.agent-browser ];
        # Opt out of auto command rewriting: this skill rewrites bare names to
        # an absolute path under ~/.agents via transform below, not to ./name.
        rewriteCommands = false;
        transform =
          { original, ... }:
          builtins.replaceStrings
            [
              "Bash(agent-browser:*), Bash(npx agent-browser:*)"
              "Install: `npm i -g agent-browser && agent-browser install`\n\n"
              "agent-browser skills "
              "`agent-browser`"
            ]
            [
              "Bash(${agentBrowserBin}:*)"
              ""
              "${agentBrowserBin} skills "
              "`${agentBrowserBin}`"
            ]
            original;
      };

    # Deploy to standard skills directories
    targets = {
      # Standard ~/.agents/skills directory
      agents = {
        enable = true;
        # Absolute: a global target's dest must not depend on the activation cwd.
        dest = "$HOME/.agents/skills";
        structure = "copy-tree";
      };
      # Claude Code user config. Deliberately not the upstream default of
      # ${CLAUDE_CONFIG_DIR:-$HOME/.claude}/skills: CLAUDE_CONFIG_DIR comes from
      # home.sessionVariables, which is not exported during activation, so that
      # default would silently expand to the wrong directory.
      claude = {
        enable = true;
        dest = ".config/claude/skills";
        structure = "link";
      };
      claude-personal-0 = {
        enable = true;
        dest = ".config/claude-personal-0/skills";
        structure = "link";
      };
    };
  };
}
