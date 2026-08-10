# OmniWM

OmniWM provides Niri-style scrolling window management on macOS. The Nix
module is defined in [`default.nix`](default.nix), and the application settings
are stored in [`settings.toml`](settings.toml).

The external display shows three containers at once. The built-in MacBook
display overrides this to two containers. Chat and dictionary applications
start narrow, while cmux starts at full column width on workspace 2.

## Modifier layers

`Hyper` means Control + Option + Shift + Command.
`Workspace` means Option + Command + Shift. The latter is a documentation
alias; OmniWM settings use the literal modifiers because it has no custom
modifier names.

- CLAW44: hold the left-half Backspace key; tapping it still sends Backspace.
  The right-half Backspace key remains a normal repeatable Backspace. `Lang1`
  also provides Hyper while held, and `Lang2` provides Command. See the
  [generated keymap](../../../../../keymap/claw44.pdf) for all layers.
- CLAW44: hold `S+D` for the Workspace layer.
- MacBook keyboard: hold Fn. Right Option provides the original Fn key.
- MacBook keyboard: hold Tab for the Workspace layer; tap still sends Tab.
  A held Tab cannot also send Tab, so `Workspace+Tab` is unreachable there.
  [`karabiner.ts`](../../../../../karabiner/karabiner.ts) therefore aliases
  `Workspace+Return` onto it for every keyboard: the CLAW44 keeps the Tab it can
  press comfortably, and either key works on either keyboard. OmniWM itself
  binds one shortcut per command, which is why the alias lives in Karabiner.
  On the CLAW44 this relies on a tapped `Enter` still sending Return while only
  a held one reaches Layer 2.

## Window Shortcuts

| Action                                         | OmniWM shortcut   | CLAW44 keys                      | MacBook keys        |
| ---------------------------------------------- | ----------------- | -------------------------------- | ------------------- |
| Focus left/down/up/right                       | `Hyper+H/J/K/L`   | Left BS hold + `H/J/K/L`         | Fn hold + `H/J/K/L` |
| Focus previous window                          | `Hyper+Tab`       | Lang1 hold + left Tab            | Fn hold + Tab       |
| Move column left/right                         | `Hyper+←/→`       | Left BS hold + `←/→`             | Fn hold + `←/→`     |
| Reorder window down/up                         | `Hyper+↓/↑`       | Left BS hold + `↓/↑`             | Fn hold + `↓/↑`     |
| Consume/expel window left/right                | `Hyper+N/M`       | Left BS hold + `N/M`             | Fn hold + `N/M`     |
| Resize column smaller/larger                   | `Hyper+Y/O`       | Left BS hold + `Y/O`             | Fn hold + `Y/O`     |
| Resize window shorter/taller                   | `Hyper+U/I`       | Left BS hold + `U/I`             | Fn hold + `U/I`     |
| Toggle near-full display width                 | `Hyper+F`         | Lang1 hold + `F`                 | Fn hold + `F`       |
| Reset window height                            | `Hyper+R`         | Lang1 hold + `R`                 | Fn hold + `R`       |
| Toggle tabbed column                           | `Hyper+T`         | Lang1 hold + `T`                 | Fn hold + `T`       |
| Toggle floating                                | `Hyper+D`         | Lang1 hold + `D`                 | Fn hold + `D`       |
| Open command palette                           | `Hyper+Space`     | Lang1 hold + Space               | Fn hold + Space     |
| Switch workspace back and forth                | `Workspace+Tab`   | `S+D` hold + right Tab or Return | Tab hold + Return   |
| Move window to previous/next display           | `Workspace+↑/↓`   | `S+D` hold + Layer 2 + `↑/↓`     | Tab hold + `↑/↓`    |
| Move window to previous/next display workspace | `Workspace+←/→`   | `S+D` hold + Layer 2 + `H/L`     | Tab hold + `←/→`    |
| Toggle Overview                                | `Workspace+Space` | `S+D` hold + Space               | Tab hold + Space    |

`Workspace+↑/↓` binds the native `moveToWorkspace.1`/`moveToWorkspace.3`
hotkeys to `Option+Command+Shift+Up/Down Arrow` in [`settings.toml`](settings.toml).
There is no dedicated "focus the other monitor" shortcut on this layer — see
`Ctrl+↑/↓` below for that.

On any keyboard, [`karabiner.ts`](../../../../../karabiner/karabiner.ts) adds a
Ctrl-based scheme that mirrors the arrow keys instead of stacking onto
Hyper/Workspace:

Ctrl navigates, Ctrl+Shift carries the focused window along. Vertical crosses
displays; horizontal stays within one display's own workspaces.

| Action                                      | Keys             |
| ------------------------------------------- | ---------------- |
| Focus the other display                     | `Ctrl+↑/↓`       |
| Switch workspace                            | `Ctrl+←/→`       |
| Move window across displays                 | `Ctrl+Shift+↑/↓` |
| Move window between workspaces of a display | `Ctrl+Shift+←/→` |

`Ctrl+↑/↓`, `Ctrl+←/→`, and `Ctrl+Shift+↑/↓` shell out to `omniwmctl` directly
rather than remapping to a synthetic keypress. `Ctrl+←/→` and
`Ctrl+Shift+↑/↓` do this because OmniWM exposes no bindable hotkey action for
either one — for monitors only `focus-monitor` is bindable, never "move the
focused window to another monitor". `Ctrl+↑/↓` shells out to `focus-monitor`
for a different reason: `Option+Command+Shift+Up/Down Arrow` (the synthetic
keypress it used to remap to) is now claimed by `moveToWorkspace.1`/`.3` above,
so giving focus its own physical trigger needs the CLI rather than a shared
key. `Ctrl+Shift+←/→` is the one exception that still remaps to a synthetic
keypress, landing on the same native `moveWindowToWorkspaceUp`/`Down` hotkeys
that `Workspace+←/→` uses.

