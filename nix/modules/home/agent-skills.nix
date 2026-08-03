# Agent skills configuration for Claude Code
# https://github.com/Kyure-A/agent-skills-nix
#
# All skills (external and local) are managed here via agent-skills-nix.
# Skills are deployed to ~/.agents (standard location) and ~/.config/claude/skills
{
  pkgs,
  config,
  lib,
  ast-grep-skill,
  agent-browser-skill,
  tgrab,
  cmux-skill,
  gh-stack-skill,
  local-skills,
  ...
}:
let
  # Skills selected via skills.explicit keep the attr name as their ID, so
  # prefixing only namespaces *discovered* IDs. Without it, discoverCatalog
  # throws on any duplicate ID, meaning an unrelated upstream bump that adds a
  # skill named like a local one would break every switch. Only `local` stays
  # bare, because skills.enable selects it by plain name.
  externalSource = idPrefix: path: {
    inherit idPrefix path;
    subdir = "skills";
    # Every skill here sits directly under subdir; the upstream default of
    # unlimited recursion would also surface nested SKILL.md files.
    filter.maxDepth = 1;
  };

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

    # Skill sources (from flake inputs)
    sources = {
      # External: ast-grep official skill
      ast-grep = (externalSource "ast-grep" ast-grep-skill) // {
        subdir = "ast-grep/skills";
      };
      # External: agent-browser skill
      agent-browser = externalSource "agent-browser" agent-browser-skill;
      cmux = externalSource "cmux" cmux-skill;
      gh-stack = externalSource "gh-stack" gh-stack-skill;
      # Local: skills from this dotfiles repo
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
        tgrab.packages.${pkgs.stdenv.hostPlatform.system}.default
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
