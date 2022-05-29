function git-sync
    # setup
    type --no-function --quiet git-sync
    if [ $status -ne 0 ]
        command mkdir -p $HOME/.local/bin
        echo -e "#!/bin/sh\nfish -c git-sync" > $HOME/.local/bin/git-sync
        command chmod +x $HOME/.local/bin/git-sync
    end

    # git-sync (fish version)
    #
    # cf. https://qiita.com/masarakki/items/27f2cb456b4801ccb31b
    command git fetch --all --prune

    set -l modifieds (command git status --porcelain --untracked-files=no | string length)

    if count $modifieds >/dev/null 2>&1
        command git stash
    end

    set -l current (command git branch | string match --entire --regex '^\* ' | string split ' ')[2]

    command git checkout master
    command git pull --rebase

    for b in (command git branch --no-color --merged | string match --entire --invert --regex '^\* ' | string trim)
        command git branch -d $b
    end

    for b in (command git branch --no-color -vv | string match --entire --regex '\[[A-Za-z0-9_\/\.\-]*: gone\]' | string trim)
        command git branch -D  (string split --max 1 ' ' $b)[1]
    end


    if command git checkout $current
        count $modifieds >/dev/null 2>&1; and command git stash pop
    else
        count $modifieds >/dev/null 2>&1; and command git stash drop
    end
end
