function tree
    type -q tre && tre $argv && return
    type -q tree && tree $argv && return
    echo "tree or tre is not installed"
end
