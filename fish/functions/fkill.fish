function fkill
    ps ax -o pid,time,command | fzf --query "$LBUFFER" | awk '{print $1}' | xargs kill
end
