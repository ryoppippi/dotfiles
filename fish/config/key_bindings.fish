function fish_hybrid_key_bindings --description \
    "Vi-style bindings that inherit emacs-style bindings in all modes & not enabled in vim/neovim terminal"
    for mode in default insert visual
        fish_default_key_bindings -M $mode
    end
    if is_vim_shell
        fish_default_key_bindings
    else
        fish_vi_key_bindings --no-erase
    end
end

#set -g fish_key_bindings fish_hybrid_key_bindings
