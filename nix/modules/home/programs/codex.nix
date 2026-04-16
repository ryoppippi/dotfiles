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
  bunx = "${pkgs.bun}/bin/bunx";

  settings = {
    model = "gpt-5.4";
    approval_policy = "on-request";
    model_reasoning_effort = "xhigh";
    web_search_request = true;
    personality = "pragmatic";
    service_tier = "fast";
    project_doc_fallback_filenames = [ "CLAUDE.md" ];

    mcp_servers = {
      chrome-devtools = {
        command = bunx;
        enabled = false;
        args = [ "chrome-devtools-mcp@latest" ];
      };
    };

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
