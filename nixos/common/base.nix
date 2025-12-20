{ inputs, outputs, lib, config, pkgs, ... }:

{
  # Core Nix settings
  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages
      inputs.helix-master.overlays.default
    ];
    config.allowUnfree = true;
  };

  # Nix flake configuration
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; }))
    ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc = lib.mapAttrs' (name: value: {
    name = "nix/path/${name}";
    value.source = value.flake;
  }) config.nix.registry;

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

  # Boot configuration
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 10;
    };
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot/efi";
  };

  time.hardwareClockInLocalTime = true;

  # Networking
  networking.networkmanager.enable = true;

  # Time and locale
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

  # Users
  users.users.lev = {
    isNormalUser = true;
    description = "Lev Perschin";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
  };

  # Core system packages (minimal set for all machines)
  environment.systemPackages = with pkgs; [
    eza
    git
    helix
    bottom
    killall
    wget
    wl-clipboard
    zellij
  ];

  # Core services
  virtualisation.docker.enable = true;
  services.fstrim.enable = true;
  services.logind.extraConfig = "RuntimeDirectorySize=4G";

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  programs = {
    ssh.startAgent = true;
    git.config = {
      url = {
        "git@github.com:" = {
          insteadOf = [ "https://github.com/" ];
        };
      };
    };
  };

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      fuse3
      icu
      nss
      openssl
      curl
      expat
    ];
  };
}
