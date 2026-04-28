function npkill
    set -l dirs (fd --hidden --no-ignore --prune --type d '^node_modules$' . 2>/dev/null)

    if test (count $dirs) -eq 0
        echo "No node_modules directories found. Exiting."
        return 0
    end

    printf '%s\n' $dirs | xargs -P (getconf _NPROCESSORS_ONLN) -I{} du -sh {} | sort -rh

    echo -n "Do you want to move all node_modules directories to /tmp? (y/n) "
    read -l answer
    if test "$answer" != y
        echo "Operation cancelled."
        return 0
    end

    set -l timestamp (date +%Y%m%d_%H%M%S)
    set -l counter 0
    for dir in $dirs
        set counter (math $counter + 1)
        set -l dest "/tmp/node_modules_$timestamp"_"$counter"
        mv "$dir" "$dest"
        echo "Moved: $dir -> $dest"
    end
    echo "All node_modules directories have been moved to /tmp."
end
