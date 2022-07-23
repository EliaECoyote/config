local table_utils = require("utils.table_utils")

local default_options = { noremap = true, silent = true }

vim.api.nvim_set_keymap(
  "n",
  "0",
  "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'",
  table_utils.merge(default_options, {expr = true})
)

-- Vifm mappings
vim.api.nvim_set_keymap(
  "n",
  "-",
  ":Vifm<cr>",
 default_options
)

-- Enables smoother scroll
vim.api.nvim_set_keymap(
  "",
  "<ScrollWheelUp>",
  "<C-Y>",
  default_options
)
vim.api.nvim_set_keymap(
  "",
  "<ScrollWheelDown>",
  "<C-E>",
  default_options
)
