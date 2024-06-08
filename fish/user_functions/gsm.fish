function gsm -d "git switch to main branch. if main branch does not exist, switch to master branch"
    if [ -d .git ] then
        git switch main 2>/dev/null || git switch master
    else
        echo "Not a git repository"
    end
end
