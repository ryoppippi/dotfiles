function __ls_after_cd__on_variable_pwd --on-variable PWD
    if status --is-interactive
        ls -hlF $PWD
    end

    # if .git directory exists, run git status
    if test -d $PWD/.git
        git-sign-config
    end
end
