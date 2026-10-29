# omniwm-span — halve or double the focused OmniWM column width
#
# Usage:
#   omniwm-span <halve|double>

# Narrowest column the halving stops at, matching the companion apps' minWidth.
const min_width = 320

def --wrapped omniwmctl-query [...args: string] {
    ^omniwmctl query ...$args --format json | from json | get result.payload
}

def main [direction: string] {
    let window = omniwmctl-query focused-window | get window?
    if $window == null { return }
    let display = (omniwmctl-query
        displays
        --display
        $window.display.id
        --fields
        visible-frame,inner-gap,outer-gap-left,outer-gap-right
    )
    | get displays.0
    let gap = $display.innerGap
    let usable = $display.visibleFrame.width - $display.outerGapLeft - $display.outerGapRight

    # OmniWM lays a column out as `span * (usable - gap) - gap`, measured on a
    # 6144pt display at 12.5%, 20%, 25% and 100%; invert it to recover the span.
    let to_span = {|width| ($width + $gap) / ($usable - $gap) }
    let span = do $to_span $window.frame.width

    let target = match $direction {
        "halve" => ([
            ($span / 2)
            (do $to_span $min_width)
        ] | math max)
        "double" => ([
            ($span * 2)
            1.0
        ] | math min)
        _ => { error make {msg: $"unknown direction '($direction)', expected halve or double"} }
    }

    ^omniwmctl command set-container-primary-span $"($target * 100 | math round --precision 2)%" | ignore
}
