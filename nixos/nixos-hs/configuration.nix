{ pkgs, ... }:

{
  # Import common configuration and hardware configuration
  imports = [
    ../common/common.nix
    ./hardware-configuration.nix
  ];

  # Set hostname for the home server
  networking.hostName = "nixos-hs";

  # --- Server-specific settings ---

  # Disable graphical services for a headless server setup
  # Comment out or remove these lines if you need a GUI on your home server
  services.xserver.enable = false;
  services.displayManager.sddm.enable = false;
  services.desktopManager.plasma6.enable = false;

  # Enable hardware graphics but without desktop environment
  # This can be useful for transcoding or other GPU tasks
  hardware.graphics = {
    enable = true;
  };

  # --- Useful server services ---

  # SSH is enabled in common.nix, but you can override settings here if needed
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PermitRootLogin = "no";
  #     PasswordAuthentication = false;
  #   };
  # };

  # Example: Enable Tailscale for secure remote access
  # services.tailscale.enable = true;

  # Example: Enable Samba for file sharing
  # services.samba = {
  #   enable = true;
  #   shares = {
  #     public = {
  #       path = "/srv/samba/public";
  #       browseable = "yes";
  #       "read only" = "no";
  #       "guest ok" = "yes";
  #     };
  #   };
  # };

  # Example: Enable NFS server
  # services.nfs.server.enable = true;

  # Example: Enable Plex Media Server
  # services.plex = {
  #   enable = true;
  #   openFirewall = true;
  # };

  # Example: Enable Docker (already enabled in common.nix)
  # virtualisation.docker.enable = true;

  # --- Additional server packages ---
  environment.systemPackages = with pkgs; [
    # Add server-specific packages here
    htop
    tmux
  ];

  # NixOS state version - update this to match your NixOS installation
  system.stateVersion = "23.05";
}
