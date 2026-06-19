if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

if command -v direnv >/dev/null 2>&1; then
    if [ -n "${ZSH_VERSION:-}" ]; then
        eval "$(direnv export zsh)"
    else
        eval "$(direnv export bash)"
    fi
fi
