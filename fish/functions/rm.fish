if test (uname) = Darwin
    alias rm /usr/bin/trash
    return
end

type -q trash && alias rm trash && return
type -q bun && alias rm 'bun x trash ' && return
