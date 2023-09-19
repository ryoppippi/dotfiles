function update
    type -q brew && brew update && brew cleanup -s
    type -q rye && rye self update
end
