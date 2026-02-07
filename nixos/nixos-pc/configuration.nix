{ pkgs, ... }:

{
  imports = [
    ../common/base.nix
    ../common/desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "nixos-pc";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ intel-media-driver intel-vaapi-driver mesa libvdpau-va-gl ];
  };

  # Ollama for local LLM
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    environmentVariables = { OLLAMA_HOST = "0.0.0.0"; };
    acceleration = "rocm";
  };

  # Partition Manager
  programs.partition-manager.enable = true;

  # ROCm configuration
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  system.stateVersion = "23.05";
}

