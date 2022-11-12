vim.g.mapleader = " "
vim.opt.autoindent = true
vim.opt.cursorline = true
vim.opt.number = true
vim.wo.signcolumn = "yes"

vim.opt.list = true
-- vim.opt.listchars:append "space:⋅"
vim.opt.listchars:append "eol:↴"

vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

vim.cmd[[colorscheme tokyonight-night]]

require "paq" {
  "savq/paq-nvim";
  -- LSP
  "neovim/nvim-lspconfig";
  -- Rust
  "simrat39/rust-tools.nvim";
  -- Autocomplete
  "hrsh7th/cmp-nvim-lsp";
  "hrsh7th/cmp-buffer";
  "hrsh7th/cmp-path";
  "hrsh7th/cmp-cmdline";
  "hrsh7th/nvim-cmp";
  "glepnir/lspsaga.nvim";
  -- Snippets
  "hrsh7th/cmp-vsnip";
  "hrsh7th/vim-vsnip";
  -- Commenting
  "numToStr/Comment.nvim";
  -- Debugging
  "nvim-lua/plenary.nvim";
  "mfussenegger/nvim-dap";
  -- Leap
  -- "ggandor/leap.nvim";
  -- Telescope
  "BurntSushi/ripgrep";
  "nvim-treesitter/nvim-treesitter";
  "nvim-telescope/telescope.nvim";
  "nvim-telescope/telescope-file-browser.nvim";

  "folke/which-key.nvim";
  -- Colorscheme
  "folke/tokyonight.nvim";
  -- Tabbar
  "kyazdani42/nvim-web-devicons";
  "romgrk/barbar.nvim";
  -- Statusbar
  "nvim-lualine/lualine.nvim";
  -- Reopen files
  "ethanholz/nvim-lastplace";
  -- Blankline
  "lukas-reineke/indent-blankline.nvim";
  -- Autopairs
  "windwp/nvim-autopairs";
  -- Cursorline
  "yamatsum/nvim-cursorline";
  -- Format
  "lukas-reineke/lsp-format.nvim";
  -- Git
  "lewis6991/gitsigns.nvim";
  -- Surround
  "kylechui/nvim-surround";

}

require('Comment').setup()
-- require('leap').add_default_mappings()
require('lualine').setup()
require("nvim-autopairs").setup {}
require('gitsigns').setup()
require("lsp-format").setup {}
require("nvim-surround").setup()
require("lspconfig").gopls.setup { on_attach = require("lsp-format").on_attach }

require("indent_blankline").setup {
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
}

require('nvim-cursorline').setup {
  cursorline = {
    enable = true,
    timeout = 1000,
    number = false,
  },
  cursorword = {
    enable = true,
    min_length = 3,
    hl = { underline = true },
  }
}

require'nvim-lastplace'.setup {
  lastplace_ignore_buftype = {"quickfix", "nofile", "help"},
  lastplace_ignore_filetype = {"gitcommit", "gitrebase", "svn", "hgcommit"},
  lastplace_open_folds = true
}

require("telescope").setup {
  extensions = {
    file_browser = {
      -- disables netrw and use telescope-file-browser in its place
      hijack_netrw = true,
      mappings = {
        ["i"] = {
          -- your custom insert mode mappings
        },
        ["n"] = {
          -- your custom normal mode mappings
        },
      },
    },
  },
}
require("telescope").load_extension("file_browser")

require("which-key").setup{} 

local rt = require("rust-tools")

rt.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
})

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "rust", "markdown" },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    },
  }

  local cmp = require'cmp'
  cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
    }, {
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    capabilities = capabilities
  }

  local keymap = vim.keymap.set
  local saga = require('lspsaga')

  saga.init_lsp_saga({
    symbol_in_winbar = {
      in_custom = true
    }
  })

  -- Lsp finder find the symbol definition implement reference
  -- if there is no implement it will hide
  -- when you use action in finder like open vsplit then you can
  -- use <C-t> to jump back
  keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { silent = true })

  -- Code action
  keymap({"n","v"}, "<leader>ca", "<cmd>Lspsaga code_action<CR>", { silent = true })

  -- Rename
  keymap("n", "gr", "<cmd>Lspsaga rename<CR>", { silent = true })

  -- Peek Definition
  -- you can edit the definition file in this flaotwindow
  -- also support open/vsplit/etc operation check definition_action_keys
  -- support tagstack C-t jump back
  keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>", { silent = true })

  -- Show line diagnostics
  keymap("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { silent = true })

  -- Show cursor diagnostic
  keymap("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { silent = true })

  -- Diagnsotic jump can use `<c-o>` to jump back
  keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { silent = true })
  keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", { silent = true })

  -- Only jump to error
  keymap("n", "[E", function()
    require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, { silent = true })
  keymap("n", "]E", function()
    require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, { silent = true })

  -- Outline
  keymap("n","<leader>o", "<cmd>LSoutlineToggle<CR>",{ silent = true })

  -- Hover Doc
  keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>", { silent = true })

  -- Float terminal
  keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
  -- if you want pass somc cli command into terminal you can do like this
  -- open lazygit in lspsaga float terminal
  keymap("n", "<A-d>", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
  -- close floaterm
  keymap("t", "<A-d>", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })

  local map = vim.api.nvim_set_keymap
  local opts = { noremap = true, silent = true }

  -- Move to previous/next
  map('n', '<A-,>', '<Cmd>BufferPrevious<CR>', opts)
  map('n', '<A-.>', '<Cmd>BufferNext<CR>', opts)
  -- Re-order to previous/next
  map('n', '<A-<>', '<Cmd>BufferMovePrevious<CR>', opts)
  map('n', '<A->>', '<Cmd>BufferMoveNext<CR>', opts)
  -- Goto buffer in position...
  map('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
  map('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
  map('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
  map('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
  map('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
  map('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
  map('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
  map('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
  map('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
  map('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
  -- Pin/unpin buffer
  map('n', '<A-p>', '<Cmd>BufferPin<CR>', opts)
  -- Close buffer
  map('n', '<A-c>', '<Cmd>BufferClose<CR>', opts)
  -- Wipeout buffer
  --                 :BufferWipeout
  -- Close commands
  --                 :BufferCloseAllButCurrent
  --                 :BufferCloseAllButPinned
  --                 :BufferCloseAllButCurrentOrPinned
  --                 :BufferCloseBuffersLeft
  --                 :BufferCloseBuffersRight
  -- Magic buffer-picking mode
  map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
  -- Sort automatically by...
  map('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
  map('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
  map('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
  map('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)

  -- Personal Keybindings
  vim.keymap.set("n", "<Leader>sv", ":source $MYVIMRC<CR>")
  vim.keymap.set('n', '<Leader>w', ':write<CR>')
  vim.keymap.set('n', '<Leader>q', ':q<CR>')
  vim.keymap.set("n", "<Leader>pi", ":PaqInstall<CR>")
  vim.keymap.set("n", "<Leader>pc", ":PaqClean<CR>")
  vim.keymap.set("n", "<Leader>F", ":Telescope file_browser hidden=true<CR>")
  vim.keymap.set("n", "<Leader>t", ":Telescope<CR>")
  vim.keymap.set("n", "<Leader>en", ":e ~/.config/nvim/init.lua<CR>")

