function clean

    # aqua
    type -q aqua && aqua rm --all
    # brew
    type -q brew && brew cleanup -s
    # mise
    type -q mise && mise prune

    # nix
    type -q nix-collect-garbage && nix-collect-garbage

    set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish

    test -e $CONFIG_CACHE && rm -rf $CONFIG_CACHE

    init
    exit
end
