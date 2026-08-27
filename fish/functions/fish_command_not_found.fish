function fish_command_not_found
    # fish runs this handler in scripts too, so a typo in a script or in a
    # coding agent's shell would otherwise resolve to an arbitrary derivation
    # and run it. Keep the plain error outside an interactive session.
    if not status is-interactive; or not type -q ,
        __fish_default_command_not_found_handler $argv
        return
    end

    set -l cmd $argv[1]
    set -l cache (__comma_cache_file $cmd)

    # A store path comma resolved before is already realised, so running it
    # again needs neither the network nor another confirmation. The path stays
    # valid across a nixpkgs bump — it is pinned to the store, not to a
    # version — and only breaks once the GC collects it, which sends the next
    # lookup back through comma and picks up whatever nixpkgs holds by then.
    if test -n "$cache"; and test -f $cache
        set -l cached (cat $cache)
        if test -n "$cached"; and test -x $cached
            $cached $argv[2..]
            return $status
        end
    end

    # comma realises the derivation before it offers to run it, so the fetch
    # has already happened by the time anything is printed. Confirm here
    # instead of with `, --ask`, because the answer decides whether the path is
    # worth remembering.
    set -l resolved (, --print-path $cmd 2>/dev/null)
    if test -z "$resolved"
        __fish_default_command_not_found_handler $argv
        return 127
    end

    read -l -P "Run $resolved? [y/N] " reply
    if not string match -qr '^(y|yes)$' -- (string lower -- $reply)
        return 130
    end

    if test -n "$cache"
        mkdir -p (path dirname $cache)
        echo $resolved >$cache
    end

    $resolved $argv[2..]
    return $status
end

# Only names that are safe as a filename get a cache entry; anything else runs
# through comma every time rather than being written to an unexpected path.
function __comma_cache_file --argument-names cmd
    if not string match -qr '^[A-Za-z0-9._+-]+$' -- $cmd
        return
    end

    set -l base $XDG_CACHE_HOME
    test -n "$base"; or set base $HOME/.cache
    echo $base/fish/comma/$cmd
end
