# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix dotfiles repository that configures a macOS development environment for user `rastasheep` on the `aleksandars-mbp` host. Uses a modular flake-based architecture with per-tool packages.

## Core Commands

### Apply Configuration Changes
```bash
# Apply dotfiles configuration (defined as alias)
apply-dot

# Manual application (what the alias runs)
cd ~/src/github.com/rastasheep/dotfiles && nix profile upgrade --impure ".*aleksandars-mbp.*"
```

### Update and Upgrade
```bash
# Update flake inputs (nixpkgs) and apply configuration
update-dot

# Upgrade Nix installation itself (less frequent)
upgrade-nix
```

### Development Navigation
```bash
# Navigate to dotfiles directory (uses the 'dev' script)
dev dotfiles
```

## Architecture

### Configuration Structure
- `flake.nix` - Main flake definition with individual tool packages and machine bundles
- `packages/` - Individual tool packages (git, zsh, tmux, nvim, etc.)
  - Each tool is self-contained with its own configuration
  - Can be used independently or as part of a machine bundle
- `machines/aleksandars-mbp/` - Machine-specific configuration bundle
  - Composes individual tool packages
  - Adds machine-specific utilities and apps
  - Includes custom scripts in `bin/` directory
- `packages/macos-defaults/` - Declarative macOS system preferences
  - Type-safe configuration in `defaults.nix`
  - Drift detection and validation
  - Management CLI for checking and exporting settings

### Custom Packages
- `packages/blender/` - Custom Blender package for macOS ARM64
- `packages/kicad/` - Custom KiCad package
- `packages/ghostty/` - Ghostty terminal with configuration
- `packages/hammerspoon/` - Hammerspoon with Leaderflow modal keybindings
- `packages/claude-code/` - Claude Code CLI with 1Password integration

### Scripts and Utilities
Custom shell scripts are available in `packages/scripts/bin/`:
- Git utilities (git-rank-contributors, git-recent, git-wtf)
- Development tools (dev, gh-pr, gh-url, mdc, notes)
- System utilities (extract, headers, update-dot)

## Configuration Management

### Making Changes
1. Edit configuration files in relevant `packages/` directory
2. Run `apply-dot` to apply changes
3. Changes are applied via `nix profile upgrade`

### Host Configuration
The configuration is specific to `aleksandars-mbp`. To adapt for different hosts:
- Create new directory under `machines/` (e.g., `machines/new-hostname/`)
- Create a `default.nix` that composes desired packages
- Install with `nix profile install .#new-hostname`

### Package Management
- Individual tools in `packages/` directories
- Machine-specific bundles in `machines/` directories
- All packages exposed through flake outputs

## Key Programs Configured
- **Shell**: Zsh with custom prompt, autosuggestions, and extensive aliases
- **Editor**: Neovim with treesitter, LSP, completion, and custom plugins
- **Terminal Multiplexer**: tmux with vi key bindings and custom configuration
- **Version Control**: Git with extensive aliases and LFS support
- **macOS Defaults**: Comprehensive system preferences including Dock, Finder, and keyboard settings

## Development Environment Features
- Direnv integration for per-project environments
- FZF for fuzzy finding
- Custom git prompt with status indicators
- Development-focused shell aliases and functions
- Claude Code integration (available as package)