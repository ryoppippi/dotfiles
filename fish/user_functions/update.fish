function update
    type -q brew && brew update && brew cleanup -s
    type -q gup && gup update
    type -q rustup && rustup update
end
