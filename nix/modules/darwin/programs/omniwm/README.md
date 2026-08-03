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

| Action                                         | OmniWM shortcut                | CLAW44 keys                  | MacBook keys                        |
| ---------------------------------------------- | ------------------------------ | ---------------------------- | ----------------------------------- |
| Focus left/down/up/right                       | `Hyper+H/J/K/L`                | Left BS hold + `H/J/K/L`     | Fn hold + `H/J/K/L`                 |
| Move window left/down/up/right                 | `Option+Command+Shift+H/J/K/L` | `S+D` hold + `H/J/K/L`       | Tab hold + `H/J/K/L`                |
| Move whole column left/right                   | `Hyper+Y/O`                    | Left BS hold + `Y/O`         | Fn hold + `Y/O`                     |
| Resize column smaller/larger                   | `Option+Command+←/→`           | `D+F` hold + Layer 2 + `H/L` | Left Option + Command + `←/→`       |
| Resize window shorter/taller                   | `Option+Command+↓/↑`           | `D+F` hold + Layer 2 + `J/K` | Left Option + Command + `↓/↑`       |
| Toggle near-full display width                 | `Hyper+G`                      | Lang1 hold + `G`             | Fn hold + `G`                       |
| Reset window height                            | `Hyper+R`                      | Lang1 hold + `R`             | Fn hold + `R`                       |
| Toggle tabbed column                           | `Hyper+T`                      | Lang1 hold + `T`             | Fn hold + `T`                       |
| Toggle fullscreen                              | `Hyper+F`                      | Lang1 hold + `F`             | Fn hold + `F`                       |
| Toggle floating                                | `Hyper+D`                      | Lang1 hold + `D`             | Fn hold + `D`                       |
| Open command palette                           | `Hyper+Space`                  | Lang1 hold + Space           | Fn hold + Space                     |
| Focus previous window                          | `Option+Command+Tab`           | `D+F` hold + right Tab       | Left Option + Command + Tab         |
| Focus next display                             | `Option+Command+Shift+Tab`     | `S+D` hold + right Tab       | Left Option + Command + Shift + Tab |
| Move window to previous/next display workspace | `Option+Command+Shift+←/→`     | `S+D` hold + Layer 2 + `H/L` | Tab hold + `←/→`                    |
| Switch workspace back and forth                | `Hyper+Tab`                    | Lang1 hold + left Tab        | Fn hold + Tab                       |

## Workspaces

Workspace 1 is pinned to the Dell U5226KW and workspace 2 is pinned to the
built-in MacBook display. cmux opens on workspace 2. `Hyper+Tab` switches back
and forth between the two workspaces.

`Option+Command+Shift+←/→` moves the focused window between the two display
workspaces. This moves only the window; the workspace itself stays assigned to
its display.
`Hyper+Tab` changes the active workspace without moving a window.

On the CLAW44, holding `Enter` activates Layer 2. The tables write `Layer 2`
instead of `Enter` to describe the layer action rather than the physical key.
