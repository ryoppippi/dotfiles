# function fish_user_key_bindings
#   fzf_key_bindings
# end
function end-of-line-or-execute
    set -l line (commandline -L)
    set -l cmd (commandline)
    set -l cursor (commandline -C)
    if test (string length -- $cmd[$line]) = $cursor
        # commandline -f execute
        commandline -f accept-autosuggestion
    else
        commandline -f end-of-line
    end
end

function fish_user_key_bindings
    bind \cx\ck fkill
    bind \cb git_switch_branch
    bind \cg __ghq_roots
    if bind -M insert >/dev/null 2>&1
        bind -M insert \cg __ghq_roots
    end

    ### fzf ###
    fzf_key_bindings
    set -q FZF_LEGACY_KEYBINDINGS
    or set -l FZF_LEGACY_KEYBINDINGS 1
    if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
        bind \ct __fzf_find_file
        bind \cr __fzf_reverse_isearch
        bind \ec __fzf_cd
        if bind -M insert >/dev/null 2>&1
            bind -M insert \ct __fzf_find_file
            bind -M insert \cr __fzf_reverse_isearch
            bind -M insert \ec __fzf_cd
        end
    else
        bind \cf __fzf_find_file
        bind \cr __fzf_reverse_isearch
        bind \ed __fzf_cd
        if bind -M insert >/dev/null 2>&1
            bind -M insert \cf __fzf_find_file
            bind -M insert \cr __fzf_reverse_isearch
            bind -M insert \ed __fzf_cd
        end
    end
    ### fzf ###
end
