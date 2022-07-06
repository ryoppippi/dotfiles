if status --is-interactive
    bass source ~/.bash_profile
end

starship init fish | source

set -g theme_nerd_fonts yes

set -l FISH_CONFIG $XDG_CONFIG_HOME/fish

# fzf config
set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-messages --glob "!/^[^\/]+\/.git/\/?(?:[^\/]+\/?)*" '
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_DEFAULT_OPTS '--extended --cycle --select-1 --height 40% --reverse --border'
set -x FZF_FIND_FILE_OPTS '--preview "bat --color=always --style=header,grid --line-range :100 {}"'
set -x FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_COMPLETION_TRIGGER '**'

# ghq config
set -x GHQ_SELECTOR_OPTS ""
# set -x GHQ_SELECTOR_OPTS "--preview 'head {}/README.*'"
set -x GHQ_SELECTOR fzf

# enhancd config
set -x ENHANCED_FILTER fzf
set -x ENHANCD_HOOK_AFTER_CD 'exa -hlF'
set -x ENHANCD_DIR $FISH_CONFIG/functions/enhancd
set -x ENHANCD_ROOT $FISH_CONFIG/functions/enhancd

# zoxide
zoxide init fish | source

# python
set -x VIRTUAL_ENV_DISABLE_PROMPT 1

alias rm trash
alias vim nvim
alias git hub
alias bash 'bash --norc'
alias flush 'vim -c "sleep 1m" -c q'
alias gip 'curl -s http://ipecho.net/plain; echo'
alias lip 'ipconfig getifaddr en0'
alias ls 'exa --icons -hlF'
alias la 'ls -a'
alias lt 'ls --tree'
alias lg 'la --git'
alias nvprofile 'touch /tmp/startup.log && rm /tmp/startup.log &&  nvim --startuptime /tmp/startup.log +qa && nvim /tmp/startup.log -c "%!sort -k2nr" -c "w"'
alias nvbench 'hyperfine "nvim --headless +qa" --warmup 4 --prepare "nvim --headless +qa"'
abbr -a venvav "source ./.venv/bin/activate.fish or  source ./venv/bin/activate.fish"
abbr -a GHCI 'stack ghci'
abbr -a sed gsed
abbr -a dact deactivate
# abbr -a cat ccat
abbr -a b brew
abbr -a t tmux
abbr -a tt tmuximum
abbr -a bri 'brew install'
abbr -a clr clear
abbr -a rr 'rm -r'
abbr -a rf 'rm -rf'
abbr -a mkdir 'mkdir -p'
abbr -a src source
abbr -a cdd __fzf_cd
abbr -a g git
abbr -a ga 'git add'
abbr -a ga. 'git add .'
abbr -a gaa 'git add --all'
abbr -a gco 'git checkout'
abbr -a gcm 'git commit -m "'
abbr -a gca 'git commit --amend -m "'
abbr -a gp 'git push'
abbr -a gpo 'git push origin'
abbr -a gpf 'git pushf'
abbr -a gpfo 'git pushf origin'
abbr -a o open
abbr -a v nvim
abbr -a nv nvim
# abbr -a c 'code'
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
abbr -a ptry poetry
abbr -a d docker
abbr -a dp "docker ps"
abbr -a db "docker build"
abbr -a dr "docker run --rm"
abbr -a dx "docker exec -it"
abbr -a dc docker-compose
abbr -a dcu "docker-compose up"
abbr -a dcub "docker-compose up --build"
abbr -a dcd "docker-compose down"
abbr -a dcr "docker-compose restart"
abbr -a gg googler

abbr -a cpf "pbcopy < "
abbr -a paf "pbpaste > "

# abbr -a pyenv "env CC=/usr/bin/gcc CXX=/usr/bin/g++  PYTHON_CONFIGURE_OPTS='--enable-framework --enable-toolbox-glue --enable-big-digits --enable-unicode --with-threads' pyenv"
abbr -a addvenv "echo layout python3 >> .envrc && direnv allow"

# if test (uname -m) = arm64
#     eval conda "shell.fish" hook $argv | source
#     conda deactivate
# end


# if test -z $TMUX && test -z $VIRTUAL_ENV
#     if not status --is-login && status --is-interactive && test "$TERM_PROGRAM" != "vscode"
#         bash -c "tmuximum"
#     end
# end
