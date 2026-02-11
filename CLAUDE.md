# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a modular Nix flake-based dotfiles repository for macOS. It provides portable, reproducible configurations for development tools and applications. The repository uses Nix flakes with multi-system support and follows modern Nix best practices.

## Core Commands

### Apply Configuration Changes
```bash
# Update dotfiles installation (use exact profile name, not regex)
nix profile upgrade aleksandars-mbp

# Or rebuild from source
cd ~/src/github.com/rastasheep/dotfiles
nix profile install .#aleksandars-mbp --priority 5
```

### Update and Upgrade
```bash
# Update flake inputs (nixpkgs, flake-utils)
nix flake update

# Upgrade specific input
nix flake lock --update-input nixpkgs
```

### Validation and Testing
```bash
# Run all checks
nix flake check

# Show flake structure
nix flake show

# Build specific package
nix build .#git

# Test package without installing
nix run .#nvim

# Access unwrapped package
nix run .#git.unwrapped status

# Check version
nix eval .#git.version
```

## Architecture

### Repository Structure
```
.
├── flake.nix              # Main flake with multi-system support
├── flake.lock             # Locked dependency versions
├── lib/                   # Shared utilities
│   └── default.nix       # Reusable functions (wrapWithConfig, buildConfig, etc.)
├── packages/              # Individual tool packages
│   ├── git/              # Git with custom config
│   ├── tmux/             # Tmux with custom config
│   ├── nvim/             # Neovim with plugins
│   ├── zsh/              # Zsh with plugins
│   ├── starship/         # Starship prompt
│   ├── scripts/          # Custom shell scripts
│   ├── ghostty/          # Terminal emulator
│   ├── leader-key/       # Modal keybindings with LeaderKey
│   ├── moves/            # Window tiling with Moves.app
│   ├── claude-code/      # Claude Code with 1Password integration
│   ├── macos-defaults/   # Declarative macOS system defaults
│   ├── dircolors/        # GNU dircolors configuration
│   └── ...
└── machines/              # Machine-specific bundles
    └── aleksandars-mbp/  # Composes all packages for this machine
```

### Shared Library (lib/default.nix)
All packages use shared utilities to ensure consistency:
- `wrapWithConfig`: Standard CLI wrapper with env var config
- `buildConfig`: Config directory builder (installs to /share/{name})
- `smartConfigLink`: Backup and symlink logic for existing configs
- `mkMeta`: Standardized meta attributes template

### Package Patterns
All packages follow consistent patterns:
- Use `inherit (pkgs) lib;` instead of `with pkgs.lib;`
- Include complete meta attributes (description, homepage, license, platforms)
- Expose unwrapped package via `passthru.unwrapped`
- Use `stdenvNoCC` for pure config packages (no compilation)
- Use shared library utilities where applicable

### Multi-System Support
The flake supports multiple systems via flake-utils:
- `aarch64-darwin` (Apple Silicon Macs)
- `x86_64-darwin` (Intel Macs)
- `aarch64-linux` (ARM Linux)
- `x86_64-linux` (x86 Linux)

## Configuration Management

### Adding a New Package
1. Create package directory in `packages/`
2. Use shared library utilities from `lib/default.nix`
3. Follow package patterns (inherit lib, complete meta, passthru)
4. Add package import to `flake.nix` let block
5. Export in `packages` output
6. Add to machine bundle in `machines/aleksandars-mbp/default.nix`
7. Run `nix flake check` to verify

### Creating a New Machine Bundle
1. Create directory in `machines/` (e.g., `machines/new-machine/`)
2. Create `default.nix` that imports and composes packages
3. Add to `flake.nix` packages output:
   ```nix
   new-machine = import ./machines/new-machine { inherit pkgs claudePkgs; };
   ```
4. Install with: `nix profile install .#new-machine`

### Modifying Existing Packages
1. Edit package in `packages/{name}/default.nix`
2. Run `nix build .#{name} --dry-run` to verify
3. Test with `nix run .#{name}`
4. Run `nix flake check` before committing

## Key Packages Configured

### CLI Tools
- **git**: Custom config with rebasing, pruning, helpful aliases, LFS support
- **tmux**: Vi key bindings, custom prefix, status bar configuration
- **zsh**: Autosuggestions, completions, custom sourcing
- **starship**: Minimal prompt configuration
- **nvim**: Treesitter, LSP, completion, fzf-lua, gitsigns, Flexoki theme
- **scripts**: Custom shell scripts (dev, git-*, gh-*, etc.)
- **dircolors**: GNU dircolors configuration for colorized ls output

### GUI Applications
- **ghostty**: Terminal emulator with Flexoki theme
- **leader-key**: Modal keybindings system with custom shortcuts
- **moves**: Window tiling and management application
- **claude-code**: Claude Code with 1Password integration for secrets
- **macos-defaults**: Declarative macOS system defaults management

### Machine Bundle Includes
The aleksandars-mbp bundle also includes upstream packages:
- Core utilities: coreutils, ripgrep, openssl, tree, wget
- Development: direnv, fzf, docker, openvpn, 1password-cli
- GUI apps: slack

## Best Practices

### Nix Code Style
- Use `inherit (pkgs) lib;` instead of `with pkgs.lib;`
- Add complete meta attributes to all packages
- Use `stdenvNoCC` for pure config packages
- Add `passthru.unwrapped` to wrapped packages
- Use shared library utilities where applicable

### Package Development
- Test with `nix build .#{name} --dry-run` before committing
- Run `nix flake check` to validate all packages build
- Use `nix run .#{name}` to test package functionality
- Check `nix flake show` to verify package exports

### Commit Messages
- Use conventional commit format (feat:, fix:, refactor:, docs:)
- Include what changed and why
- Reference specific files when relevant
- Add co-author attribution for Claude Code contributions
