function init -d init
    type -q gh && gh auth setup-git
    type -q deno && deno --version >>/dev/null
    type -q bun && bun --version >>/dev/null
    type -q volta && volta install node @antfu/ni
end
