{ pkgs, inputs, ... }: {

  imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";
    colorschemes.ayu.enable = true;

    plugins = {
      lightline.enable = true;
      lsp = {
        enable = true;
        servers = {
          tsserver.enable = true;
          rust-analyzer = {
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          # nixd.enable = true;
          omnisharp.enable = true;
        };
      };
      ollama.enable = true;
      cmp.enable = true;
      lsp-format.enable = true;
      lspsaga.enable = true;
      neogit.enable = true;
      neorg = {
        enable = true;
        modules = {
          "core.defaults" = { __empty = null; };
          "core.concealer" = { };
          "core.integrations.treesitter" = { };
        };
      };
      telescope.enable = true;
      treesitter.enable = true;
      barbar.enable = true;
      luasnip.enable = true;
      noice.enable = true;
      which-key.enable = true;
      mini = {
        enable = true;
        modules = {
          basics = { };
          ai = {
            n_lines = 50;
            search_method = "cover_or_next";
          };
          comment = { };
          surround = { };
          clue = { };
          jump = { };
          move = { };
          files = { };
          pairs = { };
          indentscope = { };
        };
      };
    };
    options = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
    };
    extraConfigLua = "";
    keymaps = [
      {
        mode = "n";
        key = "gn";
        action = "<cmd>BufferNext<CR>";
      }
      {
        mode = "n";
        key = "gN";
        action = "<cmd>BufferPrevious<CR>";
      }
      {
        mode = "n";
        key = "gd";
        action = "<cmd>Lspsaga goto_definition<CR>";
      }
      {
        mode = "n";
        key = "<leader>a";
        action = "<cmd>Lspsaga code_action<CR>";
      }
      {
        mode = "n";
        key = "<leader>rr";
        action = "<cmd>Lspsaga rename<CR>";
      }
      {
        mode = "n";
        key = "<leader>k";
        action = "<cmd>Lspsaga hover_doc<CR>";
      }
      {
        mode = "n";
        key = "<leader>K";
        action = "<cmd>Lspsaga peek_definition<CR>";
      }
      {
        mode = "n";
        key = "<leader>b";
        action = "<cmd>Telescope buffers<CR>";
      }
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>Telescope find_files<CR>";
      }
      {
        mode = "n";
        key = "<leader>d";
        action = "<cmd>Telescope diagnostics<CR>";
      }
      {
        mode = "n";
        key = "<leader>re";
        action = "<cmd>Telescope lsp_references<CR>";
      }
      {
        mode = "n";
        key = "<leader>s";
        action = "<cmd>Telescope lsp_document_symbols<CR>";
      }
      {
        mode = "n";
        key = "<leader>o";
        action = "<cmd>Telescope outline<CR>";
      }
      {
        mode = "i";
        key = "<cr>z";
        action = "<cmd>Telescope outline<CR>";
      }
    ];
  };
}
