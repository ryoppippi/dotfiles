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

  # The Nix build only ad-hoc signs Codex, so its code identity changes with
  # every rebuild and macOS rejects its keychain access. The build sandbox
  # cannot reach the signing key, so activation copies the package out of the
  # store and re-signs it with a stable identity instead; the designated
  # requirement then names the certificate rather than a per-build hash.
  codex = pkgs.llm-agents.codex;
  codexSignedDir = "${config.xdg.dataHome}/codex-signed";
  codexSigningIdentity = "Apple Development: Ryotaro Kimura (24NNYUUHGN)";
  codexBinaries = [
    "codex"
    "codex-code-mode-host"
    "logs_client"
  ];
  # Points at the signed copy. Linking `share` keeps the shell completions and
  # roots the original package, whose ripgrep and libraries the copy still uses.
  codexSigned = pkgs.runCommand "codex-signed-${codex.version}" { meta.mainProgram = "codex"; } ''
    mkdir -p $out/bin
    ${lib.concatMapStrings (bin: ''
      ln -s ${lib.escapeShellArg "${codexSignedDir}/bin/${bin}"} $out/bin/${bin}
    '') codexBinaries}
    ln -s ${codex}/share $out/share
  '';

  nu = lib.getExe pkgs.nushell;

  # Codex has no import mechanism, so ~/.codex/AGENTS.md is generated at switch
  # time from the shared entry point: its `@` imports — which only Claude Code
  # resolves — are dropped and the fragments they name are appended instead.
  sharedFragments = [
    ../../../../../agents/shared/tools.md
    ../../../../../agents/shared/nix.md
    ../../../../../agents/shared/code-comments.md
    ../../../../../agents/shared/command-privacy.md
    ../../../../../agents/shared/git.md
    ../../../../../agents/shared/delegate-work.md
  ];

  dropClaudeImports =
    text:
    let
      kept = lib.filter (line: !(lib.hasPrefix "@~/.config/claude/shared/" line)) (
        lib.splitString "\n" text
      );
      # Each import sits in its own paragraph, so removing them leaves a run of
      # blank lines where the import block was.
      squashed = lib.foldl' (
        acc: line: if line == "" && acc != [ ] && lib.last acc == "" then acc else acc ++ [ line ]
      ) [ ] kept;
    in
    lib.concatStringsSep "\n" squashed;

  agentsMdText = lib.concatStringsSep "\n" (
    [ (dropClaudeImports (builtins.readFile ../../../../../agents/AGENTS.md)) ]
    ++ map builtins.readFile sharedFragments
  );

  settings = {
    model = "gpt-6.1-sol";
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
      experimental_use_profile = true;
    };

    features = {
      goals = true;
      memories = true;
      multi_agent = true;
    };

    agents = {
      max_concurrent_threads_per_session = 100;
      default_subagent_model = "gpt-6-luna";
      default_subagent_reasoning_effort = "max";
    };

    notice.fast_default_opt_out = true;

    # Codex skips a hook until it is trusted in `/hooks`, and trust is keyed to
    # the definition's hash, so a changed script needs trusting again.
    hooks = import ../../agent-hooks { inherit pkgs lib; };

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

    # For sessions outside T3 Code; its threads get `t3-code` injected.
    mcp_servers.t3.url = "http://127.0.0.1:3773/mcp";
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
    packages = [ codexSigned ];

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

    # Re-copies and re-signs only when the package changes or the copy no
    # longer verifies. Without the identity (another machine) the copy stays
    # ad-hoc signed, which behaves as the store package did.
    activation.signCodex = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      src=${codex}/libexec/codex
      dest=${lib.escapeShellArg codexSignedDir}
      identity=${lib.escapeShellArg codexSigningIdentity}
      if [ "$(cat "$dest/.source" 2>/dev/null)" != "$src" ] \
        || ! /usr/bin/codesign --verify --strict "$dest/bin/codex" 2>/dev/null; then
        mkdir -p "$(dirname "$dest")"
        tmp=$(mktemp -d "$dest.XXXXXX")
        cp -R "$src/." "$tmp/"
        chmod -R u+w "$tmp"
        if /usr/bin/security find-identity -v -p codesigning | grep -qF "\"$identity\""; then
          for bin in ${lib.escapeShellArgs codexBinaries}; do
            /usr/bin/codesign --force --sign "$identity" "$tmp/bin/$bin"
          done
        else
          echo "signCodex: signing identity '$identity' not found; keeping the ad-hoc signature" >&2
        fi
        echo "$src" > "$tmp/.source"
        rm -rf "$dest"
        mv "$tmp" "$dest"
      fi
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
