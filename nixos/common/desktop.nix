{ pkgs, ... }:

{
  # Desktop-specific settings
  hardware.bluetooth.enable = true;

  # X11 and display manager
  services.xserver = {
    enable = true;
    xkb.layout = "eu";
    xkb.variant = "";
    xkb.options = "";
  };

  services.displayManager.sddm = {
    enable = true;
    autoNumlock = true;
    wayland.enable = true;
  };

  services.desktopManager.plasma6.enable = true;

  console.useXkbConfig = true;

  # Printing & Scanning
  services = {
    printing.enable = true;
    avahi.enable = true;
    avahi.nssmdns4 = true;
    avahi.openFirewall = true;
    saned.enable = true;
  };

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      brscan4 = { enable = true; };
    };
  };

  # Fonts for desktop
  fonts.packages = with pkgs; [
    jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
  ];

  # Sound system
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Add desktop-specific user groups
  users.users.lev.extraGroups = [ "scanner" "lp" ];

  # Desktop-specific packages
  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse
  ];

  # iOS support
  services.usbmuxd.enable = true;

  # XDG portals for desktop integration
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  programs.kdeconnect.enable = true;

  # Note: Firewall is disabled here for desktop convenience.
  # Desktop machines typically operate on trusted home networks.
  # Override this in per-machine config if you need firewall enabled.
  networking.firewall.enable = false;
}
