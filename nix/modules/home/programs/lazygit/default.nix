{
  pkgs,
  lib,
  config,
  ...
}:
let
  checkJsonschema = lib.getExe pkgs.check-jsonschema;
  delta = lib.getExe pkgs.delta;
  trash = lib.getExe pkgs.trash-cli;
  gitLogFormat = ''git log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate'';

  schemaUrl = "https://raw.githubusercontent.com/jesseduffield/lazygit/master/schema/config.json";
  lazygitConfigFile = "${config.xdg.configHome}/lazygit/config.yml";
  yamlFormat = pkgs.formats.yaml { };
  lazygitSettings = {
    gui = {
      nerdFontsVersion = "3";
      skipRewordInEditorWarning = true;
    };
    git = {
      allBranchesLogCmds = [ "${gitLogFormat} --all" ];
      branchLogCmd = "${gitLogFormat} {{branchName}} --";
      overrideGpg = true;
      pagers = [
        {
          colorArg = "always";
          pager = "${delta} --color-only --paging=never";
        }
      ];
    };
    customCommands = [
      {
        key = "n";
        context = "files";
        description = "git now";
        command = "git now";
      }
      {
        key = "I";
        context = "localBranches";
        description = "gh poi";
        command = "gh poi";
      }
      {
        key = "d";
        context = "worktrees";
        description = "Move worktree to trash";
        loadingText = "Trashing worktree";
        output = "log";
        prompts = [
          {
            type = "confirm";
            title = "Trash worktree";
            body = ''
              Move worktree to trash?

              Path:   {{.SelectedWorktree.Path}}
              Branch: {{.SelectedWorktree.Branch}}
            '';
          }
        ];
        command = ''
          {{- if .SelectedWorktree.IsMain -}}
          echo "Cannot trash the main worktree" >&2; exit 1
          {{- else if .SelectedWorktree.IsCurrent -}}
          echo "Cannot trash the current worktree" >&2; exit 1
          {{- else -}}
          ${trash} -- {{.SelectedWorktree.Path | quote}} && git worktree prune
          {{- end -}}
        '';
      }
    ];
  };
in
{
  programs.lazygit.enable = true;

  xdg.configFile."lazygit/config.yml" = {
    source = yamlFormat.generate "lazygit-config" lazygitSettings;
    force = true;
  };

  home.activation.validateLazygitSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    SETTINGS_FILE="${lazygitConfigFile}"

    echo "🔍 Validating lazygit config.yml..."
    if ${checkJsonschema} --default-filetype yaml --schemafile "${schemaUrl}" "$SETTINGS_FILE" 2>&1; then
      echo "✅ lazygit config.yml validation passed"
    else
      echo "⚠️  lazygit config.yml validation failed (non-blocking, schema may be outdated)" >&2
    fi
  '';
}
