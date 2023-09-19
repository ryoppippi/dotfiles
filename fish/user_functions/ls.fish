function ls
    type -q lsd && lsd $argv && return
    type -q eza && eza $argv && return
    ls $argv
end
