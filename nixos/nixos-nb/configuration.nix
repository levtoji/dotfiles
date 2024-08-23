{ inputs, ... }:

{
  imports = [ ../common/common.nix ./hardware-configuration.nix ];

  networking.hostName = "nixos-nb";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # For better wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  powerManagement.enable = true;

  system.stateVersion = "23.05";
}
