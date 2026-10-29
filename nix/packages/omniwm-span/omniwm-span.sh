#!/bin/sh
# omniwm-span — halve or double the focused OmniWM column width
#
# Usage:
#   omniwm-span <halve|double>
#
# Karabiner runs this on every Hyper+Y/O press, so it only uses binaries macOS
# keeps warm: a cold start of a larger interpreter delayed the resize by about
# a second after the machine had been idle.
set -eu

omniwmctl=@omniwmctl@
# Narrowest column the halving stops at, matching the companion apps' minWidth.
min_width=320

case ${1-} in
halve | double) direction=$1 ;;
*)
  echo 'usage: omniwm-span <halve|double>' >&2
  exit 2
  ;;
esac

# plutil parses JSON as well as property lists.
extract() {
  printf '%s' "$1" | /usr/bin/plutil -extract "$2" raw -o - -
}

window=$("$omniwmctl" query focused-window --format json)
# Nothing is focused, so there is no column to resize.
width=$(extract "$window" result.payload.window.frame.width 2>/dev/null) || exit 0
display_id=$(extract "$window" result.payload.window.display.id)

display=$("$omniwmctl" query displays --display "$display_id" \
  --fields visible-frame,inner-gap,outer-gap-left,outer-gap-right --format json)
visible=$(extract "$display" result.payload.displays.0.visibleFrame.width)
gap=$(extract "$display" result.payload.displays.0.innerGap)
outer_left=$(extract "$display" result.payload.displays.0.outerGapLeft)
outer_right=$(extract "$display" result.payload.displays.0.outerGapRight)

target=$(/usr/bin/awk \
  -v direction="$direction" -v width="$width" -v min_width="$min_width" \
  -v visible="$visible" -v gap="$gap" -v outer_left="$outer_left" -v outer_right="$outer_right" '
	BEGIN {
		usable = visible - outer_left - outer_right
		# OmniWM lays a column out as `span * (usable - gap) - gap`, measured on
		# a 6144pt display at 12.5%, 20%, 25% and 100%; invert it to get the span.
		span = (width + gap) / (usable - gap)
		if (direction == "halve") {
			span /= 2
			floor = (min_width + gap) / (usable - gap)
			if (span < floor) span = floor
		} else {
			span *= 2
			if (span > 1) span = 1
		}
		printf "%.2f%%", span * 100
	}')

"$omniwmctl" command set-container-primary-span "$target" >/dev/null
