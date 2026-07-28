# open — shim in front of /usr/bin/open.
#
# Covers the one case $BROWSER cannot: CLIs that exec `open` directly and ignore
# $BROWSER (everything built on the npm `open` package or the Rust `opener`
# crate — `vite --open`, `wrangler`, `vercel`, ...).
#
# `open` is a general-purpose command, not a URL opener, so only take over when
# every argument is a bare http(s) URL. Anything carrying a flag or a path
# (`open .`, `open -a Xcode foo.swift`, `open file.pdf`) goes to the real binary
# untouched, which leaves Velja in charge of system-wide routing.
def --wrapped main [...args] {
    if ($args | is-empty) {
        exec /usr/bin/open
    }

    if ($args | all {|arg| $arg =~ '^https?://' }) {
        exec browser-open ...$args
    } else {
        exec /usr/bin/open ...$args
    }
}
