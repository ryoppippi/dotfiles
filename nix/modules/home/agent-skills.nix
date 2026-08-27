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

  localSkillNames =
    if local-skills == null then
      [ ]
    else
      lib.filter (name: name != "web-fetch") (
        builtins.attrNames (builtins.readDir "${local-skills}/agents/skills")
      );
in
{
  programs.agent-skills = {
    enable = true;

    # External sources come from the pin registry; only this repo's own skills
    # stay a direct path. `local` keeps bare IDs because skills.enable selects
    # it by plain name.
    sources = externalSources // {
      local = {
        path = local-skills;
        subdir = "agents/skills";
        filter.maxDepth = 1;
      };
    };

    skills.enable = localSkillNames;

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
      from = "local";
      path = "web-fetch";
      packages = [
        pkgs.llm-agents.ax
        pkgs.llm-agents.tgrab
      ];
      rewriteCommands = false;
    };

    skills.explicit.cmux = {
      from = "cmux";
      path = "cmux";
    };

    skills.explicit.cmux-workspace = {
      from = "cmux";
      path = "cmux-workspace";
    };

    skills.explicit.cmux-settings = {
      from = "cmux";
      path = "cmux-settings";
    };

    skills.explicit.cmux-customization = {
      from = "cmux";
      path = "cmux-customization";
    };

    skills.explicit.cmux-diagnostics = {
      from = "cmux";
      path = "cmux-diagnostics";
    };

    skills.explicit.cmux-browser = {
      from = "cmux";
      path = "cmux-browser";
    };

    skills.explicit.cmux-markdown = {
      from = "cmux";
      path = "cmux-markdown";
    };

    skills.explicit.gh-stack = {
      from = "gh-stack";
      path = "gh-stack";
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
    };
  };
}
