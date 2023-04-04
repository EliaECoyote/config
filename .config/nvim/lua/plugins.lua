-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Adds comments with `gc`
    "tpope/vim-commentary",
    -- Handy bracket mappings
    {
      "tpope/vim-unimpaired",
      init = function()
        vim.g.nremap = {
          ['yo<Esc>'] = '',
          ['>p'] = ''
        }
      end
    },
    -- Git wrapper
    {
      "tpope/vim-fugitive",
      init = function()
        -- Map keys to move between Gstatus files
        vim.g.nremap = {
          [")"] = "<Tab>",
          ["("] = "<S-Tab>",
        }
      end
    },
    {
      "mattn/emmet-vim",
      init = function()
        vim.g.user_emmet_leader_key = "<C-,>"
      end
    },
    -- Loads editorconfig files
    "editorconfig/editorconfig-vim",
    -- Makes gx cmd work for urls and files
    "stsewd/gx-extended.vim",
    -- LSP goodies
    {
      "neovim/nvim-lspconfig",
      dependencies = { "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim" },
      config = function()
        local constants_lsp = require("lib.constants_lsp")
        require("mason").setup({
          ui = { border = "rounded" },
        })
        require("mason-lspconfig").setup({
          ensure_installed = constants_lsp.LSP_SERVERS
        })
        require("config_lsp")
      end
    },
    {
      "jose-elias-alvarez/null-ls.nvim",
      config = function() require("config_null_ls") end
    },
    -- Explorer
    {
      "vifm/vifm.vim",
      init = function()
        vim.keymap.set(
          "n",
          "<leader>fb",
          ":Vifm<cr>",
          {
            silent = true,
            desc = "Start Vifm on local buffer path"
          }
        )
      end
    },
    {
      "lewis6991/gitsigns.nvim",
      name = "gitsigns",
      opts = {
        signcolumn = false,
        numhl      = true,
        on_attach  = function(bufnr)
          local gs = package.loaded.gitsigns
          -- Navigation
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, { buffer = bufnr, expr = true })
          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, { buffer = bufnr, expr = true })
        end
      },
    },
    {
      'nvim-treesitter/nvim-treesitter',
      build = ":TSUpdate",
      config = function() require("config_treesitter") end
    },
    {
      "j-hui/fidget.nvim",
      name = "fidget",
      opts = { text = { spinner = "dots" }, }
    },
    {
      "machakann/vim-sandwich",
      config = function() require("config_sandwich") end
    },
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-fzf-native.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim",
        "nvim-tree/nvim-web-devicons",
      },
      config = function() require("config_telescope") end
    },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
    {
      "stevearc/dressing.nvim",
      opts = {
        input = {
          win_options = {
            winblend = 0,
          },
        },
        select = {
          -- Priority list of preferred vim.select implementations
          backend = { "telescope", "builtin" },
          -- Options for telescope selector
          -- These are passed into the telescope picker directly. Can be used like:
          -- telescope = require('telescope.themes').get_ivy({...})
          telescope = nil,
        },
      }
    },
    -- Autocompletion engine / sources / snippets.
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        -- Neovim Lua apis autocomplete.
        "hrsh7th/cmp-nvim-lua",
        -- LuaSnip integration.
        "saadparwaiz1/cmp_luasnip",
        -- Snippet engine
        "L3MON4D3/LuaSnip",
        -- Snippets library
        "rafamadriz/friendly-snippets",
      },
      config = function() require("config_cmp") end
    },
    -- Open current line on github
    "ruanyl/vim-gh-line",
    {
      "vim-test/vim-test",
      config = function() require("config_vimtest") end
    },
    {
      "mfussenegger/nvim-dap",
      config = function() require("config_dap") end
    },
  },
  {
    defaults = { lazy = false },
    ui = { border = "rounded" }
  })
