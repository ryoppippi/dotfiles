function npkill
    # Check for existence of at least one node_modules directory
    set -l first (find . -type d -name node_modules -prune -print -quit)
    if test -z "$first"
        echo "No node_modules directories found. Exiting."
        return 0
    end

    # List all node_modules directories with their sizes
    find . -type d -name node_modules -prune -exec du -sh {} + | sort -rh

    echo -n "Do you want to delete all node_modules directories? (y/n) "
    read -l answer
    if test "$answer" = y
        # Use trash if available, otherwise fallback to rm
        if command -v trash >/dev/null 2>&1
            find . -type d -name node_modules -prune -exec trash {} +
        else
            find . -type d -name node_modules -prune -exec rm -rf {} +
        end
        echo "All node_modules directories have been deleted."
    else
        echo "Operation cancelled."
    end
end
