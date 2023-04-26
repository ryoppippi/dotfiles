if status --is-interactive
    bass source ~/.bash_profile
end

#test -d "$HOME/.tea" && "$HOME/.tea/tea.xyz/v*/bin/tea" --magic=fish --silent | source

starship init fish | source

set -g theme_nerd_fonts yes

set -l FISH_CONFIG $XDG_CONFIG_HOME/fish
for file in $FISH_CONFIG/config/*.fish
    source $file
end

set -l FISH_USER_FUNCTIONS $FISH_CONFIG/user_functions
set -gp fish_function_path $FISH_USER_FUNCTIONS $fish_function_path


# zoxide
zoxide init fish | source

# python
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

if type -q trash
    alias rm trash
end

alias vim nvim
alias bash 'bash --norc'
alias ls 'exa --icons -hlF'
alias lsa 'ls -a'
alias lst 'ls --tree'
alias lsg 'la --git'
alias nvprofile 'touch /tmp/startup.log && rm /tmp/startup.log &&  nvim --startuptime /tmp/startup.log +qa && nvim /tmp/startup.log -c "%!sort -k2nr" -c "w"'
alias nvbench 'hyperfine "nvim --headless +qa" --warmup 4 --prepare "nvim --headless +qa"'
abbr -a venvav "source ./.venv/bin/activate.fish or  source ./venv/bin/activate.fish"
abbr -a GHCI 'stack ghci'
abbr -a sed gsed
abbr -a b brew
abbr -a t tmux
abbr -a tt tmuximum
abbr -a wt wezterm
abbr -a bri 'brew install'
abbr -a clr clear
abbr -a rr 'rm -r'
abbr -a rf 'rm -rf'
abbr -a mkdir 'mkdir -p'
abbr -a src source
abbr -a cdd __fzf_cd
abbr -a o open
abbr -a v nvim
abbr -a nv nvim
abbr -a y yarn
abbr -a ya 'yarn add -D'
abbr -a cda conda
abbr -a lzg lazygit
abbr -a lzd lazydocker
abbr -a ech envchain
abbr -a cci 'ech circleci circleci-cli'
abbr -a ccibr 'cci browse'
abbr -a xsh xonsh
abbr -a vc 'code (pwd)'
abbr -a jn 'jupyter notebook'
abbr -a jl 'jupyter lab'
abbr -a py python
abbr -a ppv pipenv
abbr -a ppx pipx
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

abbr -a addvenv "echo layout python3 >> .envrc && direnv allow"

# git configs
abbr -a g git
abbr -a ga 'git add'
abbr -a ga. 'git add .'
abbr -a gaa 'git add --all'
abbr -a gco 'git checkout'
abbr -a gcm 'git commit -m "'
abbr -a gcam 'git commit --amend -m "'
abbr -a gcz 'git cz'
abbr -a gcza 'git cza'
abbr -a gp 'git push'
abbr -a gpo 'git push origin'
abbr -a gpf 'git pushf'
abbr -a gpfo 'git pushf origin'
abbr -a gpl 'git pull'
abbr -a gf 'git fetch'

# if test -z $TMUX && test -z $VIRTUAL_ENV
#     if not status --is-login && status --is-interactive && test "$TERM_PROGRAM" != "vscode"
#         bash -c "tmuximum"
#     end
# end
