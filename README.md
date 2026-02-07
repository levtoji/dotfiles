# NixOS Dotfiles - Refactored Structure

This repository contains NixOS and home-manager configurations for multiple machines with a modular, best-practices approach.

## Structure

```
.
├── flake.nix                    # Main flake configuration
├── nixos/
│   ├── common/
│   │   ├── base.nix            # Core settings for all machines
│   │   └── desktop.nix         # Desktop-specific settings
│   ├── nixos-pc/               # Desktop workstation
│   ├── nixos-nb/               # Notebook/Laptop
│   └── nixos-hs/               # Home server
└── home-manager/
    └── lev/
        ├── common.nix          # Common home settings
        ├── home-nixos-pc.nix   # PC-specific home config
        ├── home-nixos-nb.nix   # Notebook-specific home config
        └── home-nixos-hs.nix   # Server-specific home config
```

## Key Improvements

### 1. Modular NixOS Configuration

- **`nixos/common/base.nix`**: Core settings shared by all machines (Nix, networking, users, SSH, Docker)
- **`nixos/common/desktop.nix`**: Desktop-specific settings (X11, Plasma, printing, scanning, fonts)
- Machine configs import only what they need

### 2. Per-Machine Home Configurations

Each machine has its own home-manager configuration with appropriate packages:

- **PC** (`home-nixos-pc.nix`): Full desktop workstation with development tools, creative apps, office suite
- **Notebook** (`home-nixos-nb.nix`): Lighter configuration for portable use
- **Server** (`home-nixos-hs.nix`): Minimal CLI tools and server utilities

### 3. Best Practices Applied

- ✅ Separation of concerns (base vs desktop vs machine-specific)
- ✅ No redundant packages across machines
- ✅ Server has firewall enabled by default
- ✅ Desktop-specific settings not included in server config
- ✅ Common settings extracted to reusable modules
- ✅ Clear documentation and comments

## Usage

### NixOS Configuration

Build and switch to a configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos-pc
sudo nixos-rebuild switch --flake .#nixos-nb
sudo nixos-rebuild switch --flake .#nixos-hs
```

### Home Manager Configuration

Switch to per-machine home configuration:

```bash
home-manager switch --flake .#lev@nixos-pc
home-manager switch --flake .#lev@nixos-nb
home-manager switch --flake .#lev@nixos-hs
```

The legacy configuration `lev` is still available for backward compatibility.

## Adding a New Machine

### Desktop/Laptop Machine

1. Create directory: `mkdir -p nixos/nixos-new`
2. Copy and customize configuration:
   ```bash
   cp nixos/nixos-nb/configuration.nix nixos/nixos-new/
   cp nixos/nixos-nb/hardware-configuration.nix nixos/nixos-new/
   ```
3. Update hostname in `configuration.nix`
4. Generate hardware config: `nixos-generate-config --show-hardware-config > nixos/nixos-new/hardware-configuration.nix`
5. Create home config: `cp home-manager/lev/home-nixos-nb.nix home-manager/lev/home-nixos-new.nix`
6. Update `flake.nix`:
   ```nix
   nixos-new = "nixos-new";
   # Add to nixosConfigurations and homeConfigurations
   ```

### Server Machine

1. Create directory: `mkdir -p nixos/nixos-hs2`
2. Copy server configuration:
   ```bash
   cp nixos/nixos-hs/configuration.nix nixos/nixos-hs2/
   cp nixos/nixos-hs/hardware-configuration.nix nixos/nixos-hs2/
   ```
3. Update hostname in `configuration.nix`
4. Create home config: `cp home-manager/lev/home-nixos-hs.nix home-manager/lev/home-nixos-hs2.nix`
5. Update `flake.nix` similarly

## Package Distribution

### Common (All Machines)
- Core CLI tools: bat, eza, fd, ripgrep, zoxide, etc.
- Development essentials: git, helix, nixd
- Shell tools: zellij, bottom, yazi

### Desktop Only (PC + Notebook)
- GUI applications
- Development environments
- Office and productivity tools

### PC Specific
- Heavy applications: Steam, creative software
- GPU monitoring tools
- Full development stack

### Notebook Specific
- Lighter application set
- Essential tools for mobile work
- Battery-conscious choices

### Server Specific
- Server monitoring tools
- Minimal development tools
- No GUI applications

## Configuration Philosophy

1. **DRY (Don't Repeat Yourself)**: Common settings are extracted to shared modules
2. **Explicit over Implicit**: Each machine explicitly imports what it needs
3. **Security by Default**: Servers have firewall enabled, SSH properly configured
4. **Modularity**: Easy to add/remove features per machine
5. **Documentation**: Clear structure and usage instructions
