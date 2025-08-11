function git_switch_branch --description "Switch git branch using fzf"
    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "Not in a git repository"
        return 1
    end

    set -l branch (git branch -a --format='%(refname:short)' | \
        sed 's|^origin/||' | \
        sort -u | \
        fzf --height=40% --reverse --prompt="Switch to branch: ")
    
    if test -n "$branch"
        git switch $branch
        commandline -f repaint
    end
end