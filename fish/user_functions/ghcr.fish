function ghcr
    gh repo create $argv
    ghq get $argv[1]
    cd (ghq list --full-path -e $argv[1])
    # $EDITOR (ghq list --full-path -e $argv[1])
end
