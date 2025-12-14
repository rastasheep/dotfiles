# Future Considerations: NixOS Integration

This document outlines how this dotfiles repository can grow to support NixOS system configurations alongside the existing macOS setup.

## Current State (macOS-Focused)

```
dotfiles/
├── flake.nix              # Multi-system user packages
├── flake.lock
├── lib/                   # Shared utilities
│   └── default.nix
├── packages/              # Individual tool packages
│   ├── git/, tmux/, nvim/, etc.
│   └── ...
└── machines/              # User package bundles
    └── aleksandars-mbp/   # macOS bundle
```

**Current Usage:**
- macOS: `nix profile install .#aleksandars-mbp`
- Individual tools: `nix run .#git`, `nix run .#nvim`
- Works on multiple systems (darwin, linux) via flake-utils

**What's Missing for NixOS:**
- No NixOS system configurations (boot, networking, services, users)
- Only user-level packages, no system-level declarations
- Can install packages on NixOS, but can't manage the OS itself

---

## Future Growth Options

### Option 1: Single `machines/` Directory

Keep all per-machine configs in one place, mixing user bundles and system configs.

**Structure:**
```
dotfiles/
├── flake.nix
├── lib/
├── packages/
└── machines/
    ├── aleksandars-mbp/          # macOS machine
    │   └── default.nix          # User bundle only (no OS to configure)
    │
    └── nixos-desktop/            # NixOS machine
        ├── configuration.nix     # System config (hardware, services, users)
        ├── hardware-configuration.nix
        └── packages.nix          # User bundle (like aleksandars-mbp)
```

**Flake exports:**
```nix
{
  outputs = { nixpkgs, flake-utils, ... }: {
    # NixOS system configurations
    nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
      modules = [ ./machines/nixos-desktop/configuration.nix ];
    };
  }
  //
  flake-utils.lib.eachDefaultSystem (system: {
    packages = {
      # User bundles
      aleksandars-mbp = import ./machines/aleksandars-mbp { ... };
      nixos-desktop = import ./machines/nixos-desktop/packages.nix { ... };
    };
  });
}
```

**Usage on NixOS:**
```bash
# System rebuild (includes system config + user packages)
sudo nixos-rebuild switch --flake .#nixos-desktop

# Or just install user packages
nix profile install .#nixos-desktop
```

**Pros:**
- ✅ Everything per-machine in one directory
- ✅ Easy to see what belongs to which machine
- ✅ Natural grouping

**Cons:**
- ❌ Mixes user-level and system-level concerns
- ❌ `machines/aleksandars-mbp/` is just packages, but `machines/nixos-desktop/` has system config
- ❌ Not immediately obvious which files need sudo

**When to use:**
- Small setup (1-2 machines)
- You want everything for a machine in one place
- You prefer simplicity over separation of concerns

---

### Option 3: Clear Separation (`systems/` + `users/`)

Split system configurations from user packages into separate top-level directories.

**Structure:**
```
dotfiles/
├── flake.nix
├── lib/
├── packages/              # Building blocks
│   ├── git/, tmux/, nvim/, etc.
│   └── ...
│
├── systems/               # NixOS system configs (hardware, services, boot)
│   ├── desktop/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   └── laptop/
│       ├── configuration.nix
│       └── hardware-configuration.nix
│
└── users/                 # User package bundles (renamed from machines/)
    ├── aleksandars-mbp.nix   # macOS
    ├── desktop.nix           # Linux desktop
    └── laptop.nix            # Linux laptop
```

**Flake exports:**
```nix
{
  outputs = { nixpkgs, flake-utils, ... }: {
    # System configurations (from systems/)
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        modules = [ ./systems/desktop/configuration.nix ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        modules = [ ./systems/laptop/configuration.nix ];
      };
    };
  }
  //
  flake-utils.lib.eachDefaultSystem (system: {
    packages = {
      # User bundles (from users/)
      aleksandars-mbp = import ./users/aleksandars-mbp.nix { ... };
      desktop = import ./users/desktop.nix { ... };
      laptop = import ./users/laptop.nix { ... };
    };
  });
}
```

**Example system config (`systems/desktop/configuration.nix`):**
```nix
{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # System-level configuration
  boot.loader.systemd-boot.enable = true;
  networking.hostName = "desktop";
  services.xserver.enable = true;
  services.openssh.enable = true;

  users.users.rastasheep = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  # Include user packages from users/ directory
  environment.systemPackages = [
    (import ../../users/desktop.nix {
      inherit pkgs;
      claudePkgs = pkgs;
    })
  ];

  system.stateVersion = "24.05";
}
```

**Usage on NixOS:**
```bash
# System rebuild (includes everything)
sudo nixos-rebuild switch --flake .#desktop

# Or just user packages (no sudo)
nix profile install .#desktop
```

**Pros:**
- ✅ Crystal clear separation: `systems/` = sudo, `users/` = no sudo
- ✅ User bundles can be used standalone OR included in system config
- ✅ Easy to understand at a glance
- ✅ Scales well as repo grows

**Cons:**
- ❌ Machine definition split across two directories
- ❌ Need to keep names in sync (systems/desktop ↔ users/desktop.nix)
- ❌ More directories to navigate

