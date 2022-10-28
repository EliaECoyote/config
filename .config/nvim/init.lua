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

require("common_keymaps")
require("config_theme")
require("config_netrw")
require("config_folds")
require("config_copy")
require("config_search_and_replace")
require("plugins")
