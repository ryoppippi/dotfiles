{
  pkgs,
  lib,
  config,
  dotfilesDir ? "${config.home.homeDirectory}/ghq/github.com/ryoppippi/dotfiles",
  ...
}: let
  codexConfigDir = "${config.xdg.configHome}/codex";
  codexDotfilesDir = "${dotfilesDir}/codex";
  helpers = import ../lib/activation-helpers.nix {inherit lib;};

  # TOML format generator
  tomlFormat = pkgs.formats.toml {};

  # Codex configuration settings
  settings = {
    model = "gpt-5.1-codex";
    approval_policy = "on-request";
    model_reasoning_effort = "medium";
    web_search_request = true;

    mcp_servers = {
      figma-dev-mode-mcp-server = {
        startup_timeout_ms = 5000;
        url = "http://127.0.0.1:3845/mcp";
      };

      deepwiki = {
        startup_timeout_ms = 5000;
        url = "https://mcp.deepwiki.com/mcp";
      };

      context7 = {
        startup_timeout_ms = 5000;
        url = "https://mcp.context7.com/mcp";
      };

      chrome-devtools = {
        command = "nix";
        enabled = false;
        args = [
          "shell"
          "nixpkgs#bun"
          "--command"
          "bunx"
          "chrome-devtools-mcp@latest"
        ];
      };

      lsmcp-tsgo = {
        command = "nix";
        args = [
          "shell"
          "nixpkgs#bun"
          "--command"
          "bunx"
          "@mizchi/lsmcp@latest"
          "-p"
          "tsgo"
        ];
      };

      devenv = {
        command = "devenv";
        args = ["mcp"];
      };
    };

    notice = {
      hide_gpt5_1_migration_prompt = true;
      "hide_gpt-5.1-codex-max_migration_prompt" = true;
    };
  };

  # Wrap Codex with CODEX_HOME environment variable
  codex-wrapped = pkgs.symlinkJoin {
    name = "codex-wrapped";
    paths = [pkgs.codex];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/codex \
        --set CODEX_HOME ${codexConfigDir}
    '';
  };
in {
  # Codex package with CODEX_HOME wrapper
  home.packages = [codex-wrapped];

  # Codex configuration files
  home.file = {
    # Generated config.toml from Nix settings
    "${codexConfigDir}/config.toml".source = tomlFormat.generate "codex-config" settings;
  };

  # Create direct symlink to AGENTS.md in dotfiles (bypassing Nix store)
  home.activation.linkCodexAgents = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${helpers.mkLinkForce}
    $DRY_RUN_CMD mkdir -p "${codexConfigDir}"
    link_force "${codexDotfilesDir}/AGENTS.md" "${codexConfigDir}/AGENTS.md"
  '';
}
