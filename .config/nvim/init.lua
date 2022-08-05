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
require("netrw")
require("theme")
require("lsp")
require("auto_completion")
require("telescope_setup")
require("treesitter")
require("trouble_setup")
require("config_vimtest")
require("config_lualine")
require("config_fugitive")
require("config_vim_tmux_navigator")
require("config_copy")
require("config_search_and_replace")
require("config_dressing")
require("config_sandwich")
require("config_folds")
