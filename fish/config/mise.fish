if status --is-interactive
    mise activate fish | source
else
    eval "$(mise activate --shims)"
end
