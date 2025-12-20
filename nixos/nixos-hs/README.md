# NixOS Home Server Configuration

This directory contains the NixOS configuration for home servers.

## Current Home Servers

- **nixos-hs**: First home server configuration

## Adding a New Home Server

To add additional home servers (e.g., `nixos-hs2`, `nixos-hs3`, etc.), follow these steps:

1. **Create a new directory** for the server configuration:
   ```bash
   mkdir -p nixos/nixos-hs2
   ```

2. **Copy the configuration template** from the existing home server:
   ```bash
   cp nixos/nixos-hs/configuration.nix nixos/nixos-hs2/
   cp nixos/nixos-hs/hardware-configuration.nix nixos/nixos-hs2/
   ```

3. **Update the hostname** in `nixos/nixos-hs2/configuration.nix`:
   ```nix
   networking.hostName = "nixos-hs2";
   ```

4. **Generate and merge hardware configuration** on the target machine:
   ```bash
   # Generate the hardware configuration
   nixos-generate-config --show-hardware-config > /tmp/hw-config.nix
   
   # Review and merge the relevant parts into your hardware-configuration.nix
   # Pay special attention to:
   # - boot.initrd.availableKernelModules
   # - boot.kernelModules (kvm-intel vs kvm-amd)
   # - fileSystems and their UUIDs
   # - swapDevices
   ```

5. **Update `flake.nix`** to include the new server:
   
   Add the variable in the `let` block:
   ```nix
   nixos-hs2 = "nixos-hs2";
   ```
   
   Add the configuration entry:
   ```nix
   ${nixos-hs2} = nixpkgs.lib.nixosSystem {
     specialArgs = { inherit inputs outputs; };
     modules = [ ./nixos/${nixos-hs2}/configuration.nix ];
   };
   ```

6. **Deploy to the server**:
   ```bash
   nixos-rebuild switch --flake .#nixos-hs2
   ```

## Configuration Details

### Base Configuration

All home servers inherit from `../common/common.nix` which includes:
- User accounts
- Base system packages
- Docker support
- SSH server configuration
- Common system settings

### Server-Specific Settings

The home server configuration (`nixos-hs/configuration.nix`) includes:
- Disabled graphical services (headless by default)
- Server-appropriate packages (htop, tmux)
- Commented examples for common server services:
  - Tailscale for secure remote access
  - Samba for file sharing
  - NFS server
  - Plex Media Server
  - And more...

### Customization

To customize a home server:
1. Edit `nixos/nixos-hs/configuration.nix` (or your specific server's config)
2. Uncomment and configure the services you need
3. Add any additional packages to `environment.systemPackages`
4. Deploy with `nixos-rebuild switch --flake .#nixos-hs`

## Available Configurations

You can build any configuration using:
```bash
nixos-rebuild switch --flake .#<hostname>
```

Where `<hostname>` is one of:
- `nixos-pc` - Desktop PC
- `nixos-nb` - Notebook/Laptop
- `nixos-hs` - Home Server
