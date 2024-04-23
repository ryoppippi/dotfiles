function init -d init
    type -q deno && deno --version >>/dev/null
    type -q bun && bun --version >>/dev/null
end
