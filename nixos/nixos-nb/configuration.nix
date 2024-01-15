{ pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
  time.hardwareClockInLocalTime = true;

  networking.hostName = "nixos-nb";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  nixpkgs.config.allowUnfree = true;

  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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
    layout = "eu";
    xkbVariant = "";
    xkbOptions = "";

    displayManager.sddm.enable = true;
    displayManager.sddm.autoNumlock = true;
    desktopManager.plasma5.enable = true;
  };

  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;

  console.useXkbConfig = true;

  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  services.avahi.openFirewall = true;

  hardware = {
    sane = {
      enable = true;
      extraBackends = [ pkgs.sane-airscan ];
      brscan4 = { enable = true; };
    };
  };

  powerManagement.enable = true;

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

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
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "docker" ];
  };

  environment.systemPackages = with pkgs; [
    jetbrains-mono
    zellij
    wget
    eza
    helix
    wl-clipboard
    nil
    nixfmt
    appimage-run

    # iOS
    libimobiledevice
    ifuse
  ];

  nix.settings = {
    keep-outputs = true;
    keep-derivations = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  networking.firewall.enable = false;

  services = {
    # iOS Thethering
    usbmuxd.enable = true;
    # Enable the OpenSSH daemon.
    openssh.enable = true;
    # Bigger runtime directory space because of build errors
    logind.extraConfig = "RuntimeDirectorySize=4G";
  };
  system.stateVersion = "23.05";
}
