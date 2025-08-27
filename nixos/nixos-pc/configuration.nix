{ pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    ../common/common.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-pc";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver intel-vaapi-driver mesa libvdpau-va-gl ];
  };

  # Ollama
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    environmentVariables = { OLLAMA_HOST = "0.0.0.0"; };
    acceleration = "rocm";
  };
  # Partition Manager
  programs.partition-manager.enable = true;
  # Flag for better wayland support
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";

  systemd.tmpfiles.rules =
    [ "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}" ];

  system.stateVersion = "23.05";
}
