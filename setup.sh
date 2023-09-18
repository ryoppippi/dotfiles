#!/bin/bash

set -euo pipefail

DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# XDG Base Directory
mkdir -p $HOME/.config
mkdir -p $HOME/.cache
mkdir -p $HOME/.local/share

XDG_CONFIG_HOME=$HOME/.config
XDG_CACHE_HOME=$HOME/.cache
XDG_DATA_HOME=$HOME/.local/share

# aqua
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.0.2/aqua-installer | bash

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
source $DIR/bash/.bash_profile

brew install fish curl

# install deps via brew
export HOMEBREW_BREWFILE="$HOME/.brewfile"
brew bundle --global
brew reinstall fish

# aqua
curl -sSfL https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.0.2/aqua-installer | bash


# fish shell
fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
fish -c "fisher update"
fish -c "fish_update_completions"

# install deps via aqua
export PATH="${AQUA_ROOT_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/aquaproj-aqua}/bin:$PATH"
cd $DIR/aqua && aqua install -l -a

cd $DIR

# node
volta install node@18

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# rye
curl -sSf https://rye-up.com/get | bash

# post install
brew cleanup -s

