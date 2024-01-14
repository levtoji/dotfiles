# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, config, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.systemd-boot.configurationLimit = 5;
  time.hardwareClockInLocalTime = true;

  networking.hostName = "nixos-pc";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    powerManagement.enable = false;
  };

  services.xserver.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver.desktopManager.plasma5.enable = true;
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [ oxygen khelpcenter konsole ];

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];

  services.saned = {
    enable = true;
    extraConfig = ''
      10.0.0.0/24
    '';
  };

  services.xserver = {
    layout = "eu";
    xkbVariant = "";
  };

  services.printing.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.lev = {
    isNormalUser = true;
    description = "Lev Perschin";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" ];
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = with pkgs; [
    git
    eza
    helix
    htop
    killall
    wget
    xclip

    # iOS
    libimobiledevice
    ifuse
  ];

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  programs.partition-manager.enable = true;

  services.usbmuxd.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "22.11";
}
