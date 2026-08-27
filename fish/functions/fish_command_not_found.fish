function fish_command_not_found
    # Only reach for comma in an interactive session. A script or an agent that
    # hits a typo must fail fast instead of fetching and running an arbitrary
    # nixpkgs derivation, and --ask keeps a mistyped command from downloading
    # a package on its own.
    if status is-interactive; and type -q ,
        , --ask $argv
        return $status
    end

    __fish_default_command_not_found_handler $argv
end
