# git-wtpr shell hook for fish
# Chains onto the existing `git` wrapper (from git-wt --init fish).

if not functions -q __git_wtpr_inner
    if functions -q git
        functions -c git __git_wtpr_inner
    end
end

function git --wraps git
    if test "$argv[1]" = wtpr
        set -l nocd_flag false
        set -l nocd_mode (command git config --get wt.nocd 2>/dev/null)
        set -l existing_worktrees
        if test "$nocd_mode" = create
            set existing_worktrees (command git worktree list --porcelain 2>/dev/null | grep '^worktree ' | cut -d' ' -f2-)
        end
        for arg in $argv[2..]
            if string match -q -- --nocd "$arg"; or string match -q -- --no-switch-directory "$arg"
                set nocd_flag true
            end
        end
        set -lx GIT_WT_SHELL_INTEGRATION 1
        set -l result (command git-wtpr $argv[2..])
        set -l exit_code $status
        set -l last_line $result[-1]
        if test $exit_code -eq 0 -a -d "$last_line"
            for line in $result[1..-2]
                printf "%s\n" "$line"
            end
            set -l should_cd true
            if test "$nocd_flag" = true
                set should_cd false
            else if test "$nocd_mode" = true -o "$nocd_mode" = all
                set should_cd false
            else if test "$nocd_mode" = create
                if contains -- "$last_line" $existing_worktrees
                    set should_cd true
                else
                    set should_cd false
                end
            end
            if test "$should_cd" = true
                cd "$last_line"
            else
                printf "%s\n" "$last_line"
            end
        else
            for line in $result
                printf "%s\n" "$line"
            end
            return $exit_code
        end
    else if functions -q __git_wtpr_inner
        __git_wtpr_inner $argv
    else
        command git $argv
    end
end

function __fish_git_wtpr_needs_completion
    set -l cmd (commandline -opc)
    test (count $cmd) -ge 2 -a "$cmd[2]" = wtpr
end

function __fish_git_wtpr_completions
    # PR numbers from recent open PRs
    command gh pr list --limit 20 --json number,title -q '.[] | "\(.number)\t#\(.number) \(.title)"' 2>/dev/null
end

complete -x -c git -n __fish_git_wtpr_needs_completion -a '(__fish_git_wtpr_completions)'
complete -x -c git-wtpr -a '(__fish_git_wtpr_completions)'
