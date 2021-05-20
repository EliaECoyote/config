vim.api.nvim_set_option("completeopt", "menuone,noselect")

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
    nvim_lua = true,
    vsnip = true,
  },
}

local set_keymap = vim.api.nvim_set_keymap
local options = { expr = true, silent = true, noremap = true }

set_keymap("n", "<cr>", "compe#confirm('<cr>')", options)
