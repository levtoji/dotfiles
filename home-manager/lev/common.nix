{ pkgs, ... }:
let
  editor = "hx";
  config-path = "~/dotfiles";
in {
  # Common settings for all machines
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "lev";
    homeDirectory = "/home/lev";
    stateVersion = "23.11";

    sessionVariables = {
      EDITOR = editor;
      BROWSER = "firefox";
      TERMINAL = "wezterm";
    };

    shellAliases = {
      ls = "eza";
      zl = "zellij";
      zlf = "zellij --layout ~/.config/zellij/layouts/first.kdl";
      htop = "btm -b";
      home = "cd ~/dotfiles/ && ${editor} ${config-path}/home-manager/$(whoami)/home-$(hostname).nix";
      hms = "home-manager switch --flake ${config-path}/#$(whoami)@$(hostname)";
      nix-conf = "cd ~/dotfiles/ && ${editor} ${config-path}/nixos/$(hostname)/configuration.nix";
      nix-bs = "sudo nixos-rebuild switch --flake ${config-path}#$(hostname)";
      memory = "${editor} ~/Notes/$(date +%Y%m%d)";
      zx = "yazi";
    };

    # Common packages for all machines
    packages = with pkgs; [
      # Core CLI tools
      bat
      bottom
      broot
      du-dust
      eza
      fd
      gitoxide
      gitui
      htop
      just
      ouch
      ripgrep
      tealdeer
      tokei
      wl-clipboard
      yazi
      zellij
      zoxide

      # Development tools
      gh-dash
      nixd
      nixfmt-classic
    ];

    file = {
      ".config/zellij/layouts/first.kdl".text = "";
      ".config/zellij/config.kdl".source = ./zellij/config.kdl;
    };
  };

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    starship.enable = true;
    bash.enable = true;
    bash.bashrcExtra = ''
      eval `ssh-agent`
      ssh-add ~/.ssh/id_rsa
    '';

    git = {
      enable = true;
      lfs.enable = true;
      userName = "Lev Perschin";
      userEmail = "lev@perschin.net";
    };
  };

  systemd.user.startServices = "sd-switch";
}
