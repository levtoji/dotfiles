{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  # Server-specific packages (minimal, server-oriented tools)
  home.packages = with pkgs; [
    # Server monitoring and management
    bandwhich
    mediainfo
    tmux

    # Development tools for server maintenance
    deno
    nodePackages.typescript
    rustup
    uv
  ];

  # Minimal helix config for server
  home.file = {
    ".config/helix/config.toml".text = ''
      theme = "amberwood"

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
  };
}
