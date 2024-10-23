source ~/.bash_profile

fpath=(~/.zsh/completion $fpath)
autoload -Uz compinit && compinit -i
