set -x FZF_DEFAULT_COMMAND 'rg --files --hidden --follow --no-messages --glob "!/^[^\/]+\/.git/\/?(?:[^\/]+\/?)*" '
set -x FZF_FIND_FILE_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_DEFAULT_OPTS '--extended --cycle --select-1 --height 40% --reverse --border'
set -x FZF_FIND_FILE_OPTS '--preview "bat --color=always --style=header,grid --line-range :100 {}"'
set -x FZF_CTRL_R_OPTS "--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_COMPLETION_TRIGGER '**'
