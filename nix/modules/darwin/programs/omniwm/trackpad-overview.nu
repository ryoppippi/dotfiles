def empty-gesture []: nothing -> record {
    {active: false, origin: 0, fired: false}
}

def vertical-position [sample: record]: nothing -> int {
    ($sample.multitouch_extension_finger_count_upper_half_area
    - $sample.multitouch_extension_finger_count_lower_half_area)
}

def step [gesture: record, sample: record, app_expose_open: bool]: nothing -> record {
    let total = $sample.multitouch_extension_finger_count_total

    if $total == 0 {
        return {
            gesture: (empty-gesture)
            action: null
        }
    }

    if $total != 3 {
        return {gesture: $gesture, action: null}
    }

    let position = vertical-position $sample

    if not $gesture.active {
        return {
            gesture: {active: true, origin: $position, fired: false}
            action: null
        }
    }

    if $gesture.fired {
        return {gesture: $gesture, action: null}
    }

    if ($position - $gesture.origin) >= 1 {
        return {
            gesture: ($gesture | update fired true)
            action: (
                if $app_expose_open { "close-app-expose" } else { "toggle-overview" }
            )
        }
    }

    if ($position - $gesture.origin) <= -1 {
        return {
            gesture: ($gesture | update fired true)
            action: "app-expose"
        }
    }

    {gesture: $gesture, action: null}
}

def invoke-overview [omniwmctl: string, dry_run: bool]: nothing -> nothing {
    if $dry_run {
        print "toggle-overview"
    } else {
        ^$omniwmctl command toggle-overview
    }
}

def invoke-app-expose [dry_run: bool]: nothing -> nothing {
    if $dry_run {
        print "app-expose"
    } else {
        ^/usr/bin/osascript -e 'tell application "System Events" to key code 125 using {control down}'
    }
}

def invoke-close-app-expose [dry_run: bool]: nothing -> nothing {
    if $dry_run {
        print "close-app-expose"
    } else {
        ^/usr/bin/osascript -e 'tell application "System Events" to key code 53'
    }
}

def main [
    --dry-run
    --karabiner-cli: string = "/opt/homebrew/bin/karabiner_cli"
    --omniwmctl: string = "/etc/profiles/per-user/ryoppippi/bin/omniwmctl"
    --polling-interval: int = 20
]: nothing -> nothing {
    let watch_argument = $"--watch-multitouch-extension-variables=($polling_interval)"
    mut gesture = empty-gesture
    mut app_expose_open = false

    for line in (^$karabiner_cli $watch_argument | lines) {
        let sample = try {
            $line | from json
        } catch { continue }
        let result = step $gesture $sample $app_expose_open
        $gesture = $result.gesture

        match $result.action {
            "toggle-overview" => {
                invoke-overview $omniwmctl $dry_run
                $app_expose_open = false
            }
            "app-expose" => {
                invoke-app-expose $dry_run
                $app_expose_open = true
            }
            "close-app-expose" => {
                invoke-close-app-expose $dry_run
                $app_expose_open = false
            }
            _ => { }
        }
    }
}
