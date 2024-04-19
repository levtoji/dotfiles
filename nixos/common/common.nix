{ inputs, outputs, lib, config, pkgs, ... }: {

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.helix-master.overlays.default

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    config.allowUnfree = true;
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; }))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };
  time.hardwareClockInLocalTime = true;

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

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

  # --- Printing & Scanning
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

  # Patched font for icons in terminal
  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  # --- System sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- Users
  users.users.lev = {
    isNormalUser = true;
    description = "Lev Perschin";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "docker" ];
  };

  # --- System packages
  environment.systemPackages = with pkgs; [

    eza
    git
    helix
    bottom
    killall
    wget
    wl-clipboard
    zellij

    # iOS
    libimobiledevice
    ifuse
  ];

  # Disable firewall
  networking.firewall.enable = false;

  # --- Extra services
  # Docker
  virtualisation.docker.enable = true;
  # iOS Thethering
  services.usbmuxd.enable = true;
  # Local LLM
  services.ollama = { enable = true; };
  # Bigger runtime directory space because of build errors
  services.logind.extraConfig = "RuntimeDirectorySize=4G";
  # SSD trim
  services.fstrim.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  programs = {
    ssh.startAgent = true;
    git.config = { url = { "git@github.com:" = { insteadOf = [ "https://github.com/" ]; }; }; };
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };
}
