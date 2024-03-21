#!/bin/bash

set -euo pipefail

GHQ_VERSION=1.4.2
DOTFILES_VERSION=v0.2.2

XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
XDG_DATA_HOME=$HOME/.local/share

# XDG Base Directory
mkdir -p $HOME/.config
mkdir -p $HOME/.cache
mkdir -p $HOME/.local/share

if [ "$(uname)" == "Darwin" ] ; then
  xcode-select --install
  defaults write com.apple.dock persistent-apps -array
  killall Dock
  defaults write com.apple.desktopservices DSDontWriteNetworkStores True
  killall Finder
fi

if [ "$(uname)" == "Linux" ] ; then
  apt-get update
  apt-get install -y curl
  apt-get clean
  rm -rf /var/lib/apt/lists/*
fi

# get ghp
curl -sSfL "https://github.com/x-motemen/ghq/releases/download/${GHQ_VERSION}/ghq_$(uname)_$(uname -a).zip" \
  | bsdtar -xvf- -C /tmp ghq 

# get dotfiles 
curl -sSfL https://github.com/rhysd/dotfiles/releases/download/${DOTFILES_VERSION}/dotfiles_$(uname)_$(uname -a).zip \
  | bsdtar -xvf- -C /tmp dotfiles

/tmp/ghq get ryoppippi/dotfiles

DOTFILES_DIR=$(ghq root)/$(ghq list | grep ryoppippi/dotfiles)

cd $DOTFILES_DIR \
  && /tmp/dotfiles link .

AQUA_VERSION=2.0.2



# aqua
curl -sSfL "https://raw.githubusercontent.com/aquaproj/aqua-installer/${AQUA_VERSION}/aqua-installer" | bash

# install deps via aqua
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"

cd $DOTFILES_DIR/aqua \
  && aqua install -l -a \
  && dotfiles link .

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
source $DOTFILES_DIR/bash/.bash_profile

brew install fish curl

# install deps via brew
export HOMEBREW_BREWFILE="$HOME/.brewfile"
brew bundle --global
brew reinstall fish

# fish shell
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher update"
fish -c "fish_update_completions"

# node
volta install node@18

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# post install
brew cleanup -s
