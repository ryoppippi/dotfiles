function __ghq_roots --description "Navigate to project roots within ghq-managed repositories"
    set -l selected (ghq list --full-path | roots | fzf --height 40% --reverse)
    if test -n "$selected"
        cd "$selected"
        commandline -f repaint
    end
end
