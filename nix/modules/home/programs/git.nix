{
  pkgs,
  lib,
  config,
  ...
}:
let
  # User configuration
  username = config.home.username;
  githubId = "1560508";
  email = "${githubId}+${username}@users.noreply.github.com";

  # Delta settings (shared with lazygit pager configuration)
  deltaSettings = {
    dark = true;
    syntax-theme = "GitHub";
    diff-so-fancy = true;
    keep-plus-minus-markers = true;
    side-by-side = true;
    hunk-header-style = "omit";
    line-numbers = true;
  };
in
{
  # Delta pager configuration (used by git)
  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = deltaSettings;
  };

  programs.git = {
    enable = true;

    signing = {
      key = null;
      signByDefault = true;
      format = "ssh";
    };

    lfs.enable = true;

    settings = {
      user = {
        name = username;
        email = email;
      };

      core = {
        autocrlf = "input";
        editor = "nvim";
        ignorecase = false;
        untrackedCache = false;
        fsmonitor = false;
      };

      ghq = {
        root = [
          "~/.go/src"
          "~/ghq"
        ];
      };

      color.ui = "auto";

      tag.sort = "version:refname";

      push = {
        default = "simple";
        autoSetupRemote = true;
        useForceIfIncludes = true;
      };

      commit.verbose = true;

      credential = {
        "https://github.com".helper = [
          ""
          "!gh auth git-credential"
        ];
        "https://gist.github.com".helper = [
          ""
          "!gh auth git-credential"
        ];
      };

      fetch = {
        writeCommitGraph = true;
        prune = true;
        pruneTags = true;
        all = true;
      };

      init.defaultBranch = "main";

      diff = {
        lockb = {
          textconv = "bun";
          binary = true;
        };
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };

      rebase = {
        autoStash = true;
        autoSquash = true;
        updateRefs = true;
      };

      merge = {
        ff = false;
        conflictstyle = "zdiff3";
      };

      pull.rebase = true;

      remote.pushDefault = "origin";

      column.ui = "auto";

      branch.sort = "-committerdate";

      help.autocorrect = "prompt";

      rerere = {
        enabled = true;
        autoupdate = true;
      };

      alias = {
        # Interactive add with fzf preview using delta
        apf = ''!git ls-files -m -o --exclude-standard | fzf -m --print0 --preview "echo {} | xargs git diff | delta" | xargs -0 -o -t git add -p'';

        # Amend the last commit without editing the message
        fixit = "commit --amend --no-edit";

        # Open the repository in a web browser
        browse = "!gh repo view --web";

        # Get the commit URL for the current HEAD
        brc = ''!"echo $(gh repo view --json url  --jq .url)/commit/$(git rev-parse HEAD)"'';

        # Clone with submodules recursively
        clone = "clone --recursive";

        # Delete a local branch and push the deletion to remote
        dlr = "!sh -c 'git branch -D $1 && git push origin :$1' -";

        # Show git status for all submodules
        sms = ''submodule foreach "git status"'';

        # Switch to a remote branch selected with fzf
        swor = ''!f() { local -r ref=$(git branch -r | fzf); git sw "''${1:-''${ref#*/}}" $ref; }; f'';

        # Switch to a branch (local or remote) selected with fzf
        swf = "!git branch -a | fzf | xargs git switch";

        # Delete all local branches that have been merged
        clean-local-branches = ''!"git branch --merged | grep -v \\* | xargs git branch -d"'';

        # View an issue selected with fzf from the issue list
        isv = ''!gh issue list| fzf-tmux --prompt "issue preview>" --preview "echo {} | awk '{print \$1}' | xargs gh issue view -p" | xargs gh issue view'';

        # View a PR selected with fzf from the PR list
        prv = ''!gh pr list| fzf-tmux --prompt "pr preview>" --preview "echo {} | awk '{print \$1}' | xargs gh pr view -p" | xargs gh pr view'';

        # Checkout the main branch (auto-detect main or master)
        com = ''!f() { remote_head=$(git symbolic-ref --quiet refs/remotes/origin/HEAD); remote_head=''${remote_head#refs/remotes/origin/}; git checkout ''${remote_head:-$(git rev-parse --symbolic --verify --quiet main || git rev-parse --symbolic --verify --quiet master)}; }; f'';

        # Setup to fetch GitHub pull requests as local branches
        pr-setup = "config --add remote.origin.fetch +refs/pull/*/head:refs/remotes/origin/pr/*";

        # Show recent branches from reflog
        rb = ''!git reflog -n 50 --pretty='format:%gs' | perl -anal -e '$seen{$1}++ or print $1 if /checkout:.*to (.+)/'"'';

        # Show the root directory of the repository
        root = "rev-parse --show-toplevel";

        # Show today's commit statistics (lines added/deleted)
        today-numstat = ''
          !"f(){ \
            git log \
            --numstat \
            --branches \
            --no-merges \
            --since=midnight \
            --author=\"$(git config user.name)\" \
            | awk 'NF==3 {a+=$1; d+=$2} END { \
              printf(\"%d (\\x1b[32m+%d\\033[m, \\x1b[31m-%d\\033[m)\\n\", a+d, a, d)\
            }'; \
          };f"'';

        # Pretty log with graph
        logg = ''log --graph --abbrev-commit --pretty=format:"%C(yellow)%h%C(reset) - %C(cyan)%ad%C(reset) %C(green)(%ar)%C(reset)%C(auto)%d%C(reset)%n          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%n"'';

        # List all git aliases
        aliases = ''!git config --get-regexp alias |  sed 's/^alias.//g' | sed 's/ / = /1' '';
      };
    };

    ignores = [
      # Environment
      ".venv"
      ".envrc"

      # macOS
      ".DS_Store"
      ".AppleDouble"
      ".LSOverride"
      "Icon"
      "._*"
      ".DocumentRevisions-V100"
      ".fseventsd"
      ".Spotlight-V100"
      ".TemporaryItems"
      ".Trashes"
      ".VolumeIcon.icns"
      ".com.apple.timemachine.donotpresent"
      ".AppleDB"
      ".AppleDesktop"
      "Network Trash Folder"
      "Temporary Items"
      ".apdisk"

      # Python
      "__pycache__/"
      "*.py[cod]"
      "*$py.class"
      "*.so"
      ".Python"
      "build/"
      "develop-eggs/"
      "dist/"
      "downloads/"
      "eggs/"
      ".eggs/"
      "lib64/"
      "parts/"
      "sdist/"
      "var/"
      "wheels/"
      "pip-wheel-metadata/"
      "share/python-wheels/"
      "*.egg-info/"
      ".installed.cfg"
      "*.egg"
      "MANIFEST"
      "*.manifest"
      "*.spec"
      "pip-log.txt"
      "pip-delete-this-directory.txt"
      "htmlcov/"
      ".tox/"
      ".nox/"
      ".coverage"
      ".coverage.*"
      ".cache"
      "nosetests.xml"
      "coverage.xml"
      "*.cover"
      "*.py,cover"
      ".hypothesis/"
      ".pytest_cache/"
      "*.mo"
      "*.pot"
      "*.log"
      "local_settings.py"
      "db.sqlite3"
      "db.sqlite3-journal"
      "instance/"
      ".webassets-cache"
      ".scrapy"
      "docs/_build/"
      "target/"
      ".ipynb_checkpoints"
      "profile_default/"
      "ipython_config.py"
      ".python-version"
      "__pypackages__/"
      "celerybeat-schedule"
      "celerybeat.pid"
      "*.sage.py"
      ".env"
      "env/"
      "venv/"
      "ENV/"
      "env.bak/"
      "venv.bak/"
      ".spyderproject"
      ".spyproject"
      ".ropeproject"
      "/site"
      ".mypy_cache/"
      ".dmypy.json"
      "dmypy.json"
      ".pyre/"

      # Claude Code
      "**/.claude/settings.local.json"
      "**/CLAUDE.local.md"
    ];
  };
}