**When to use:**
- Multiple machines (3+ systems)
- You want clear separation of concerns
- You value organization over simplicity
- Team environment (multiple contributors)

---

### Option 4: Everything Per-Machine

**Note:** This is essentially the same as Option 1, just with a slightly different file layout. Instead of having separate files like `packages.nix`, you'd inline more into `configuration.nix` or use nested modules.

**Structure is same as Option 1:**
```
machines/
└── nixos-desktop/
    ├── default.nix (configuration.nix)
    ├── hardware-configuration.nix
    └── user-packages.nix
```

The key idea is: "one machine directory contains everything for that machine."

---

## Migration Path

### Phase 1: Current State (Done ✓)
- Multi-system flake with user packages
- Works on macOS and can work on Linux
- Machine bundles for different setups

### Phase 2: Add NixOS Support (Choose Option 1 or 3)

**If choosing Option 1 (Single machines/):**
1. Keep current `machines/aleksandars-mbp/`
2. Add `machines/nixos-desktop/` with system config
3. Update `flake.nix` to export `nixosConfigurations`

**If choosing Option 3 (Clear separation):**
1. Rename `machines/` → `users/`
2. Create `systems/` directory for NixOS configs
3. Update `flake.nix` to export both `nixosConfigurations` and `packages`

### Phase 3: Expand (As Needed)
- Add more machines (laptop, server, etc.)
- Share common modules across machines
- Add shared system modules

---

## Comparison Matrix

| Aspect | Option 1 (Single machines/) | Option 3 (systems/ + users/) |
|--------|----------------------------|------------------------------|
| **Clarity** | Moderate | High |
| **Separation** | Low (mixed concerns) | High (clear boundaries) |
| **Simplicity** | High (fewer directories) | Moderate (more structure) |
| **Scalability** | Good for 1-3 machines | Excellent for 3+ machines |
| **Per-machine view** | Excellent | Moderate (split across dirs) |
| **Standalone use** | Good | Excellent |
| **Team-friendly** | Moderate | High |

---

## Recommendations

### For Small Setup (1-2 NixOS machines)
→ **Use Option 1** (Single `machines/`)
- Keep it simple
- Easy to understand
- Less overhead

### For Growing Setup (3+ machines or team)
→ **Use Option 3** (`systems/` + `users/`)
- Clear separation pays off
- Easier to maintain
- Better organization

### Current Recommendation
**Start with current setup** (no changes needed for now)
- Works great for macOS
- When you get a NixOS machine, choose Option 1 or 3 based on your needs
- Easy to migrate either way

---

## Example: Adding First NixOS Machine

### Option 1 Approach

**Step 1:** Add machine directory
```bash
mkdir -p machines/nixos-desktop
```

**Step 2:** Create system config
```bash
# Copy from NixOS installation
cp /etc/nixos/configuration.nix machines/nixos-desktop/
cp /etc/nixos/hardware-configuration.nix machines/nixos-desktop/
```

**Step 3:** Create user bundle
```bash
# Similar to aleksandars-mbp but Linux-focused
cp machines/aleksandars-mbp/default.nix machines/nixos-desktop/packages.nix
# Edit packages.nix to remove macOS-specific packages
```

**Step 4:** Update flake.nix
```nix
nixosConfigurations.nixos-desktop = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [ ./machines/nixos-desktop/configuration.nix ];
};

packages.nixos-desktop = import ./machines/nixos-desktop/packages.nix { ... };
```

**Step 5:** Test and deploy
```bash
sudo nixos-rebuild switch --flake .#nixos-desktop
```

### Option 3 Approach

**Step 1:** Restructure
```bash
mv machines users
mkdir systems
```

**Step 2:** Add system config
```bash
mkdir -p systems/desktop
cp /etc/nixos/configuration.nix systems/desktop/
cp /etc/nixos/hardware-configuration.nix systems/desktop/
```

**Step 3:** Create user bundle
```bash
cp users/aleksandars-mbp/default.nix users/desktop.nix
# Edit to remove macOS-specific packages
```

**Step 4:** Update flake.nix
```nix
nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [ ./systems/desktop/configuration.nix ];
};

packages.desktop = import ./users/desktop.nix { ... };
```

**Step 5:** Link user bundle in system config
```nix
# In systems/desktop/configuration.nix
environment.systemPackages = [
  (import ../../users/desktop.nix { inherit pkgs; claudePkgs = pkgs; })
];
```

---

## Notes

- **Current setup requires NO changes** - it already works on Linux for user packages
- NixOS integration is **additive** - doesn't break existing macOS workflow
- Both options are valid - choose based on your needs
- Easy to migrate from Option 1 to Option 3 later if needed
- Can mix approaches: use `nix profile` on NixOS without system integration

---

## References

- [NixOS Manual: Configuration](https://nixos.org/manual/nixos/stable/#ch-configuration)
- [Nix Flakes: NixOS configurations](https://nixos.wiki/wiki/Flakes#Using_nix_flakes_with_NixOS)
- [Example configs using Option 1](https://github.com/search?q=nixosConfigurations+machines&type=code)
- [Example configs using Option 3](https://github.com/search?q=nixosConfigurations+hosts+users&type=code)

