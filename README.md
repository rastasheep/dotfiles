# Dotfiles

Portable Nix-based dotfiles for macOS with individual tool wrappers.

## Features

- **Shell**: Zsh with [Starship](https://starship.rs) prompt
- **Editor**: Neovim 0.11+ with LSP, Treesitter, and completion
- **Terminal**: [Ghostty](https://ghostty.org) with Flexoki theme
- **Window Management**: [Hammerspoon](https://www.hammerspoon.org) with Leaderflow modal keybindings
- **Development**: Claude Code, direnv, fzf, ripgrep
- **Git**: Modern config with rebasing, pruning, and helpful aliases
- **Portable**: Run tools on any Nix-enabled machine without installation

## Quick Start

### Option 1: Run Individual Tools (No Installation)
```bash
# Run neovim with your config
nix run github:rastasheep/dotfiles#nvim

# Run tmux, git, or any other tool
nix run github:rastasheep/dotfiles#tmux
nix run github:rastasheep/dotfiles#git status

# Run from local checkout
cd ~/src/github.com/rastasheep/dotfiles
nix run .#nvim
```

### Option 2: Install Everything
```bash
# Install all tools to your profile
nix profile install github:rastasheep/dotfiles

# Or from local checkout
cd ~/src/github.com/rastasheep/dotfiles
nix profile install .#default

# Update later
nix profile upgrade '.*dotfiles.*'
```

### Option 3: Install Individual Tools
```bash
# Cherry-pick the tools you want
nix profile install github:rastasheep/dotfiles#{nvim,git,tmux}
```

### Option 4: Machine-Specific Bundle
```bash
# Install complete machine-specific bundle
cd ~/src/github.com/rastasheep/dotfiles
nix profile install .#aleksandars-mbp

# Update later
apply-dot  # or: nix profile upgrade ".*aleksandars-mbp.*"
```

## Structure

```
.
├── flake.nix                    # Flake definition with all packages
├── packages/                    # All tool and app packages (CLI + GUI)
│   ├── nvim/                   # Neovim with plugins and config
│   ├── git/                    # Git with custom config
│   ├── tmux/                   # Tmux with custom config
│   ├── zsh/                    # Zsh with plugins and config
│   ├── starship/               # Starship prompt config
│   ├── scripts/                # Custom scripts (dev, git-*, etc.)
│   ├── fzf/                    # FZF fuzzy finder
│   ├── direnv/                 # Direnv integration
│   ├── hammerspoon/            # Hammerspoon app with config
│   ├── ghostty/                # Ghostty terminal with config
│   ├── claude-code/            # Claude with 1Password + config
│   ├── 1password-cli/          # 1Password CLI
│   ├── blender/                # Custom Blender build (optional)
│   └── kicad/                  # Custom KiCad build (optional)
└── machines/                    # Machine-specific bundles
    └── aleksandars-mbp/        # Composes tools + apps for this machine
```

## Available Packages

All packages are exposed individually and can be run or installed standalone.

### CLI Tools
- `nvim` - Neovim with plugins (treesitter, gitsigns, fzf-lua) and custom config
- `git` - Git with custom config and aliases
- `tmux` - Tmux with vi-mode and custom keybindings
- `zsh` - Zsh with plugins (autosuggestions, completions) and config
- `starship` - Starship prompt with minimal config
- `fzf` - FZF fuzzy finder
- `direnv` - Direnv for per-project environments
- `scripts` - Custom shell scripts (dev, git-*, gh-*, etc.)

### GUI Apps
- `hammerspoon` - Hammerspoon with bundled Leaderflow config
- `ghostty` - Ghostty terminal with custom config
- `claude-code` - Claude Code with 1Password integration and custom settings
- `1password-cli` - 1Password CLI
- `blender` - Custom Blender build (optional, commented out)
- `kicad` - Custom KiCad build (optional, commented out)

### Machine Bundles
Pre-configured bundles for specific machines:

- `aleksandars-mbp` - Complete setup with all CLI tools + GUI apps
- `default` - Core CLI tools only (no GUI apps)

## References

- [Nix flakes](https://nixos.wiki/wiki/Flakes)
- [Nix packages manual](https://nixos.org/manual/nixpkgs/stable/)
