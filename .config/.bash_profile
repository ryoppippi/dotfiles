export LC_ALL='en_US.UTF-8'
##export LANG=ja_JP.UTF-8
export BASH_SILENCE_DEPRECATION_WARNING=1
export EDITOR=nvim

# PATH
export XDG_CONFIG_HOME=~/.config
export CUSTOM_SCRIPTS_PATH="$HOME/scripts"
export LOCALBIN="$HOME/.local/bin"
export VOLTA_HOME="$HOME/.volta"
export VOLTA_BIN="$VOLTA_HOME/bin"
export GOPATH="$HOME/go"
export GOBIN=$GOPATH/bin
export POETRY_PATH="$HOME/.poetry/bin"
export NODEBREWBIN="$HOME/.nodebrew/current/bin"
export DENOBIN="$HOME/.deno/bin"
export CARGOBIN="$HOME/.cargo/bin"
export NIMBLEBIN="$HOME/.nimble/bin"
export GNUBIN="/usr/local/opt/coreutils/libexec/gnubin"
export XCODEBIN="/Applications/Xcode.app/Contents/Developer/usr/bin"
export HOMEBREW_X86_64_BIN="/usr/local/bin"
export HOMEBREW_ARM_BIN="/opt/homebrew/bin"
export CURLBIN="/usr/local/opt/curl/bin"
export PKG_CONFIG_PATH="/usr/local/opt/sqlite/lib/pkgconfig"
#export CC="/usr/local/bin/gcc"
#export CXX="/usr/local/bin/g++"

PATH=${HOMEBREW_ARM_BIN}:${HOMEBREW_X86_64_BIN}:${LOCALBIN}:/usr/bin:/bin:/opt/local/sbin:${PATH}
PATH=${VOLTA_BIN}:${NODEBREWBIN}:${GOBIN}:${POETRY_PATH}:${CUSTOM_SCRIPTS_PATH}:${CURLBIN}:${DENOBIN}:${CARGOBIN}:${NIMBLEBIN}:${GNUBIN}:${XCODEBIN}:${PATH}

# langugaes
# c++
alias clang-omp='/usr/local/opt/llvm/bin/clang -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'
alias clang-omp++='/usr/local/opt/llvm/bin/clang++ -fopenmp -L/usr/local/opt/llvm/lib -Wl,-rpath,/usr/local/opt/llvm/lib'
export OMP_NUM_THREADS='4'

export CPPFLAGS=-I/opt/X11/include
export LDFLAGS="$LDFLAGS -L/usr/local/opt/zlib/lib -L/usr/local/opt/readline/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib -L/usr/local/opt/binutils/lib"
export CFLAGS="-I/usr/local/opt/zlib/include -I$(xcrun --show-sdk-path) $CFLAGS"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/zlib/include -I/usr/local/opt/readline/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include -I$(xcrun --show-sdk-path) -I/usr/local/opt/binutils/include"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/openblas/lib -L/usr/local/opt/lapack/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/openblas/include -I/usr/local/opt/lapack/include"
# CCASHE
export USE_CCACHE=1
export CCACHE_DIR="$HOME/.ccache"

# Go
export CGO_ENABLED=0

# node
alias npm="env CXX=/usr/bin/g++ npm"

# python
export PIP_REQUIRE_VIRTUALENV=true
export BETTER_EXCEPTIONS=1



# pyenv
alias pyenv="env CC=/usr/bin/gcc CXX=/usr/bin/g++  PYTHON_CONFIGURE_OPTS='--enable-framework --enable-toolbox-glue --enable-big-digits --enable-unicode --with-threads' pyenv"
export PYENV_ROOT="$HOME/.pyenv/shims"


# pipenv
#eval "$(pipenv --completion)"
export PIPENV_VENV_IN_PROJECT=true

# iterm
# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

# brew
export BREW_PREFIX=$(brew --prefix)
export HOMEBREW_BREWFILE="$HOME/.mackup/.brewfile"

if [ -f $BREW_PREFIX/etc/brew-wrap ];then
  source $BREW_PREFIX/etc/brew-wrap
fi

# hub
eval "$(hub alias -s)"

# direnv
eval "$(direnv hook bash)"
. "$HOME/.cargo/env"

source ~/.bash_secret

if [[ -t 0 ]]; then
  stty stop undef
  stty start undef
fi

# Added by Krypton
export GPG_TTY=$(tty)
export EDITOR=vim
export PATH=${PATH}
export TO_FISH_PATH=$PATH

# alias
# cdls ()
# {
#    \cd "$@" && ls
# }
# alias cd="cdls"
alias cat="ccat"
alias ls="exa -hlF"
alias rm="rm -i"

case $- in
    *i*) exec fish;;
      *) return;;
esac

