# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Nix dotfiles repository managed with home-manager and fleek. It configures a macOS development environment for user `rastasheep` on the `aleksandars-mbp` host.

## Core Commands

### Apply Configuration Changes
```bash
# Apply dotfiles configuration (defined as alias)
apply-dot

# Manual application (what the alias runs)
cd ~/src/github.com/rastasheep/dotfiles && nix run --impure home-manager/master -- -b bak switch --flake .#rastasheep@aleksandars-mbp
```

### Update and Upgrade
```bash
# Update flake inputs (nixpkgs, home-manager) and apply configuration
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
- `flake.nix` - Main flake definition with inputs and home-manager configuration
- `home.nix` - Base configuration with global packages and shell aliases
- `aleksandars-mbp/rastasheep.nix` - Host-specific configuration including:
  - User-specific packages
  - Shell aliases and functions
  - macOS system defaults
  - Git configuration
  - tmux configuration
  - Zsh configuration with custom prompt
  - Neovim configuration with plugins

### Custom Packages
- `pkgs/blender.nix` - Custom Blender package for macOS ARM64
- `pkgs/kicad.nix` - Custom KiCad package 
- Both are defined as overlays in `flake.nix`

### Scripts and Utilities
The `aleksandars-mbp/bin/` directory contains custom shell scripts that are added to PATH:
- Git utilities (git-rank-contributors, git-recent, git-wtf)
- Development tools (dev, gh-pr, gh-url, mdc, notes)
- System utilities (extract, headers)

## Configuration Management

### Making Changes
1. Edit configuration files (primarily in `aleksandars-mbp/rastasheep.nix`)
2. Run `apply-dot` to apply changes
3. Configuration creates backups with `-b bak` flag

### Host Configuration
The configuration is specific to `rastasheep@aleksandars-mbp`. To adapt for different hosts:
- Create new directory under project root (e.g., `new-hostname/`)
- Add new homeConfiguration in `flake.nix`
- Reference the new configuration module

### Package Management
- Global packages defined in `home.nix`
- Host-specific packages in `aleksandars-mbp/rastasheep.nix`
- Custom packages via overlays in `flake.nix`

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