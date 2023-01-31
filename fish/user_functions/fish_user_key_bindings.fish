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
    fzf_key_bindings
    for mode in insert default visual
        fish_default_key_bindings -M $mode
    end
    fish_vi_key_bindings --no-erase
    bind \cx\ck fkill

    bind -M insert -e \ce
    bind -M visual -e \ce
    bind -M default -e \ce
    bind -M insert \ce end-of-line-or-execute
    bind -M insert -e \cf
    ### fzf ###
    set -q FZF_LEGACY_KEYBINDINGS
    or set -l FZF_LEGACY_KEYBINDINGS 1
    if test "$FZF_LEGACY_KEYBINDINGS" -eq 1
        bind \ct __fzf_find_file
        bind \cr __fzf_reverse_isearch
        bind \cx __fzf_find_and_execute
        bind \ec __fzf_cd
        bind \eC __fzf_cd_with_hidden
        if bind -M insert >/dev/null ^/dev/null
            bind -M insert \ct __fzf_find_file
            bind -M insert \cr __fzf_reverse_isearch
            bind -M insert \cx __fzf_find_and_execute
            bind -M insert \ec __fzf_cd
            bind -M insert \eC __fzf_cd_with_hidden
        end
    else
        bind \cf __fzf_find_file
        bind \cr __fzf_reverse_isearch
        bind \ex __fzf_find_and_execute
        bind \ed __fzf_cd
        bind \eD __fzf_cd_with_hidden
        if bind -M insert >/dev/null ^/dev/null
            bind -M insert \cf __fzf_find_file
            bind -M insert \cr __fzf_reverse_isearch
            bind -M insert \ex __fzf_find_and_execute
            bind -M insert \ed __fzf_cd
            bind -M insert \eD __fzf_cd_with_hidden
        end
    end
    ### fzf ###

    ### autopair ###
    set -e autopair_path "$CONFIG/fish/conf.d/autopair.fish"
    if test -f $autopair_path
        source $autopair_path
    end
    ### autopair ###
end
