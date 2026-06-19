if command -v direnv >/dev/null 2>&1 && [ -f .envrc ]; then
    eval "$(direnv export zsh)"
fi
