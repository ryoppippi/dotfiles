---
name: clean-storage
description: Frees disk space by clearing package, Xcode, and browser caches, removing finished git worktrees, and checking Nix garbage collection. Use when the user asks to free up storage or disk space, or to clean caches or worktrees.
model: haiku
context: fork
---

# Clean Storage

Note `df -h /` before and after. Run everything below without asking, skipping a tool that is not installed, and report the space freed and anything that failed or was kept.

## Caches

- `uv cache clean`
- `bun pm cache rm`
- `npm cache clean --force`
- `pnpm store prune --store-dir <dir>` for each of `~/.local/share/pnpm/store` and `~/Library/pnpm/store` that exists, then delete `~/Library/Caches/pnpm`
- `brew cleanup --prune=all -s`
- `xcrun simctl delete unavailable`
- Delete: `~/.cargo/registry/cache`, `~/.cargo/registry/src`, `~/.cargo/git/checkouts`, `~/Library/Caches/go-build`, `~/Library/Developer/Xcode/DerivedData`, `~/Library/Developer/Xcode/iOS DeviceSupport`, `~/Library/Developer/CoreSimulator/Caches`, `~/Library/Caches/com.apple.dt.Xcode`, `~/Library/Caches/ms-playwright`

## Worktrees

Run `scripts/clean-worktrees.nu` from this skill's directory. Keep every worktree the script keeps.

T3 Code's storage cleanup owns `~/.t3/worktrees`; its policy is `storageCleanup` in `nix/modules/home/programs/t3code/default.nix` of the dotfiles repository. If `dust` still shows that directory dominating, report its size and the policy instead of removing worktrees there.

## Nix

Garbage collection needs root, so leave it to the `nh-clean` launch daemon. If `/var/db/nh-clean.stamp` is missing or older than two days, report the last error in `/var/log/nh-clean.log` and suggest `! sudo nh clean all --keep-since 7d --keep 3 --optimise`, unless `pgrep -f 'nh clean'` shows one already running.

## Boundaries

- Never delete anything else without asking: `~/.cache/.bun` (Bun's install, not its cache), simulator devices, Xcode archives, or browser profiles.
- To free more, measure with `dust` and ask first.
