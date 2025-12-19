function npkill
    # Check for existence of at least one node_modules directory
    set -l first (find . -type d -name node_modules -prune -print -quit)
    if test -z "$first"
        echo "No node_modules directories found. Exiting."
        return 0
    end

    # List all node_modules directories with their sizes
    find . -type d -name node_modules -prune -exec du -sh {} + | sort -rh

    echo -n "Do you want to move all node_modules directories to /tmp? (y/n) "
    read -l answer
    if test "$answer" = y
        set -l timestamp (date +%Y%m%d_%H%M%S)
        set -l counter 0
        find . -type d -name node_modules -prune | while read -l dir
            set counter (math $counter + 1)
            set -l dest "/tmp/node_modules_$timestamp"_"$counter"
            mv "$dir" "$dest"
            echo "Moved: $dir -> $dest"
        end
        echo "All node_modules directories have been moved to /tmp."
    else
        echo "Operation cancelled."
    end
end
