set -gx NOTIFY_ON_COMMAND_DURATION 5000
function fish_right_prompt
    if test $CMD_DURATION
        # Show notification if dration is more than 30 seconds
        if test $CMD_DURATION -gt $NOTIFY_ON_COMMAND_DURATION
            # Show duration of the last command in seconds
            set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')
            set -f MSG (echo (history | head -1) returned $status after $duration)
            type -q notify-send && notify-send $MSG && return
            type -q terminal-notifier && terminal-notifier -message $MSG -execute "$(which wezterm) cli activate-pane --pane-id $WEZTERM_PANE" -activate com.github.wez.wezterm \  && return
        end
    end
end
