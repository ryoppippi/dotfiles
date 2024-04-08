function __ls_after_cd__on_variable_pwd --on-variable PWD
    if status --is-interactive
        ls -hlF
    end
end
