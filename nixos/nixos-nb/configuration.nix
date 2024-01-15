{ pkgs, ... }:

{
  imports = [ ../common/common.nix ./hardware-configuration.nix ];

  networking.hostName = "nixos-nb";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  powerManagement.enable = true;

  system.stateVersion = "23.05";
}
