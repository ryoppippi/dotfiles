function dotfiles-pull --description "Pull latest changes from dotfiles repository"
    set -l dotfiles_dir (ghq root)/github.com/ryoppippi/dotfiles

    if not test -d $dotfiles_dir
        echo "Dotfiles directory not found: $dotfiles_dir" >&2
        return 1
    end

    git -C $dotfiles_dir pull --rebase
end
