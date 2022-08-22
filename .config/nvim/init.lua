vim.g.mapleader = " "

-- Automatically save any changes made to the buffer before it is hidden
vim.g.autowrite = true

vim.g.undofile = true

-- Refresh file every time you access the buffer.
-- This is useful to sync buffer when it has changed on disk.
vim.cmd [[
  au FocusGained,BufEnter * :checktime
]]

-- Enable mouse visual selection
vim.g.mouse = "a"

-- Enables Vim per-project configuration files
vim.g.exrc = true

-- Prevents :autocmd, shell and write commands from being run
-- inside project-specific .vimrc files unless they’re owned by you.
vim.g.secure = true

require("plugins")
require("common_keymaps")
require("theme")
require("config_netrw")
require("config_lsp")
require("config_cmp")
require("config_telescope")
require("config_treesitter")
require("config_trouble")
require("config_vimtest")
require("config_lualine")
require("config_fugitive")
require("config_vim_tmux_navigator")
require("config_copy")
require("config_search_and_replace")
require("config_dressing")
require("config_sandwich")
require("config_folds")
require("config_nvim_colorizer")
