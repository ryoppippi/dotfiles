function ss
    set -l prev_cmd (history | head -n 1)
    set_color green
    echo "sudo $prev_cmd"
    set_color normal
    sudo $prev_cmd
end
