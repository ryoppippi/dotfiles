# Force update hydro git info when PWD changes
function hydro_update_git_on_pwd_change --on-variable PWD
    # Clear the cached git info for this shell
    set --query _hydro_git || return
    set --universal $_hydro_git ""

    # Trigger immediate prompt update
    commandline --function repaint
end