`Ctrl+Shift+↑/↓` names its destination workspace outright
(`move-to-workspace 1` / `move-to-workspace 3`) rather than using the
directional `move-to-workspace on-monitor <workspace> <up|down>`. The
directional form additionally depends on the Monitor Routing Arrangement below
— without a custom one, every direction except `left` returns `not_found`, and
`left` reports success without moving anything — and since the destination
workspace has to be named either way, the direction buys nothing.

On the CLAW44, `Ctrl+↑/↓` and `Ctrl+←/→` work (hold `Esc` or `G` for Ctrl, hold
`Enter` for Layer 2, tap `K`/`J`/`H`/`L`). `Ctrl+Shift+↑/↓` and
`Ctrl+Shift+←/→` additionally need Shift held (the thumb `Tab` key) at the same
time — a fourth simultaneous hold alongside Ctrl and Layer 2 — which the
CLAW44's QMK tap/hold resolution does not reliably register. Use
`Workspace+↑/↓`/`Workspace+←/→` on the CLAW44 for those two instead; they reach
the same actions.

## Workspaces

Workspaces 1 and 2 follow the main display, and workspaces 3 and 4 the first
non-main display. With an external monitor set as the main display, that means
1/2 land on the external monitor and 3/4 on the built-in MacBook display, so
opening the lid never pulls workspace 2 onto the built-in display. The
assignment uses `type = "main"` / `type = "secondary"` rather than
`specificDisplay`, so replacing the external monitor needs no configuration
change. cmux opens on workspace 2.

`Workspace+←/→` moves the focused window between the workspaces of a display.
This moves only the window; the workspace itself stays assigned to its display.
`Workspace+Tab` changes the active workspace without moving a window.
`Hyper+Tab` focuses the previously focused window within the current workspace.

## Trackpad

Four-finger horizontal swipes switch OmniWM workspaces. With the current
direction setting, swiping right goes to the next workspace and swiping left
goes to the previous workspace. macOS four-finger horizontal and vertical
gestures are disabled so Spaces and Mission Control do not intercept the
gesture. The native macOS three-finger vertical gesture is also disabled, so
ordinary scrolling cannot open Mission Control or another window overview.
Use `Workspace+Space` for the reliable keyboard Overview toggle.

IPC is enabled for `omniwmctl` automation. The CLI is available while OmniWM is
running, for example with `omniwmctl ping` or
`omniwmctl command switch-workspace next`.

## Monitor Routing Arrangement

Directional monitor commands (`focus-monitor`, `move-to-workspace on-monitor`,
`swap-workspace-with-monitor`) resolve "up/down/left/right" from OmniWM's own
routing map, not from where the displays visually sit. Per the upstream
[OmniWM README](https://github.com/BarutSRB/OmniWM), two separate arrangements
exist and both matter:

- **macOS Arrangement** (System Settings > Displays > Arrange): a purely
  technical map used for actual window placement. It must be a corner-to-corner
  staircase — physically largest/widest display at the bottom, each smaller
  display above and to its right, corners touching — regardless of the real
  desk layout. A staircase is diagonal by construction, so this map alone can
  never resolve a clean up/down/left/right relationship.
- **OmniWM Routing Arrangement** (OmniWM Settings > Monitors > Custom
  Arrangement): a separate map that should match the real desk. This is what
  `monitorRoutingOverrides` and `[routing] mode = "custom"` in `settings.toml`
  represent. Displays must connect by a shared edge, not just a corner, or
  directional commands return `not_found`.
- **Mouse Warp** must stay enabled (`[mouseWarp] enabled = true`). It moves the
  pointer across display edges using the OmniWM routing map, not the macOS
  staircase, so the cursor still behaves like the real desk even though macOS
  itself is configured with the fake staircase arrangement.

Configure the routing map through **OmniWM Settings > Monitors > Run Monitor
Setup...**. It does not belong in this repository — see below.

## Configuration ownership

OmniWM writes the complete canonical `settings.toml` when settings are saved in
the GUI, and it has no include mechanism, so there is no separate file for
machine-local settings. Home Manager therefore rebuilds the live file during
activation with [`merge-settings.nu`](merge-settings.nu) instead of managing a
read-only Nix store symlink, and ownership is split:

- **This repository owns everything else.** Edit [`settings.toml`](settings.toml)
  and run the Darwin switch to apply persistent changes. GUI edits to those
  settings are discarded by the next switch.
- **The GUI owns the monitor settings** — `monitorBarOverrides`,
  `monitorDwindleOverrides`, `monitorGapOverrides`, `monitorNiriOverrides`,
  `monitorOrientationOverrides`, `monitorRoutingOverrides`, and
  `[routing] mode`. Each is keyed by `monitorDisplayUUID`, which makes them a
  description of the machine and the desk it sits on rather than of this
  configuration: the external display differs between home and the office, so a
  committed UUID would be wrong in one of them. Activation reads these back
  from the live file and layers them over the template, so they survive a
  switch and need to be configured once per machine.

On the CLAW44, holding `Enter` activates Layer 2. The tables write `Layer 2`
instead of `Enter` to describe the layer action rather than the physical key.
