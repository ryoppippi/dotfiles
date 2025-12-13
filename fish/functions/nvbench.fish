function nvbench
    not type -q hyperfine && echo "hyperfine not found" && return 1
    hyperfine "nvim --headless +qa" --warmup 4 --prepare "nvim --headless +qa"
end
