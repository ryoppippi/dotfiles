if type -q nvim or (type -q mise and test $(mise where -q neovim) != "")
    set -gx EDITOR nvim
    set -gx GIT_EDITOR nvim
    set -gx VISUAL nvim
    set -gx MANPAGER "nvim -c ASMANPAGER -"
end
