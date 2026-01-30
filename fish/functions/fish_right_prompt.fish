# Show notification if dration is more than 30 seconds
set -gx NOTIFY_ON_COMMAND_DURATION 30000
# Programs to exclude from notifications (TUI tools only)
set -gx NOTIFY_EXCLUDE_PROGRAMS vim nvim lazygit claude codex yazi bottom ctop top viddy tmux jid jnv fx less man

function fish_right_prompt
    if test $CMD_DURATION
        if test $CMD_DURATION -gt $NOTIFY_ON_COMMAND_DURATION
            # Get the command name
            set -f cmd_name (history | head -1 | string split ' ' | head -1)

            # Check if the command should be excluded
            if contains $cmd_name $NOTIFY_EXCLUDE_PROGRAMS
                return
            end

            # Show duration of the last command in seconds
            set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
            set -f MSG (echo (history | head -1) returned $status after $duration)
            type -q notify-send && notify-send $MSG && return
            type -q terminal-notifier && terminal-notifier -message $MSG -execute "$(which wezterm) cli activate-pane --pane-id $WEZTERM_PANE" -activate com.github.wez.wezterm \  && return
        end
    end
end
