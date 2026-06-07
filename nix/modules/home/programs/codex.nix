{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}:
let
  codexConfigDir = "${config.xdg.configHome}/codex";
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
      CODEX_HOME = codexConfigDir;
    };

    activation.writeCodexConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p "${codexConfigDir}"
      cp --no-preserve=mode,ownership ${tomlFormat.generate "codex-config" settings} "${codexConfigDir}/config.toml"
      chmod 644 "${codexConfigDir}/config.toml"
    '';

    file."${codexConfigDir}/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${codexDotfilesDir}/AGENTS.md";
  };
}
