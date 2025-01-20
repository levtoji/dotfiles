{ pkgs, inputs, ... }:
let
  editor = "hx";
  config-path = "~/dotfiles";
  font-size = "12.0";
  light-theme = false;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
      # AMD Compute
      # rocmSupport = true;
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
      ls = "exa";
      zl = "zellij";
      zlf = "zellij --layout ~/.config/zellij/layouts/first.kdl";
      htop = "btm -b";
      home = "cd ~/dotfiles/ && ${editor} ${config-path}/home-manager/$(whoami)/home.nix";
      hms = "home-manager switch --flake ${config-path}/#$(whoami)";
      nix-conf = "cd ~/dotfiles/ && ${editor} ${config-path}/nixos/$(hostname)/configuration.nix";
      nix-bs = "sudo nixos-rebuild switch --flake ${config-path}#$(hostname)";
      memory = "${editor} ~/Notes/$(date +%Y%m%d)";
      zx = "yazi";
    };

    packages = with pkgs; [

      amdgpu_top
      appimage-run
      ardour
      audacity
      bandwhich
      bat
      biome
      blender
      bottom
      broot
      bambu-studio
      clang-tools
      csharpier
      deno
      du-dust
      eza
      f3d
      fd
      firefox
      freecad
      gh-dash
      gimp
      gitoxide
      gitui
      # godot_4
      jabref
      jetbrains.pycharm-professional
      # jetbrains-toolbox
      just
      kdePackages.kcalc
      kdePackages.kdenlive
      kdePackages.kmag
      libreoffice-fresh
      localsend
      mediainfo
      mono
      mpv
      nixd
      nixfmt-classic
      nodePackages.prettier
      nodePackages.typescript
      nodePackages.typescript-language-server
      ouch
      orca-slicer
      ripgrep
      rustup
      signal-desktop
      slack
      spotify
      steam
      taplo
      tealdeer
      telegram-desktop
      texlab
      thunderbird
      tokei
      typst
      uv
      vlc
      vscode
      wezterm
      whatsapp-for-linux
      wl-clipboard
      yazi
      zellij
      zoom-us
      zoxide

      (with dotnetCorePackages; combinePackages [ sdk_8_0 sdk_9_0 ])
      (pkgs.discord-canary.override { withVencord = true; })
    ];

    file = {
      ".config/zellij/layouts/first.kdl".text = "";

      ".config/zellij/config.kdl".source = ./zellij/config.kdl;

      ".config/helix/config.toml".text = ''
        theme = "${if light-theme then "cyan_light" else "amberwood"}"

        [editor]
        cursorline = true

        [editor.soft-wrap]
        enable = true
        max-wrap = 30

        [editor.cursor-shape]
        insert = "bar"
        normal = "block"

        [keys.normal]
        space = { W = ":w"}
        D = ["ensure_selections_forward", "extend_to_line_end"]
        esc = ["collapse_selection", "keep_primary_selection"]

        C-j = ["extend_to_line_bounds", "delete_selection", "paste_after"]
        C-k = ["extend_to_line_bounds", "delete_selection", "move_line_up", "paste_before"]
      '';

      ".wezterm.lua".text = ''
        local wezterm = require 'wezterm'
        local config = {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.color_scheme = "${
          if light-theme then "Vs Code Light+ (Gogh)" else "Vs Code Dark+ (Gogh)"
        }"
        config.font_size = ${font-size}
        config.hide_tab_bar_if_only_one_tab = true
        config.warn_about_missing_glyphs = false
        config.front_end = "WebGpu"

        return config
      '';
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
    brave.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
      userName = "Lev Perschin";
      userEmail = "lev@perschin.net";
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
