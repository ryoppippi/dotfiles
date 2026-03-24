if set -q WEZTERM_PANE; and not set -q TMUX
    set -gx TMUX "wezterm-shim/$WEZTERM_PANE/0"
end
