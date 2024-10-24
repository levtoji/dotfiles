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
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      mesa.drivers
      libvdpau-va-gl
    ];
  };

  # Open Webui
  # services.open-webui.enable = true;
  # Ollama
  services.ollama.enable = true;
  # Partition Manager
  programs.partition-manager.enable = true;
  # Flag for better wayland support
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "23.05";
}
