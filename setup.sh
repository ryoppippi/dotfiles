#!/bin/bash

set -euo pipefail

GHQ_VERSION=1.4.2
DOTFILES_VERSION=v0.2.2

XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
XDG_DATA_HOME=$HOME/.local/share

AQUA_VERSION=v3.1.2

os=$(uname -s | tr '[:upper:]' '[:lower:]')
arch=$(uname -m)

# XDG Base Directory
mkdir -p $XDG_CONFIG_HOME
mkdir -p $XDG_CACHE_HOME
mkdir -p $XDG_DATA_HOME

if [ os == "darwin" ] ; then
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
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  killall Finder
fi

if [ os == "linux" ] ; then
  apt-get update
  apt-get install -y curl
  apt-get clean
  rm -rf /var/lib/apt/lists/*
fi

# aqua
curl -sSfL "https://raw.githubusercontent.com/aquaproj/aqua-installer/${AQUA_VERSION}/aqua-installer" | bash

# install deps via aqua
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"

cd /tmp && \
  aqua init && \
  aqua g -i rhysd/dotfiles && \
  aqua g -i x-motemen/ghq && \
  aqua i -l && \
  ghq get ryoppippi/dotfiles && \
  DOTFILES_DIR=$(ghq root)/$(ghq list | grep ryoppippi/dotfiles) && \
  AQUA_GLOBAL_CONFIG_DIR=$DOTFILES_DIR/aqua && \
  AQUA_GLOBAL_CONFIG=$AQUA_GLOBAL_CONFIG_DIR/aqua.toml && \
  cd "$AQUA_GLOBAL_CONFIG_DIR" && \
  aqua install -l -a && \
  cd "$DOTFILES_DIR" && \
  dotfiles link .

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
source $DOTFILES_DIR/bash/.bash_profile

brew install fish curl

# install deps via brew
export HOMEBREW_BREWFILE="$HOME/.Brewfile"
brew bundle --file="$HOMEBREW_BREWFILE"
brew reinstall fish

# fish shell
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher update"
fish -c "fish_update_completions"

# default shell to fish
if ! grep -q "$(which fish)" /etc/shells; then
  echo "$(which fish)" | sudo tee -a /etc/shells
fi
chsh -s "$(which fish)"

# node
bun --help
deno --help

# post install
brew cleanup -s

# install nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

