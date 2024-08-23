# This file defines overlays
{ inputs, ... }: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  modifications = final: prev:
    {
      # example = prev.example.overrideAttrs (oldAttrs: rec {
      # ...
      # 
      # sd-switch = final.callPackage ({ fetchFromSourcehut, rustPlatform, }:
      #   let version = "0.4.0";
      #   in rustPlatform.buildRustPackage {
      #     pname = "sd-switch";
      #     inherit version;

      #     src = fetchFromSourcehut {
      #       owner = "~rycee";
      #       repo = "sd-switch";
      #       rev = version;
      #       hash = "sha256-PPFYH34HAD/vC+9jpA1iPQRVNR6MX8ncSPC+7bl2oHY=";
      #     };

      #     cargoHash = "sha256-zUoa7nPNFvnYekbEZwtnJKZ6qd47Sb4LZGEkaKVQ9ZQ=";
      #   }) { };
    };

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
