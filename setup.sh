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
  if ! xcode-select -p > /dev/null 2>&1 ; then
    xcode-select --install
  fi
  softwareupdate --install-rosetta --agree-to-license
  export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)

  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write -g AppleShowAllExtensions -bool true
  defaults write com.apple.CrashReporter DialogType -string "none"

  defaults write com.apdefaults write ple.dock persistent-apps -array
  defaults write com.apple.dock autohide -bool true
  defaults write com.apple.dock show-recents -bool false
  killall Dock

  defaults write com.apple.finder AppleShowAllFiles -bool true
  defaults write com.apple.finder ShowPathbar -bool true
  defaults write com.apple.finder ShowStatusBar -bool true
  defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
  defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"
  defaults write com.apple.finder "_FXSortFoldersFirst" -bool true
  defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float 0
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
