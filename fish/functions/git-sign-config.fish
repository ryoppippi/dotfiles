function git-sign-config
    if test -z $GIT_SSH_KEY
        echo "GIT_SSH_KEY not found"
        return
    end
    git config user.signingKey $GIT_SSH_KEY
end
