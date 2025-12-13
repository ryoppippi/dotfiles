function is_vim_shell
    if set -q NVIM
        or set -q VIM_TERMINAL
        return 0
    end
    return 1
end
