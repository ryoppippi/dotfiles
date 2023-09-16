function rm
    type -q trash && trash $argv && return
    type -q bun && bun x trash $argv && return
    type -q npx && npx trash-cli $argv && return
    type -q /bin/rm && /bin/rm $argv && return
end
