function github-copilot_helper
    set -l TMPFILE (mktemp)
    trap 'rm -f $TMPFILE' EXIT
    if github-copilot-cli $argv[1] "$argv[2..]" --shellout $TMPFILE
        if [ -e "$TMPFILE" ]
            set -l FIXED_CMD (cat $TMPFILE)
            eval "$FIXED_CMD"
        else
            echo "Apologies! Extracting command failed"
        end
    else
        return 1
    end
end

function qw
    set -l prev_cmd (history | head -n 1)
    set_color yellow
    echo $prev_cmd
    set_color normal
    github-copilot_helper what-the-shell "correct the following commands {$prev_cmd}"
end


alias q 'github-copilot_helper what-the-shell'
alias qgit 'github-copilot_helper git-assist'
alias qgh 'github-copilot_helper gh-assist'
