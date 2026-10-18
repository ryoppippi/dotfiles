function clean
    # brew
    type -q brew && brew cleanup -s
    # mise
    type -q mise && mise prune

    # nix
    type -q nix-collect-garbage && nix-collect-garbage

    init
    exit
end
