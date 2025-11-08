# Dotfiles

Nix-based dotfiles for macOS using home-manager and flakes.

## Features

- **Shell**: Zsh with [Starship](https://starship.rs) prompt
- **Editor**: Neovim 0.11+ with LSP, Treesitter, and completion
- **Terminal**: [Ghostty](https://ghostty.org) with Flexoki theme
- **Window Management**: [Hammerspoon](https://www.hammerspoon.org) with Leaderflow modal keybindings
- **Development**: Claude Code, direnv, fzf, ripgrep
- **Git**: Modern config with rebasing, pruning, and helpful aliases

## Quick Start

```bash
# Apply configuration
apply-dot

# Update and apply
update-dot

# Navigate to dotfiles
dev dotfiles
```

## Structure

```
.
├── flake.nix                    # Flake definition with inputs
├── home.nix                     # Global packages and settings
└── aleksandars-mbp/
    ├── rastasheep.nix          # Host-specific config (main file)
    ├── vim.lua                 # Neovim configuration
    ├── bin/                    # Custom scripts (dev, git-*, etc.)
    ├── claude/                 # Claude Code settings and commands
    ├── ghostty/                # Ghostty terminal config
    └── hammerspoon/            # Hammerspoon window management
```

## Key Configurations

### Neovim
- Leader: `Space`
- LSP servers configured per-project via direnv
- Built-in completion (Neovim 0.11+)
- Treesitter for syntax highlighting
- fzf-lua for fuzzy finding

### Git Aliases
- `g st` - Status
- `g ci` - Commit
- `g co` - Checkout
- `g lg` - Pretty log
- `g up` - Pull with rebase
- See more in `aleksandars-mbp/rastasheep.nix`

### Shell Aliases
- `e` - vim
- `g` - git
- `ll` - ls -lah
- `..` - cd ..
- `dev <project>` - Navigate to project or clone it

## Requirements

- Nix with flakes enabled
- macOS (Darwin)
- 1Password CLI (for Claude Code integration)

## References

- [home-manager](https://nix-community.github.io/home-manager/)
- [home-manager options](https://nix-community.github.io/home-manager/options.html)
- [Nix flakes](https://nixos.wiki/wiki/Flakes)
