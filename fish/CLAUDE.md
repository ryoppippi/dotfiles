# Fish Shell Configuration

## Structure

- `config.fish` - Main entry point, loads configs from `config/*.fish`
- `config/*.fish` - Modular configuration files
- `user_functions/*.fish` - Custom Fish functions
- `themes/kanagawa.fish` - Colour theme

## Key Environment Variables

- `EDITOR=nvim`, `GIT_EDITOR=nvim`, `MANPAGER=nvim`
- `CLAUDE_CONFIG_DIR=$XDG_CONFIG_HOME/claude`
- `CODEX_HOME=$XDG_CONFIG_HOME/codex`
- `AMP_HOME=$XDG_CONFIG_HOME/amp`

## Path Management

Paths are managed via `fish_add_path` in `config.fish`. Nix home-manager paths are included automatically.
