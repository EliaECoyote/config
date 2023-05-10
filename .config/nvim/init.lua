-- Save undo history to a file stored in `:h undodir`
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

-- Prevent :autocmd, shell and write commands from being run
-- inside project-specific .vimrc files unless they’re owned by you.
vim.g.secure = true

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_netrwFileHandlers = 1

require("common_keymaps")
require("config_theme")
require("config_copy")
require("config_search_and_replace")
require("plugins")
