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
abbr -a sed gsed
abbr -a sc "source $FISH_CONFIG"
abbr -a br brew
abbr -a t tmux
abbr -a tt tmuximum
abbr -a wt wezterm
abbr -a bri 'brew install'
abbr -a clr clear
abbr -a rr 'rm -r'
abbr -a rf 'rm -rf'
abbr -a mkd 'mkdir -p'
abbr -a mkdir 'mkdir -p'
abbr -a src source
abbr -a cdd __fzf_cd
abbr -a o open
abbr -a bunb 'bun --bun'
abbr -a bunbx 'bunx --bun'
abbr -a cda conda
abbr -a lzg lazygit
abbr -a lzd lazydocker
abbr -a ech envchain
abbr -a vc 'code (pwd)'
abbr -a jn 'jupyter notebook'
abbr -a jl 'jupyter lab'
abbr -a py python

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

# devbox
abbr -a dx devbox
abbr -a dxr devbox run
abbr -a dxa devbox run
abbr -a dxrm devbox rm
# abbr -a -c devbox r run
# abbr -a -c devbox a add

# nix
abbr -a ns nix-shell
abbr -a ngc nix-collect-garbage

# deno
abbr -a dr "deno run -A --unstable"
abbr -a deno-cache-clear "rm -rf (deno info | string match --entire --regex 'DENO_DIR*' | string split ' ')[-1]"
abbr -a dt "deno task"

abbr -a cpf "pbcopy < "
abbr -a paf "pbpaste > "

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
abbr -a gcz 'git cz'
abbr -a gcza 'git cza'
abbr -a gp 'git push'
abbr -a gpo 'git push origin'
abbr -a gpf 'git pushf'
abbr -a gpfo 'git pushf origin'
abbr -a gpl 'git pull'
abbr -a gf 'git fetch'
abbr -a gsw 'git switch'
abbr -a gsm "command git switch main 2>/dev/null || command git switch master"
abbr -a gpt 'git push --tags'

# gh
abbr -a ghp 'gh poi'

# ghq
abbr -a gg 'ghq get'

# github copilot
abbr -a --set-cursor q gh copilot suggest -t shell \"%\"
abbr -a --set-cursor qgit gh copilot suggest -t git \"%\"
abbr -a --set-cursor qgh gh copilot suggest -t gh \"%\"

# gh
abbr -a gh-fork-sync "gh repo list --limit 200 --fork --json nameWithOwner --jq '.[].nameWithOwner' | xargs -n1 gh repo sync"

# misc
abbr -a n -f _na
abbr --position anywhere rpp ryoppippi
