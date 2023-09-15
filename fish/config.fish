set -gx LC_ALL 'en_US.UTF-8'
set -gx BASH_SILENCE_DEPRECATION_WARNING 1

set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME "$HOME/.config"

set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME "$HOME/.local/share"

# export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"

set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish
set -g FISH_USER_FUNCTIONS $FISH_CONFIG_DIR/user_functions
set -g CACHE_DIR $HOME/.cache/fish
set -gp fish_function_path $FISH_USER_FUNCTIONS $fish_function_path

# general bin paths
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/opt/coreutils/libexec/gnubin
fish_add_path /usr/local/opt/curl/bin

# xcode
fish_add_path /Applications/Xcode.app/Contents/Developer/usr/bin

# brew
set -gx HOMEBREW_BUNDLE_FILE "$HOME/brew/Brewfile"
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_ARM_BIN /opt/homebrew/bin
set -gx HOMEBREW_X86_64_BIN /usr/local/bin
fish_add_path $HOMEBREW_ARM_BIN
fish_add_path $HOMEBREW_X86_64_BIN

# aqua
set -gx AQUA_ROOT_DIR "$XDG_DATA_HOME/aquaproj-aqua"
fish_add_path -p $AQUA_ROOT_DIR/bin

set -gx AQUA_GLOBAL_CONFIG $AQUA_GLOBAL_CONFIG $XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml

# c / c++
# c++
# export CPPFLAGS=-I/opt/X11/include
# export LDFLAGS="$LDFLAGS -L/usr/local/opt/zlib/lib -L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/binutils/lib -L/opt/homebrew/lib"
# export CFLAGS="-I/usr/local/opt/zlib/include -I$(xcrun --show-sdk-path) $CFLAGS"
# export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/zlib/include -I/usr/local/opt/readline/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include -I$(xcrun --show-sdk-path) -I/usr/local/opt/binutils/include -I/opt/homebrew/include"
# export LDFLAGS="$LDFLAGS -L/usr/local/opt/openblas/lib -L/usr/local/opt/lapack/lib"
# export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openblas/include -I/usr/local/opt/lapack/include"
set -gx USE_CCACHE 1
set -gx CCACHE_DIR "$HOME/.ccache"

# js/ts
## volta
fish_add_path $HOME/.volta/bin
## bun
fish_add_path $HOME/.bun/bin
## nodebrew
fish_add_path $HOME/.nodebrew/current/bin

# go
set -gx GOPATH "$HOME/go"
fish_add_path $GOPATH/bin

# rust 
fish_add_path "$HOME/.cargo/bin"

# nim
fish_add_path "$HOME/.nimble/bin"

# zig
fish_add_path "$HOME/zig"

# ruby
fish_add_path "$HOMEBREW_ARM_BIN/opt/ruby/bin"
fish_add_path "$HOMEBREW_X86_64_BIN/opt/ruby/bin"

# python
fish_add_path "$HOME/.rye/shims"
fish_add_path "$HOME/.poetry/bin"
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx PYENV_ROOT "$HOME/.pyenv"
set -gx BETTER_EXCEPTIONS 1
## codon
fish_add_path "$HOME/.codon/bin"

# user scripts
fish_add_path $HOME/.scripts
fish_add_path $HOME/.scripts/bin

# Neovim
if type -q nvim
    set -gx EDITOR nvim
    set -gx GIT_EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER "nvim -c ASMANPAGER -"
end

# configs
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file
end

# theme
set -gx theme_nerd_fonts yes
set -gx BAT_THEME TwoDark
source $FISH_CONFIG_DIR/themes/kanagawa.fish

# aliases and abbreviations

type -q trash && alias rm trash
alias vim nvim
alias bash 'bash --norc'
alias nvprofile 'touch /tmp/startup.log && rm /tmp/startup.log &&  nvim --startuptime /tmp/startup.log +qa && nvim /tmp/startup.log -c "%!sort -k2nr" -c "w"'
alias nvbench 'hyperfine "nvim --headless +qa" --warmup 4 --prepare "nvim --headless +qa"'
abbr ls lsd
abbr ll 'lsd -hlF'
abbr la 'lsd -hlFA'
abbr lt 'lsd --tree'
abbr lg 'lsd -hlFg'
abbr -a cdr 'cd (git root)'
abbr -a venvav "source ./.venv/bin/activate.fish or  source ./venv/bin/activate.fish"
abbr -a GHCI 'stack ghci'
abbr -a sed gsed
abbr -a sc "source $FISH_CONFIG"
abbr -a b brew
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
abbr -a v nvim
abbr -a nv nvim
abbr -a y yarn
abbr -a ya 'yarn add -D'
abbr -a bunx 'bun x'
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

# third party config cache
set -l CONFIG_CACHE $CACHE_DIR/config.fish
if test "$FISH_CONFIG" -nt "$CONFIG_CACHE"
    mkdir -p $CACHE_DIR
    echo '' >$CONFIG_CACHE

    echo "fish_add_path $(gem environment gemdir)/bin" >>$CONFIG_CACHE
    direnv hook fish >>$CONFIG_CACHE
    zoxide init fish >>$CONFIG_CACHE
    # starship init fish >>$CONFIG_CACHE

    echo 'cache generated'
end
source $CONFIG_CACHE


if status is-interactive
    stty stop undef
    stty start undef
end
