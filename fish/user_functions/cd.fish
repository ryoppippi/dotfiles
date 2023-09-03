## cd後にls 

# functions --copy cd standard_cd

function cd
    builtin cd $argv; and lsd -hlF
end
