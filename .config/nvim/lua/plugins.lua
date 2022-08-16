local Plug = vim.fn["plug#"]

vim.call("plug#begin", "~/.vim/plugged")

-- Statusline
Plug("nvim-lualine/lualine.nvim")
-- Vimify UNIX shell commands
Plug("tpope/vim-eunuch")
-- Adds comments with `gc`
Plug("tpope/vim-commentary")
-- Heuristically set buffer options
Plug("tpope/vim-sleuth")
-- Async toolbox for plugins
Plug("tpope/vim-dispatch")
-- Loads editorconfig files
Plug("editorconfig/editorconfig-vim")
-- Handle text surround with quotes, tags, brackets
Plug("machakann/vim-sandwich")
-- Makes gx cmd work for urls and files 
Plug("stsewd/gx-extended.vim")
-- Integrate non LSP stuff with neovim LSP diagnostic, actions...
Plug("jose-elias-alvarez/null-ls.nvim")
-- Pretty LSP feedback
Plug("kyazdani42/nvim-web-devicons")
Plug("folke/trouble.nvim")
-- Install and manage LSP servers
Plug("williamboman/mason.nvim")
Plug("williamboman/mason-lspconfig.nvim")
-- LSP server configurations for various langs
Plug("neovim/nvim-lspconfig")
-- Autocompletion engine
Plug("hrsh7th/cmp-nvim-lsp")
Plug("hrsh7th/cmp-buffer")
Plug("hrsh7th/cmp-path")
Plug("hrsh7th/nvim-cmp")
-- Snippets
Plug("rafamadriz/friendly-snippets")
Plug("hrsh7th/cmp-vsnip")
Plug("hrsh7th/vim-vsnip")
Plug("hrsh7th/vim-vsnip-integ")
-- Display LSP status in statusline
Plug("nvim-lua/lsp-status.nvim")
-- Git management plugin
Plug("tpope/vim-fugitive")
-- Adds Tree explorer
Plug("vifm/vifm.vim")
-- Adds git diff markers on the left + hunks management
Plug("mhinz/vim-signify") -- Fuzzy finder
Plug("nvim-lua/popup.nvim")
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim")
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })
Plug("nvim-telescope/telescope-rg.nvim")
Plug("nvim-telescope/telescope-live-grep-args.nvim")
Plug("stevearc/dressing.nvim")
-- Treesitter!
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })
-- Navigate seamlessly between tmux and vim splits
Plug("christoomey/vim-tmux-navigator")
-- Open current line on github
Plug("ruanyl/vim-gh-line")
-- Test runner
Plug("vim-test/vim-test")
-- Debug client
Plug("mfussenegger/nvim-dap")
-- Themes
Plug("sainnhe/gruvbox-material")
Plug("projekt0n/github-nvim-theme")
-- Handle multi-file find and replace
Plug("mhinz/vim-grepper")
-- Highlight color codes
Plug("norcalli/nvim-colorizer.lua")

vim.call("plug#end")
