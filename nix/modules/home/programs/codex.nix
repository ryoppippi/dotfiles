{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
let
  codexHomeDir = "${config.home.homeDirectory}/.codex";
  codexXdgDir = "${config.xdg.configHome}/codex";
  codexDotfilesDir = "${dotfilesDir}/codex";

  tomlFormat = pkgs.formats.toml { };

  settings = {
    model = "gpt-5.5";
    approval_policy = "on-request";
    approvals_reviewer = "auto_review";
    allow_login_shell = true;
    model_reasoning_effort = "high";
    web_search_request = true;
    personality = "pragmatic";
    service_tier = "standard"; # "standard" or "fast"
    project_doc_fallback_filenames = [ "CLAUDE.md" ];

    shell_environment_policy = {
      "inherit" = "all";
      experimental_use_profile = false;
    };

    features = {
      goals = true;
      js_repl = true;
      multi_agent = true;
      terminal_resize_reflow = true;
    };

    notice.fast_default_opt_out = false;

    plugins."github@openai-curated" = {
      enabled = true;
    };
  };
in
{
  home = {
    packages = [ pkgs.llm-agents.codex ];

    sessionVariables = {
      CODEX_HOME = codexHomeDir;
    };

    activation.linkCodexHome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ -e "${codexHomeDir}" ] && [ ! -L "${codexHomeDir}" ]; then
        echo "Refusing to replace non-symlink ${codexHomeDir}" >&2
        exit 1
      fi

      mkdir -p "$(dirname "${codexHomeDir}")" "${codexXdgDir}"
      ln -sfn "${codexXdgDir}" "${codexHomeDir}"
    '';

    activation.writeCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${codexXdgDir}"
      cp --no-preserve=mode,ownership ${tomlFormat.generate "codex-config" settings} "${codexXdgDir}/config.toml"
      chmod 644 "${codexXdgDir}/config.toml"
    '';

    file."${codexXdgDir}/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${codexDotfilesDir}/AGENTS.md";
  };
}
