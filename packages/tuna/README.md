# Tuna Configuration Management

This is a **placeholder package** that stores Tuna config as reference only.

## Installation

Tuna.app must be installed manually from: https://tunaformac.com/download/latest

## Why No Automation?

Nix cannot automatically sync configs during `nix profile upgrade` because:
- Builds run in sandbox without `$HOME` access
- No post-install hooks exist for `nix profile` commands
- All "solutions" require manual wrapper scripts

## Setup

Configure Tuna to use the config file from this repo:
- In Tuna settings, point config location to: `~/src/github.com/rastasheep/dotfiles/packages/tuna/config/config.toml`

## Workflow

### 1. Use Tuna Normally
Tuna reads and writes directly to the config file in this repo.

### 2. Commit Changes When Ready
```bash
cd ~/src/github.com/rastasheep/dotfiles
git diff packages/tuna/config/
git add packages/tuna/config/
git commit -m "feat(tuna): update config"
```

Changes appear automatically in `git status` as you modify settings in Tuna's UI.

## Files

- `config/config.toml` - Live config file (Tuna reads/writes directly to this location)
- `default.nix` - Placeholder Nix package

## Replacing LeaderKey and Moves

Tuna replaces:
- `packages/leader-key/` - Modal keybindings (Tuna's Leader Mode)
- `packages/moves/` - Window tiling (Tuna URL schemes)

Old packages can be removed after confirming Tuna works.
