vim.o.completeopt = "menuone,noselect"

require"compe".setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "always",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
  },
}

local set_keymap = vim.api.nvim_set_keymap
local options = { expr = true, silent = true }

set_keymap("n", "<C-Space>", "compe#complete()", options)
set_keymap("n", "<cr>", "compe#confirm('<cr>')", options)
set_keymap("n", "<C-e>", "compe#close('<C-e>')", options)
set_keymap("n", "<C-f>", "compe#scroll({ 'delta': +4 })", options)
set_keymap("n", "<C-d>", "compe#scroll({ 'delta': -4 })", options)
