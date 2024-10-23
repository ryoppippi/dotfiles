function update
    type -q brew && brew update && brew cleanup -s
    type -q rustup && rustup update
end
