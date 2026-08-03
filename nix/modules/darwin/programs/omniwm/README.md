# OmniWM

OmniWM provides Niri-style scrolling window management on macOS. The Nix
module is defined in [`default.nix`](default.nix), and the application settings
are stored in [`settings.toml`](settings.toml).

The ultrawide display shows three containers at once. The built-in MacBook
display overrides this to two containers. Chat and dictionary applications
start narrow, while cmux starts at full column width on workspace 2.

## Hyper Key

`Hyper` means Control + Option + Shift + Command.

- CLAW44: hold the left-half Backspace key; tapping it still sends Backspace.
  The right-half Backspace key remains a normal repeatable Backspace. `Lang1`
  also provides Hyper while held, and `Lang2` provides Command. See the
  [generated keymap](../../../../../keymap/claw44.pdf) for all layers.
- MacBook keyboard: hold Fn. Right Option provides the original Fn key.
- MacBook keyboard: hold Tab for Option + Command + Shift; tap still sends Tab.

## Window Shortcuts

| Action                                         | OmniWM shortcut            | CLAW44 keys                  | MacBook keys                        |
| ---------------------------------------------- | -------------------------- | ---------------------------- | ----------------------------------- |
| Focus left/down/up/right                       | `Hyper+H/J/K/L`            | Left BS hold + `H/J/K/L`     | Fn hold + `H/J/K/L`                 |
| Move column left/right                         | `Hyper+←/→`                | Left BS hold + `←/→`         | Fn hold + `←/→`                     |
| Reorder window down/up                         | `Hyper+↓/↑`                | Left BS hold + `↓/↑`         | Fn hold + `↓/↑`                     |
| Resize column smaller/larger                   | `Hyper+Y/O`                | Left BS hold + `Y/O`         | Fn hold + `Y/O`                     |
| Resize window shorter/taller                   | `Hyper+U/I`                | Left BS hold + `U/I`         | Fn hold + `U/I`                     |
| Toggle near-full display width                 | `Hyper+F`                  | Lang1 hold + `F`             | Fn hold + `F`                       |
| Reset window height                            | `Hyper+R`                  | Lang1 hold + `R`             | Fn hold + `R`                       |
| Toggle tabbed column                           | `Hyper+T`                  | Lang1 hold + `T`             | Fn hold + `T`                       |
| Toggle floating                                | `Hyper+D`                  | Lang1 hold + `D`             | Fn hold + `D`                       |
| Open command palette                           | `Hyper+Space`              | Lang1 hold + Space           | Fn hold + Space                     |
| Focus next display                             | `Option+Command+Shift+Tab` | `S+D` hold + right Tab       | Left Option + Command + Shift + Tab |
| Move window to previous/next display workspace | `Option+Command+Shift+←/→` | `S+D` hold + Layer 2 + `H/L` | Tab hold + `←/→`                    |
| Switch workspace back and forth                | `Hyper+Tab`                | Lang1 hold + left Tab        | Fn hold + Tab                       |

## Workspaces

Workspace 1 is pinned to the Dell U5226KW and workspace 2 is pinned to the
built-in MacBook display. cmux opens on workspace 2. `Hyper+Tab` switches back
and forth between the two workspaces.

`Option+Command+Shift+←/→` moves the focused window between the two display
workspaces. This moves only the window; the workspace itself stays assigned to
its display.
`Hyper+Tab` changes the active workspace without moving a window.

## Trackpad

Four-finger horizontal swipes switch OmniWM workspaces. With the current
direction setting, swiping right goes to the next workspace and swiping left
goes to the previous workspace. macOS four-finger horizontal and vertical
gestures are disabled so Spaces and Mission Control do not intercept the
gesture. The three-finger vertical gesture is handled by the Karabiner
Multitouch Extension: swiping up toggles OmniWM Overview. Enable
`Enable Multitouch Extension` in Karabiner-Elements before using it. The native
macOS three-finger vertical gesture is disabled to prevent Mission Control from
opening at the same time; the watcher sends the equivalent App Exposé shortcut
for a downward swipe, and sends Escape for the next upward swipe to return from
App Exposé.

IPC is enabled for `omniwmctl` automation. The CLI is available while OmniWM is
running, for example with `omniwmctl ping` or
`omniwmctl command switch-workspace next`.

## Configuration ownership

OmniWM writes the complete canonical `settings.toml` when settings are saved in
the GUI. Home Manager therefore copies the repository template to a writable
file during activation instead of managing a read-only Nix store symlink. The
repository template remains authoritative: edit it and run the Darwin switch
to apply persistent changes. GUI edits to the live file are overwritten by the
next switch.

On the CLAW44, holding `Enter` activates Layer 2. The tables write `Layer 2`
instead of `Enter` to describe the layer action rather than the physical key.
