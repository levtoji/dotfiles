{ ... }:

{
  imports = [
    ../common/base.nix
    ../common/desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-nb";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Better Wayland support for notebook
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  powerManagement.enable = true;

  system.stateVersion = "23.05";
}

