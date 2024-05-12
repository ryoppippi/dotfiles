export LC_ALL='en_US.UTF-8'
##export LANG=ja_JP.UTF-8
export BASH_SILENCE_DEPRECATION_WARNING=1


export EDITOR=nvim

export ARCH=$(uname -m)

# PATH
export XDG_CONFIG_HOME="$HOME/.config"
export CUSTOM_SCRIPTS_PATH="$HOME/scripts"
export AQUA_ROOT_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua"
export AQUA_BIN_PATH="${AQUA_ROOT_DIR}/bin"
export LOCALBIN="$HOME/.local/bin"
export GOPATH="$HOME/go"
export GOBIN=$GOPATH/bin
export POETRY_PATH="$HOME/.poetry/bin"
export NODEBREWBIN="$HOME/.nodebrew/current/bin"
export BUN_INSTALL="$HOME/.bun"
export BUNBIN="$HOME/.bun/bin"
# export CARGOBIN="$HOME/.cargo/bin"
export NIMBLEBIN="$HOME/.nimble/bin"
export GNUBIN="/usr/local/opt/coreutils/libexec/gnubin"
export XCODEBIN="/Applications/Xcode.app/Contents/Developer/usr/bin"
export HOMEBREW_X86_64_BIN="/usr/local/bin"
export HOMEBREW_ARM_BIN="/opt/homebrew/bin"
export CURLBIN="/usr/local/opt/curl/bin"
export BANBIN="$HOME/.bun/bin"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
export SCRIPTS_PATH="$HOME/.scripts"
export SCRIPTS_BIN_PATH="$HOME/.scripts/bin"
export ZIG_PATH="$HOME/zig"
export CODONBIN="$HOME/.codon/bin"

PATH=${HOMEBREW_ARM_BIN}:${HOMEBREW_X86_64_BIN}:${LOCALBIN}:/usr/bin:/bin:/opt/local/sbin:${PATH}
PATH=${SCRIPTS_PATH}:${AQUA_BIN_PATH}:${BUNBIN}:${ZIG_PATH}:${BUNBIN}:${NODEBREWBIN}:${CODONBIN}:${GOBIN}:${GOPATH}:${POETRY_PATH}:${CUSTOM_SCRIPTS_PATH}:${CURLBIN}:${CARGOBIN}:${NIMBLEBIN}:${GNUBIN}:${PATH}:${XCODEBIN}

# aqua
export AQUA_GLOBAL_CONFIG=${AQUA_GLOBAL_CONFIG:-}:${XDG_CONFIG_HOME:-$HOME/.config}/aquaproj-aqua/aqua.yaml

# langugaes
# c++
export CPPFLAGS=-I/opt/X11/include
export LDFLAGS="$LDFLAGS -L/usr/local/opt/zlib/lib -L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/binutils/lib -L/opt/homebrew/lib"
export CFLAGS="-I/usr/local/opt/zlib/include -I$(xcrun --show-sdk-path) $CFLAGS"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/zlib/include -I/usr/local/opt/readline/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include -I$(xcrun --show-sdk-path) -I/usr/local/opt/binutils/include -I/opt/homebrew/include"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/openblas/lib -L/usr/local/opt/lapack/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openblas/include -I/usr/local/opt/lapack/include"

# CCASHE
export USE_CCACHE=1
export CCACHE_DIR="$HOME/.ccache"

# python
export BETTER_EXCEPTIONS=1

# brew
export HOMEBREW_BUNDLE_FILE="$HOME/.Brewfile"
export HOMEBREW_NO_ANALYTICS=1

# zoxide
eval "$(zoxide init bash)"

# direnv
eval "$(direnv hook bash)"

# . "$HOME/.cargo/env"

# bat
export BAT_THEME="TwoDark"

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
if [ -f $WASMER_DIR/wasmer.sh ];then
  source $WASMER_DIR/wasmer.sh
fi

# ruby
if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  export PATH=/opt/homebrew/opt/ruby/bin:$PATH
  export PATH=`gem environment gemdir`/bin:$PATH
fi

# rye
source "$HOME/.rye/env"

# man pager
if command -v nvim &> /dev/null; then
    export MANPAGER="nvim -c ASMANPAGER -"
fi

# eval "$(github-copilot-cli alias -- "$0")"

# nix
if [ -e " /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh" ]; then 
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi
