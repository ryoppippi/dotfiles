function bunx
    # type -q bun && bun x $argv
    if type -q bun
        bun x $argv
    else
        echo "bun not found"
    end
end
