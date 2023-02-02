function fbr -d "Fuzzy-find and checkout a branch"
    git branch --all | grep -v HEAD | string trim | fzf --inline-info | read -l result; and git checkout "$result"
end

function fcoc -d "Fuzzy-find and checkout a commit"
    git log --pretty=oneline --abbrev-commit --reverse | fzf --tac +s -e | awk '{print $1;}' | read -l result; and git checkout "$result"
end
