set -gx LC_ALL "en_US.UTF-8"
set -gx BASH_SILENCE_DEPRECATION_WARNING 1

# define XDG paths
set -q XDG_CONFIG_HOME || set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_DATA_HOME || set -gx XDG_DATA_HOME $HOME/.local/share
set -q XDG_CACHE_HOME || set -gx XDG_CACHE_HOME $HOME/.cache

if test "$TERM" = '$TERM'
    if set -q CMUX_BUNDLE_ID
        set -gx TERM xterm-256color
    else
        set -gx TERM xterm-ghostty
    end
end

# Source home-manager session variables
set -l HM_SESSION_VARS "$HOME/.local/state/home-manager/gcroots/current-home/home-path/etc/profile.d/hm-session-vars.sh"
if not test -f $HM_SESSION_VARS
    set HM_SESSION_VARS "/etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh"
end
if test -f $HM_SESSION_VARS
    set -l hm_session_keys
    for line in (string match -r '^export [A-Za-z_][A-Za-z0-9_]*=' <$HM_SESSION_VARS)
        set -l assignment (string replace -r '^export ' '' -- $line)
        set -a hm_session_keys (string split -m1 '=' -- $assignment)[1]
    end

    if test (count $hm_session_keys) -gt 0
        for line in (env -u __HM_SESS_VARS_SOURCED bash --noprofile --norc -c 'source "$1" >/dev/null; env' bash $HM_SESSION_VARS)
            set -l key (string split -m1 '=' -- $line)[1]
            if contains -- $key $hm_session_keys
                set -l value (string split -m1 '=' -- $line)[2]
                set -gx $key $value
            end
        end
    end
end

# define fish config paths
set -g FISH_CONFIG_DIR $XDG_CONFIG_HOME/fish
set -g FISH_CONFIG $FISH_CONFIG_DIR/config.fish

# load user config (functions/ is auto-loaded by Fish)
for file in $FISH_CONFIG_DIR/config/*.fish
    source $file &
end

# theme
set -gx theme_nerd_fonts yes
set -gx BIT_THEME monochrome
source $FISH_CONFIG_DIR/themes/kanagawa.fish

# general bin paths
fish_add_path $HOME/.local/bin

# c / c++
# c++
# export CPPFLAGS=-I/opt/X11/include
set -gx USE_CCACHE 1
set -gx CCACHE_DIR $HOME/.ccache

# brew
fish_add_path /opt/homebrew/bin

# js/ts
## bun
fish_add_path $HOME/.bun/bin
fish_add_path $HOME/.cache/.bun/bin

# go
set -gx GOPATH $HOME/go
fish_add_path $GOPATH/bin

# nim
fish_add_path $HOME/.nimble/bin

# zig
fish_add_path $HOME/zig

# python
fish_add_path $HOME/.poetry/bin
# set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx PYENV_ROOT $HOME/.pyenv
set -gx BETTER_EXCEPTIONS 1
## codon
fish_add_path $HOME/.codon/bin

# user scripts
fish_add_path $HOME/.scripts
fish_add_path $HOME/.scripts/bin

# Add home-manager packages to PATH
# Prefer the standalone home-manager gcroots (Linux / `home-manager switch`),
# falling back to the nix-darwin module profile (`/etc/profiles/per-user`).
set -l HM_PATH_BIN "$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin"
if not test -d $HM_PATH_BIN
    set HM_PATH_BIN "/etc/profiles/per-user/$USER/bin"
end
fish_add_path $HM_PATH_BIN

# xcode
# Append (and keep) Xcode's bin at the end of fish_user_paths so its
# bundled tools (git, etc.) never shadow the Nix/home-manager ones
if command -q xcode-select
    set -l xcode_dir (xcode-select -p)
    fish_add_path --append --move $xcode_dir/usr/bin
    set -gx SDKROOT $xcode_dir/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk
end

if not status is-interactive; and command -q direnv
    direnv export fish | source
end

# neovim
set -gx EDITOR nvim
set -gx GIT_EDITOR nvim
set -gx VISUAL nvim
set -gx MANPAGER "nvim +Man!"

if status is-interactive
    stty stop undef &
    stty start undef &
end

set -g NA_PACKAGE_MANAGER_LIST bun pnpm npm yarn
set -g NA_FUZZYFINDER_OPTIONS --bind 'one:accept' --query '^'
