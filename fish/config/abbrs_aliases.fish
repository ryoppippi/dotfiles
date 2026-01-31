alias vim nvim
abbr -a v nvim
abbr -a nv nvim
abbr -a bash 'bash --norc'
alias ls eza
abbr ll 'ls -hl'
abbr la 'ls -hlA'
abbr lt 'ls --tree'
abbr lg 'ls -hlFg'
abbr -a cdr 'cd (git root)'
abbr -a cdf __fzf_cd
abbr -a sed gsed
abbr -a sc "source $FISH_CONFIG"
abbr -a br brew
abbr -a wt wezterm
abbr -a bri 'brew install'
abbr -a clr clear
abbr -a rr 'rm -r'
abbr -a rf 'rm -rf'
abbr -a mkd 'mkdir -p'
abbr -a mkdir 'mkdir -p'
abbr -a src source
abbr -a o open
abbr -a bunb 'bun --bun'
abbr -a bunbx 'bunx --bun'
abbr -a cda conda
abbr -a lzg lazygit
abbr -a lzd lazydocker
abbr -a ech envchain
abbr -a y yazi
abbr -a vc 'code (pwd)'
abbr -a jn 'jupyter notebook'
abbr -a jl 'jupyter lab'
abbr -a py python
abbr -a yz yazi

# docker
abbr -a do docker container
abbr -a dop "docker container ps"
abbr -a dob "docker container build"
abbr -a dor "docker container run --rm"
abbr -a dox "docker container exec -it"

# docker compose
abbr -a dc docker compose
abbr -a dcu "docker compose up"
abbr -a dcub "docker compose up --build"
abbr -a dcd "docker compose down"
abbr -a dcr "docker compose restart"

# nix
abbr -a ns nix-shell
abbr -a ngc nix-collect-garbage
abbr -a nrn --set-cursor nix run nixpkgs#\%

abbr -a dv devenv

# deno
abbr -a dr "deno run -A --unstable"
abbr -a deno-cache-clear "rm -rf (deno info | string match --entire --regex 'DENO_DIR*' | string split ' ')[-1]"
abbr -a dt "deno task"

abbr -a pbc pbcopy
abbr -a pbp pbpaste

# git configs
type -q bit && alias git bit
abbr -a g git
abbr -a ga 'git add'
abbr -a ga. 'git add .'
abbr -a gaa 'git add --all'
abbr -a gco 'git checkout'
abbr -a gc 'git commit'
abbr -a gcn 'git commit -n'
abbr -a gcl 'git clone'
abbr -a --set-cursor gcm git commit -m \"%\"
abbr -a --set-cursor gcnm git commit -n -m \"%\"
abbr -a --set-cursor gcam git commit --amend -m \"%\"
abbr -a --set-cursor gcem git commit --allow-empty -m \"%\"
abbr -a gp 'git push'
abbr -a gpo 'git push origin'
abbr -a gpf git push --force-with-lease
abbr -a gpff git push --force
abbr -a gpl 'git pull'
abbr -a gf 'git fetch'
abbr -a gsw 'git switch'
abbr -a --set-cursor gswf 'git switch feature/%'
abbr -a gsm "command git switch main 2>/dev/null || command git switch master"
abbr -a gpt 'git push --tags'
abbr -a gr 'git rebase'
# git abbreviations using --command option (fish 4.0+)
abbr -a -c git a add # Stage files
abbr -a -c git aa add -a # Stage all modified files
abbr -a -c git ap add -p # Stage files interactively (patch mode)
abbr -a -c git cm commit -m # Commit with message
abbr -a -c git cma commit --amend -m # Amend commit with new message
abbr -a -c git b branch # List/create branches
abbr -a -c git bm branch -m # Rename branch
abbr -a -c git bu rev-parse --abbrev-ref --symbolic-full-name @{u} # Show upstream branch
abbr -a -c git bv branch -vv # List branches with tracking info
abbr -a -c git br browse # Open repo in browser
abbr -a -c git cl clone # Clone repository
abbr -a -c git cp cherry-pick # Cherry-pick commits
abbr -a -c git cpn cherry-pick -n # Cherry-pick without committing
abbr -a -c git f fetch # Fetch from remote
abbr -a -c git p push # Push to remote
abbr -a -c git pf push --force-with-lease --force-if-includes # Safe force push
abbr -a -c git pushf push --force-with-lease --force-if-includes # Safe force push (alias)
abbr -a -c git rbm rebase origin/main # Rebase on origin/main
abbr -a -c git rst reset # Reset HEAD
abbr -a -c git rs restore # Restore working tree files
abbr -a -c git st stash # Stash changes
abbr -a -c git sts status -s -uno # Short status without untracked files
abbr -a -c git sm submodule # Manage submodules
abbr -a -c git smu submodule update --remote --init --recursive # Update submodules recursively
abbr -a -c git sma submodule add # Add submodule
abbr -a -c git sw switch # Switch branches
abbr -a -c git swc switch -c # Create and switch to new branch
abbr -a -c git po push origin # Push to origin
abbr -a -c git difff diff --word-diff # Show word-level diff
abbr -a -c git cid log -n 1 --format=%H # Show latest commit ID
abbr -a -c git clb clean-local-branches # Delete merged local branches
abbr -a -c git id show -s --format=%H # Show commit ID
abbr -a -c git co checkout # Checkout branch/files
abbr -a -c git cob checkout -b # Create and checkout new branch
abbr -a -c git sha rev-parse HEAD # Show HEAD commit SHA
abbr -a -c git pl pull # Pull from remote

# gh
abbr -a ghp 'gh poi'
abbr -a -c gh pco 'pr checkout'
abbr -a -c gh pcr 'pr create'
abbr -a gh-fork-sync "gh repo list --limit 200 --fork --json nameWithOwner --jq '.[].nameWithOwner' | xargs -n1 gh repo sync"

# git extended
abbr -a -c git pbr browse-pr

# ghq
abbr -a gg 'ghq get'

# leetcode 
abbr -a lc leetcode
abbr -a lce leetcode e
abbr -a lct leetcode t
abbr -a lcx leetcode t
abbr -a lcp leetcode t

# ai
abbr -a cl claude
abbr -a cld claude --dangerously-skip-permissions
abbr -a cldc claude --dangerously-skip-permissions --continue
abbr -a clh claude --dangerously-skip-permissions --model haiku
abbr -a clo claude --dangerously-skip-permissions --model opus
abbr -a cls claude --dangerously-skip-permissions --model sonnet
abbr -a cls1 claude --dangerously-skip-permissions --model sonnet[1m]
abbr -a oc opencode
abbr -a cx codex
abbr -a ca cursor-agent

# misc
abbr -a n -f _na
