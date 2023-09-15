## cd後にls 

# functions --copy cd standard_cd

function cd
    builtin cd $argv
    type -q lsd && lsd -hlF && return
    ls -hlF
end
