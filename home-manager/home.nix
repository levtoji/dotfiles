{pkgs, ...}: let
  editor = "hx";
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
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
    };
  };

  home = {
    username = "lev";
    homeDirectory = "/home/lev";
    stateVersion = "23.11";

    sessionVariables = {
      EDITOR = editor;
      BROWSER = "brave";
      TERMINAL = "wezterm";
    };

    shellAliases = {
      ls = "exa";
      zl = "zellij";
      zlf = "zellij --layout ~/.config/zellij/layouts/first.kdl";
      htop = "btm -b";
      hms = "home-manager switch";
      home = "${editor} ~/.config/home-manager/home.nix";
      nix-conf = "sudoedit /etc/nixos/configuration.nix";
      nix-bs = "sudo nixos-rebuild --upgrade switch";
      memory = "${editor} ~/Notes/";
    };

    packages = with pkgs; [
      appimage-run
      ardour
      audacity
      bandwhich
      bat
      blender
      bottom
      brave
      broot
      deno
      du-dust
      eza
      f3d
      fd
      freecad
      gimp
      godot_4
      gitui
      helix
      just
      kitty
      libreoffice-fresh
      libsForQt5.kcalc
      libsForQt5.kdenlive
      mediainfo
      megasync
      nixd
      nil
      nixfmt
      ouch
      # oterm
      ripgrep
      rustup
      signal-desktop
      spotify
      steam
      tealdeer
      telegram-desktop
      thunderbird
      tokei
      vlc
      vscode
      wezterm
      zellij
      zoom-us
      wl-clipboard

      (pkgs.discord-canary.override {withVencord = true;})
    ];

    file = {
      ".config/zellij/layouts/first.kdl".text = ''
        layout {
            pane split_direction="vertical" {
                pane
                pane
            }
            pane size=1 borderless=true {
                plugin location="zellij:compact-bar"
            }
        }
      '';

      ".config/zellij/config.kdl".source = ./zellij/config.kdl;

      ".config/helix/config.toml".text = ''
        theme = "doom_acario_dark"

        [editor]
        bufferline = "always"

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
      '';

      ".config/helix/languages.toml".text = ''
        [[language]]
        name = "javascript"
        formatter = { command = 'deno', args = ["fmt", "-", "--ext", "js" ] }
        auto-format = true

        [[language]]
        name = "json"
        formatter = { command = 'deno', args = ["fmt", "-", "--ext", "json" ] }

        [[language]]
        name = "markdown"
        formatter = { command = 'deno', args = ["fmt", "-", "--ext", "md" ] }
        auto-format = true

        [[language]]
        name = "typescript"
        formatter = { command = 'deno', args = ["fmt", "-", "--ext", "ts" ] }
        auto-format = true

        [[language]]
        name = "jsx"
        formatter = { command = 'deno', args = ["fmt", "-", "--ext", "jsx" ] }
        auto-format = true

        [[language]]
        name = "tsx"
        formatter = { command = 'deno', args = ["fmt", "-", "--ext", "tsx" ] }
        auto-format = true

        [[language]]
        name = "nix"
        formatter = { command = 'nixfmt', args = ["-w", "100"] }
        auto-format = true
      '';

      ".config/kitty/kitty.conf".text = ''
        font_size 13.0
        font_family JetBrains Mono
        include theme.conf
      '';

      ".config/kitty/theme.conf".source = ./kitty/theme.conf;

      ".wezterm.lua".text = ''
        local wezterm = require 'wezterm'
        local config = {}

        if wezterm.config_builder then
          config = wezterm.config_builder()
        end

        config.color_scheme = "lovelace"
        config.font_size = 13.0
        config.hide_tab_bar_if_only_one_tab = true
        config.warn_about_missing_glyphs = false

        return config
      '';
    };
  };

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    starship.enable = true;
    bash.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      userName = "Lev Perschin";
      userEmail = "lev@perschin.net";
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
