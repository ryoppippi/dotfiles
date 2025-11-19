set -gx HOMEBREW_BUNDLE_FILE $HOME/.Brewfile
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_ARM /opt/homebrew
fish_add_path $HOMEBREW_ARM/bin
