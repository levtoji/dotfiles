{ pkgs, ... }:

{
  imports = [
    ../common/base.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-hs";

  # --- Server-specific settings ---

  # Hardware graphics without desktop environment
  hardware.graphics = {
    enable = true;
  };

  # Enable firewall for server security
  networking.firewall = {
    enable = true;
    # Example: Open ports for common services
    # allowedTCPPorts = [ 80 443 22 ];
    # allowedUDPPorts = [ ];
  };

  # --- Optional server services ---

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

  # --- Additional server packages ---
  environment.systemPackages = with pkgs; [
    htop
    tmux
  ];

  system.stateVersion = "23.05";
}
