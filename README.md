# Dotfiles

Portable Nix-based dotfiles for macOS with individual tool wrappers.

## Features

- **Shell**: Zsh with [Starship](https://starship.rs) prompt
- **Editor**: Neovim 0.11+ with LSP, Treesitter, and completion
- **Terminal**: [Ghostty](https://ghostty.org) with Flexoki theme
- **Window Management**: [LeaderKey](https://github.com/dkarter/leader-key) with modal keybindings and [Moves](https://moves.app) for window tiling
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
├── flake.nix                    # Flake definition with multi-system support
├── flake.lock                   # Locked dependency versions
├── lib/                         # Shared utilities and helpers
│   └── default.nix             # Reusable functions (wrapWithConfig, buildConfig, etc.)
├── packages/                    # All tool and app packages (CLI + GUI)
│   ├── nvim/                   # Neovim with plugins and config
│   ├── git/                    # Git with custom config
│   ├── tmux/                   # Tmux with custom config
│   ├── zsh/                    # Zsh with plugins and config
│   ├── starship/               # Starship prompt config
│   ├── scripts/                # Custom scripts (dev, git-*, etc.)
│   ├── dircolors/              # GNU dircolors configuration
│   ├── ghostty/                # Ghostty terminal with config
│   ├── claude-code/            # Claude with 1Password + config
│   ├── macos-defaults/         # macOS system defaults management
│   ├── blender/                # Custom Blender build (optional, commented out)
│   └── kicad/                  # Custom KiCad build (optional, commented out)
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
- `scripts` - Custom shell scripts (dev, git-*, gh-*, etc.)
- `dircolors` - GNU dircolors configuration

### GUI Apps & Utilities
- `ghostty` - Ghostty terminal with custom config
- `leader-key` - LeaderKey with modal keybindings configuration
- `moves` - Moves app for window tiling and management
- `claude-code` - Claude Code with 1Password integration and custom settings
- `macos-defaults` - Declarative macOS system defaults management
- `kicad` - Custom KiCad build

**Note:** Common tools like `fzf`, `direnv`, and `1password-cli` are included directly in the machine bundle without custom wrappers.

### Machine Bundles
Pre-configured bundles for specific machines:

- `aleksandars-mbp` - Complete setup with all CLI tools + GUI apps
- `default` - Core CLI tools only (no GUI apps)

## Architecture & Features

### Multi-System Support
The flake supports multiple systems out of the box:
- `aarch64-darwin` (Apple Silicon Macs)
- `x86_64-darwin` (Intel Macs)
- `aarch64-linux` (ARM Linux)
- `x86_64-linux` (x86 Linux)

### Shared Library
All packages use shared utilities from `lib/default.nix`:
- `wrapWithConfig`: Standard CLI wrapper pattern
- `buildConfig`: Config directory builder
- `smartConfigLink`: Backup and symlink logic
- `mkMeta`: Standardized meta attributes

This ensures consistency and reduces code duplication across all packages.

### Package Passthru
All wrapped packages expose the underlying package via `passthru.unwrapped`:
```bash
# Run with your config
nix run .#git status

# Run without your config (unwrapped)
nix run .#git.unwrapped status

# Check version
nix eval .#git.version
```

### Flake Checks
Validate packages build correctly:
```bash
# Run all checks
nix flake check

# View available checks
nix flake show | grep checks

# Run specific check
nix build .#checks.aarch64-darwin.all-packages
```

## Development

### Adding a New Package
1. Create package directory in `packages/`
2. Use shared library utilities from `lib/default.nix`
3. Add package to `flake.nix` imports
4. Add to machine bundle in `machines/aleksandars-mbp/default.nix`
5. Run `nix flake check` to verify

### Best Practices
- Use `inherit (pkgs) lib;` instead of `with pkgs.lib;`
- Add complete meta attributes (description, homepage, license, platforms)
- Add `passthru.unwrapped` for wrapped packages
- Use shared library utilities where applicable
- Use `stdenvNoCC` for pure config packages

## References

- [Nix flakes](https://nixos.wiki/wiki/Flakes)
- [Nix packages manual](https://nixos.org/manual/nixpkgs/stable/)
- [flake-utils](https://github.com/numtide/flake-utils)
