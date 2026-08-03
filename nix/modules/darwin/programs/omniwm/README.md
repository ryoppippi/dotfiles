# OmniWM

OmniWM provides Niri-style scrolling window management on macOS. The Nix
module is defined in [`default.nix`](default.nix), and the application settings
are stored in [`settings.toml`](settings.toml).

The ultrawide display shows three containers at once. The built-in MacBook
display overrides this to two containers. Chat and dictionary applications
start narrow, while cmux starts at full column width on workspace 2.

## Hyper Key

`Hyper` means Control + Option + Shift + Command.

- CLAW44: hold either language key. See the
  [generated keymap](../../../../../keymap/claw44.pdf) for all layers.
- MacBook keyboard: hold Fn. Right Option provides the original Fn key.
- MacBook keyboard: hold Tab for an additional Hyper key; tap still sends Tab.

## Window Shortcuts

| Shortcut                 | Action                                         |
| ------------------------ | ---------------------------------------------- |
| `Hyper+H/J/K/L`          | Focus left/down/up/right                       |
| `Hyper+U/O`              | Move the focused window left/right             |
| `Hyper+I/P`              | Move the focused window down/up within a stack |
| `Hyper+Z/X`              | Move the whole column left/right               |
| `Hyper+,/.`              | Cycle the focused column smaller/larger        |
| `Hyper+M`                | Toggle near-full display width                 |
| `Hyper+Return`           | Toggle fullscreen                              |
| `Hyper+/`                | Toggle floating                                |
| `Hyper+Space`            | Open the OmniWM command palette                |
| `Option+Shift+Command+←` | Move the window to the main display            |
| `Option+Shift+Command+→` | Move the window to the secondary display       |
| `Control+Command+Tab`    | Focus the next monitor                         |
| `Control+Command+\``     | Focus the last monitor                         |

## Workspaces

Workspace 1 belongs to the main display and workspace 2 belongs to the
secondary display. cmux opens on workspace 2. `Hyper+Tab` switches back and
forth between the two workspaces.

Direct move-to-workspace shortcuts are currently unassigned.
