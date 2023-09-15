function rm
    type -q trash && trash $argv && return
    type -q /bin/rm && /bin/rm $argv && return
end
