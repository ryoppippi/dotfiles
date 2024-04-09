set -gx HOMEBREW_BUNDLE_FILE $HOME/.Brewfile
set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_ARM /opt/homebrew
set -gx HOMEBREW_X86_64 /usr/local
fish_add_path $HOMEBREW_ARM/bin
fish_add_path $HOMEBREW_X86_64/bin
