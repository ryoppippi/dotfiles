set -gx LC_ALL "en_US.UTF-8"
set -gx BASH_SILENCE_DEPRECATION_WARNING 1

# define XDG paths
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share

# define fish config paths
set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish
set -g FISH_CACHE_DIR $HOME/.cache/fish

# add user config
set -gp fish_function_path $FISH_CONFIG_DIR/user_functions $fish_function_path
# function load_user_config
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file &
end

# theme
set -gx theme_nerd_fonts yes
set -gx BIT_THEME monochrome
source $FISH_CONFIG_DIR/themes/kanagawa.fish

# general bin paths
fish_add_path $HOME/.local/bin
fish_add_path /usr/local/opt/coreutils/libexec/gnubin
fish_add_path /usr/local/opt/curl/bin

# brew
set -gx HOMEBREW_BUNDLE_FILE $HOME/.Brewfile
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_ARM /opt/homebrew
set -gx HOMEBREW_X86_64 /usr/local
fish_add_path $HOMEBREW_ARM/bin
fish_add_path $HOMEBREW_X86_64/bin

# aqua
set -gx AQUA_ROOT_DIR $XDG_DATA_HOME/aquaproj-aqua
set -gx AQUA_GLOBAL_CONFIG $XDG_CONFIG_HOME/aquaproj-aqua/aqua.yaml
fish_add_path -p $AQUA_ROOT_DIR/bin

# c / c++
# c++
# export CPPFLAGS=-I/opt/X11/include
# export LDFLAGS="$LDFLAGS -L/usr/local/opt/zlib/lib -L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/binutils/lib -L/opt/homebrew/lib"
# export CFLAGS="-I/usr/local/opt/zlib/include -I$(xcrun --show-sdk-path) $CFLAGS"
# export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/zlib/include -I/usr/local/opt/readline/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include -I$(xcrun --show-sdk-path) -I/usr/local/opt/binutils/include -I/opt/homebrew/include"
# export LDFLAGS="$LDFLAGS -L/usr/local/opt/openblas/lib -L/usr/local/opt/lapack/lib"
# export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openblas/include -I/usr/local/opt/lapack/include"
set -gx USE_CCACHE 1
set -gx CCACHE_DIR $HOME/.ccache

# js/ts
## volta
fish_add_path $HOME/.volta/bin
## bun
fish_add_path $HOME/.bun/bin

# go
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# nim
fish_add_path $HOME/.nimble/bin

# zig
fish_add_path $HOME/zig

# python
fish_add_path $HOME/.rye/shims
fish_add_path $HOME/.poetry/bin
# set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx PYENV_ROOT $HOME/.pyenv
set -gx BETTER_EXCEPTIONS 1
## codon
fish_add_path $HOME/.codon/bin

# user scripts
fish_add_path $HOME/.scripts
fish_add_path $HOME/.scripts/bin

# Neovim
if type -q nvim or (type -q mise and test $(mise where -q neovim) != "")
    set -gx EDITOR nvim
    set -gx GIT_EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER "nvim -c ASMANPAGER -"
end

# Secretive
set SSH_SECRETIVE_SSH_SOCK $HOME/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh
test -e $SSH_SECRETIVE_SSH_SOCK && set -gx SSH_AUTH_SOCK $SSH_SECRETIVE_SSH_SOCK

# config caches
set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish
if test "$FISH_CONFIG" -nt "$CONFIG_CACHE"
    mkdir -p $FISH_CACHE_DIR
    echo '' >$CONFIG_CACHE

    # xcode
    type -q xcode-select && echo "fish_add_path $(xcode-select -p)/usr/bin" >>$CONFIG_CACHE
    type -q xcrun && echo "set -gx SDKROOT $(xcrun --sdk macosx --show-sdk-path)" >>$CONFIG_CACHE

    # ruby
    type -q brew && echo "fish_add_path $(brew --prefix)/opt/ruby/bin" >>$CONFIG_CACHE
    type -q gem && echo "fish_add_path $(gem environment gemdir)/bin" >>$CONFIG_CACHE

    # tools
    type -q direnv && direnv hook fish >>$CONFIG_CACHE
    type -q zoxide && zoxide init fish >>$CONFIG_CACHE
    # starship init fish >>$CONFIG_CACHE

    # set vivid colors
    type -q vivid && echo "set -gx LS_COLORS '$(vivid generate gruvbox-dark)'" >>$CONFIG_CACHE

    set_color brmagenta --bold --underline
    echo "config cache updated"
    set_color normal
end
source $CONFIG_CACHE

if status is-interactive
    stty stop undef &
    stty start undef &
end
