function cmux-copy-url
    command -q cmux; and set -q CMUX_WORKSPACE_ID; and set -q CMUX_SURFACE_ID
    or return 1

    set -l url (
        cmux read-screen --scrollback --lines 2000 |
        rg -o 'https?://[^[:space:]<>"()]+' |
        string replace -r '[,.;:!?]+$' '' |
        awk '!seen[$0]++' |
        fzf --tac --prompt='URL> '
    )

    if test -n "$url"
        printf %s "$url" | pbcopy
    end

    commandline -f repaint
end
