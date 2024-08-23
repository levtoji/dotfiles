{ pkgs, inputs, ... }:
let
  editor = "hx";
  config-path = "~/dotfiles";
  font-size = "14.0";
  theme-light = false;
in {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    inputs.nix-colors.homeManagerModule

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
      home = "${editor} ${config-path}/home-manager/$(whoami)/home.nix";
      hms = "home-manager switch --flake ${config-path}/#$(whoami)";
      nix-conf = "${editor} ${config-path}/nixos/$(hostname)/configuration.nix";
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
      brave
      broot
      csharpier
      clang-tools
      deno
      du-dust
      eza
      f3d
      fd
      freecad
      gh-dash
      gimp
      gitoxide
      gitui
      godot_4
      jabref
      just
      kdePackages.kcalc
      kdePackages.kdenlive
      kdePackages.kmag
      # kdePackages.neochat
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
      # oterm
      ouch
      ripgrep
      ruff
      ruff-lsp
      pyright
      rustup
      signal-desktop
      slack
      spotify
      steam
      tealdeer
      telegram-desktop
      thunderbird
      taplo
      tokei
      uv
      vlc
      vscode
      wezterm
      wl-clipboard
      yazi
      zellij
      zoom-us
      zoxide

      (with dotnetCorePackages; combinePackages [ sdk_6_0 sdk_7_0 sdk_8_0 ])
      (pkgs.discord-canary.override { withVencord = true; })
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
        theme = "${if theme-light then "cyan_light" else "dark_plus"}"

        [editor]
        bufferline = "always"
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

      # ".config/helix/languages.toml".text = ''
      #   [language-server]
      #   biome = { command = "biome", args = ["lsp-proxy"] }

      #   [[language]]
      #   name = "javascript"
      #   language-servers = [ "biome" ]
      #   auto-format = true

      #   [[language]]
      #   name = "typescript"
      #   language-servers = [ "biome" ]
      #   auto-format = true

      #   [[language]]
      #   name = "tsx"
      #   auto-format = true
      #   language-servers = [ "biome" ]

      #   [[language]]
      #   name = "jsx"
      #   auto-format = true
      #   language-servers = [ "biome" ]

      #   [[language]]
      #   name = "json"
      #   language-servers = [ "biome" ]        

      #   # [[language]]
      #   # name = "markdown"
      #   # formatter = { command = 'deno', args = ["fmt", "-", "--ext", "md" ] }
      #   # auto-format = true

      #   # [[language]]
      #   # name = "nix"
      #   # formatter = { command = 'nixfmt', args = ["-w", "100"] }
      #   # auto-format = true
      # '';

      ".config/kitty/kitty.conf".text = ''
        font_size ${font-size}
        font_family JetBrains Mono
        include theme.conf
      '';

      ".config/kitty/theme.conf".source =
        if theme-light then ./kitty/theme-light.conf else ./kitty/theme-dark.conf;

      # ".wezterm.lua".text = ''
      #   local wezterm = require 'wezterm'
      #   local config = {}

      #   if wezterm.config_builder then
      #     config = wezterm.config_builder()
      #   end

      #   config.color_scheme = "${
      #     if theme-light then "Vs Code Light+ (Gogh)" else "Vs Code Dark+ (Gogh)"
      #   }"
      #   config.font_size = ${font-size}
      #   config.hide_tab_bar_if_only_one_tab = true
      #   config.warn_about_missing_glyphs = false

      #   return config
      # '';
    };
  };

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    starship.enable = true;
    bash.enable = true;
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };

    # git = {
    #   enable = true;
    #   lfs.enable = true;
    #   userName = "Lev Perschin";
    #   userEmail = "lev@perschin.net";
    # };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
