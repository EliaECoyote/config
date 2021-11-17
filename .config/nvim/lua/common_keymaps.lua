local table_utils = require  "utils.table_utils"
local set_keymap = vim.api.nvim_set_keymap

local options = {noremap = true, silent = true}
set_keymap('n', '0',
           "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'",
           table_utils.merge(options, {expr = true}))
