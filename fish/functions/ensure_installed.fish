function ensure_installed -d "ensure the command is on PATH"
    set -l cmd $argv[1]
    if type -q $cmd
        $cmd $argv[2..-1]
        return 0
    end

    echo "command $cmd not found"
    return 0
end
