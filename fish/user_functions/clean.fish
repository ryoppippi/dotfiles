function clean
    # aqua
    set -l AQUA_CONFIG "$XDG_CONFIG_HOME/aquaproj-aqua"

    rm -rf $AQUA_ROOT_DIR

    cd /tmp
    curl -sSfL -O https://raw.githubusercontent.com/aquaproj/aqua-installer/v2.1.1/aqua-installer
    echo "c2af02bdd15da6794f9c98db40332c804224930212f553a805425441f8331665  aqua-installer" | sha256sum -c
    chmod +x aqua-installer
    ./aqua-installer
    cd $AQUA_CONFIG
    aqua install -l

    # install volta deps
    volta --help >/dev/null 2>&1

    # brew
    type -q brew && brew cleanup -s

    set -l CONFIG_CACHE $FISH_CACHE_DIR/config.fish
    test -e $CONFIG_CACHE && rm $CONFIG_CACHE
    source $FISH_CONFIG
end
