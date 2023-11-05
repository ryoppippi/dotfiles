test -n "$LOADED_ABBRS_ALIASES" && return
set -x LOADED_ABBRS_ALIASES 1

alias vim nvim
abbr -a v nvim
abbr -a nv nvim
abbr -a bash 'bash --norc'
abbr ll 'ls -hlF'
abbr la 'ls -hlFA'
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
abbr -a bunx 'bun x'
abbr -a bunbx 'bun --bun x'
abbr -a cda conda
abbr -a lzg lazygit
abbr -a lzd lazydocker
abbr -a ech envchain
abbr -a vc 'code (pwd)'
abbr -a jn 'jupyter notebook'
abbr -a jl 'jupyter lab'
abbr -a py python
abbr -a d docker
abbr -a dp "docker ps"
abbr -a db "docker build"
abbr -a dr "docker run --rm"
abbr -a dx "docker exec -it"
abbr -a dc docker compose
abbr -a dcu "docker compose up"
abbr -a dcub "docker compose up --build"
abbr -a dcd "docker compose down"
abbr -a dcr "docker compose restart"

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
