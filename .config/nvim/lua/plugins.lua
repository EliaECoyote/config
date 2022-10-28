-- Use a protected call to avoid crashes when packer isn't available.
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Read the `packer_plugins` table to see current status of plugins.
local function setup(use)
  use("wbthomason/packer.nvim")
  -- Adds comments with `gc`
  use("tpope/vim-commentary")
  -- Heuristically set buffer options
  use("tpope/vim-sleuth")
  -- Loads editorconfig files
  use("editorconfig/editorconfig-vim")
  -- Makes gx cmd work for urls and files
  use("stsewd/gx-extended.vim")
  -- Handle multi-file find and replace
  use("mhinz/vim-grepper")

  use({
    "tpope/vim-fugitive",
    config = function()
      require("config_fugitive")
    end
  })

  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("config_gitsigns")
    end
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    commit = "4cccb6f494eb255b32a290d37c35ca12584c74d0",
    run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
    config = function()
      require("config_treesitter")
    end
  })

  use({
    "nvim-lualine/lualine.nvim",
    requires = "nvim-lua/lsp-status.nvim",
    config = function()
      require("config_lualine")
    end,
  })

  use({
    "machakann/vim-sandwich",
    config = function()
      require("config_sandwich")
    end
  })

  use({
    "williamboman/mason.nvim",
    requires = "williamboman/mason-lspconfig.nvim",
    config = function()
      require("config_mason")
    end
  })

  use({
    "neovim/nvim-lspconfig",
    after = { "mason.nvim", "nvim-cmp" },
    requires = {
      "nvim-lua/lsp-status.nvim",
    },
    config = function()
      require("config_lsp")
    end
  })

  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("config_nvim_colorizer")
    end
  })

  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = "nvim-lua/lsp-status.nvim",
    config = function()
      require("config_null_ls")
    end
  })

  use({
    "nvim-telescope/telescope-fzf-native.nvim",
    run = "make",
  })


  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "kyazdani42/nvim-web-devicons",
    },
    config = function()
      require("config_telescope")
    end
  })

  use({
    "stevearc/dressing.nvim",
    config = function()
      require("config_dressing")
    end
  })

  -- Autocompletion engine / sources / snippets.
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
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
    config = function()
      require("config_cmp")
    end
  })

  -- LSP language-specific plugins
  use("mfussenegger/nvim-jdtls")

  -- Navigate seamlessly between tmux and vim splits
  use({
    "christoomey/vim-tmux-navigator",
    config = function()
      require("config_vim_tmux_navigator")
    end
  })

  -- Open current line on github
  use("ruanyl/vim-gh-line")

  use({
    "vim-test/vim-test",
    config = function()
      require("config_vimtest")
    end
  })

  use({
    "mfussenegger/nvim-dap",
    config = function()
      require("config_dap")
    end
  })

  use({
    "akinsho/toggleterm.nvim",
    tag = '*',
    config = function()
      require("config_toggleterm")
    end
  })

  -- Themes
  use({
    "projekt0n/github-nvim-theme",
    "sainnhe/gruvbox-material",
  })
end

packer.startup({
  setup,
  config = {
    ensure_dependencies = true,
    display = {
      open_fn = require("packer.util").float,
      prompt_border = "rounded",
    }
  }
})
