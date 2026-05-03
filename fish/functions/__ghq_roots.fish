function __ghq_roots --description "Navigate to project roots within ghq-managed repositories"
    set -l selected (ghq list --full-path | roots | fzf --height 40% --reverse --preview 'eza --tree --level=2 --git-ignore --color=always --icons {} 2>/dev/null; or ls {}')
    if test -n "$selected"
        cd -- "$selected"
        commandline -f repaint
    end
end
