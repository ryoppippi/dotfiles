function zig
    type -q '/usr/bin/env zig' && /usr/bin/env zig $argv && return
    type -q bun && bun x @oven/zig $argv && return
end
