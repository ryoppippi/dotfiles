[alias]
  ; Interactive add with fzf preview using delta
  apf = "!git ls-files -m -o --exclude-standard | fzf -m --print0 --preview \"echo {} | xargs git diff | delta\" | xargs -0 -o -t git add -p"
  ; Amend the last commit without editing the message
  fixit = commit --amend --no-edit
  ; Open the repository in a web browser
  browse = !gh repo view --web
  ; Open the pull request in a web browser
  browse-pr = !gh pr view --web
  ; Get the commit URL for the current HEAD
  brc = !"echo $(gh repo view --json url  --jq .url)/commit/$(git rev-parse HEAD)"
  ; Clone with submodules recursively
  clone = clone --recursive
  ; Delete a local branch and push the deletion to remote
  dlr = !sh -c 'git branch -D $1 && git push origin :$1' -
  ; Show git status for all submodules
  sms = submodule foreach \"git status\"
  ; Switch to a remote branch selected with fzf
  swor = "!f() { local -r ref=$(git branch -r | fzf); git sw \"${1:-${ref#*/}}\" $ref; }; f"
  ; Switch to a branch (local or remote) selected with fzf
  swf =!git branch -a | fzf | xargs git switch
  ; Delete all local branches that have been merged
  clean-local-branches = !"git branch --merged | grep -v \\* | xargs git branch -d"
  ; View an issue selected with fzf from the issue list
  isv = !gh issue list| fzf-tmux --prompt \"issue preview>\" --preview \"echo {} | awk '{print \\$1}' | xargs gh issue view -p\" | xargs gh issue view
  ; View a PR selected with fzf from the PR list
  prv = !gh pr list| fzf-tmux --prompt \"pr preview>\" --preview \"echo {} | awk '{print \\$1}' | xargs gh pr view -p\" | xargs gh pr view
  ; Checkout the main branch (auto-detect main or master)
  com = "!f() { remote_head=$(git symbolic-ref --quiet refs/remotes/origin/HEAD); remote_head=${remote_head#refs/remotes/origin/}; git checkout ${remote_head:-$(git rev-parse --symbolic --verify --quiet main || git rev-parse --symbolic --verify --quiet master)}; }; f"
  ; Setup to fetch GitHub pull requests as local branches
  pr-setup = config --add remote.origin.fetch +refs/pull/*/head:refs/remotes/origin/pr/*
  ; Show recent branches from reflog
  rb = "!git reflog -n 50 --pretty='format:%gs' | perl -anal -e '$seen{$1}++ or print $1 if /checkout:.*to (.+)/'"
  ; Show the root directory of the repository
  root = rev-parse --show-toplevel
  ; Show today's commit statistics (lines added/deleted)
  today-numstat = !"f(){ \
    git log \
    --numstat \
    --branches \
    --no-merges \
    --since=midnight \
    --author=\"$(git config user.name)\" \
    | awk 'NF==3 {a+=$1; d+=$2} END { \
      printf(\"%d (\\x1b[32m+%d\\033[m, \\x1b[31m-%d\\033[m)\\n\", a+d, a, d)\
    }'; \
  };f"
  ; Pretty log with graph
  logg = log --graph --abbrev-commit --pretty=format:\"%C(yellow)%h%C(reset) - %C(cyan)%ad%C(reset) %C(green)(%ar)%C(reset)%C(auto)%d%C(reset)%n          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%n\"
  ; List all git aliases
  aliases = !git config --get-regexp alias |  sed 's/^alias.//g' | sed 's/ / = /1'
