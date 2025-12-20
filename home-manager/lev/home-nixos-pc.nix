{ pkgs, ... }:
let
  font-size = "12.0";
  light-theme = false;
in {
  imports = [ ./common.nix ];

  # PC-specific packages (desktop workstation with heavy applications)
  home.packages = with pkgs; [
    # GPU and system monitoring
    amdgpu_top
    bandwhich
    mediainfo

    # Development environments
    appimage-run
    clang-tools
    csharpier
    deno
    nodePackages.prettier
    nodePackages.typescript
    nodePackages.typescript-language-server
    rustup
    taplo
    texlab
    typst
    uv

    # Creative and media applications
    ardour
    audacity
    gimp
    kdePackages.kdenlive
    mpv
    vlc

    # Office and productivity
    firefox
    libreoffice-fresh
    signal-desktop
    slack
    spotify
    telegram-desktop
    thunderbird
    vscode
    whatsapp-for-linux
    zoom-us

    # Desktop utilities
    kdePackages.kcalc
    kdePackages.kmag
    localsend
    steam
    wezterm

    # Custom packages
    (pkgs.discord-canary.override { withVencord = true; })
  ];

  home.file = {
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
}
