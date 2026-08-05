# Nix Configuration

## Structure

- **Entry point**: `flake.nix` (in repo root)
- **Modules**: `modules/`
  - `home/` - Cross-platform (home-manager)
  - `darwin/` - macOS-specific (nix-darwin)
  - `linux/` - Linux-specific
  - `lib/` - Shared helpers
- **Overlays**: `overlays/`

## Commands

```bash
# Apply changes (stage the paths you changed first!)
git add <changed paths> && nix run .#switch

# Update dependencies
nix run .#update

# Update AI tools only
nix run .#update-ai-tools

# Regenerate Nix-served Neovim plugin sources (after changing plugin specs)
nix run .#lazy2nix

# Test build without applying
nix run .#build
```

## Common Tasks

| Task                  | Location                      |
| --------------------- | ----------------------------- |
| Add/remove packages   | `modules/home/packages.nix`   |
| macOS packages        | `modules/darwin/packages.nix` |
| Homebrew packages     | `modules/darwin/system.nix`   |
| Dotfile symlinks      | `modules/home/dotfiles.nix`   |
| macOS system settings | `modules/darwin/system.nix`   |
| Program configs       | `modules/home/programs/`      |

## Important

- Always `git add` changes before `nix run .#switch` — flakes only see tracked,
  staged files. Stage explicit paths; never `git add -A`, `git add .`, or
  `git add -u`. Staging for `switch` is a build prerequisite, not a commit plan
- Prefer Nix packages over Homebrew when available
- Dotfiles use `mkOutOfStoreSymlink` for mutability
