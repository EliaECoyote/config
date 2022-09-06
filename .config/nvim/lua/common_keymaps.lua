local table_utils = require("utils.table_utils")
local buffer_utils = require("utils.buffer_utils")

local default_options = { noremap = true, silent = true }

vim.keymap.set(
  "n",
  "0",
  "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'",
  table_utils.merge(default_options, { expr = true })
)

-- Vifm mappings
vim.keymap.set(
  "n",
  "-",
  ":Vifm<cr>",
  default_options
)

-- Enables smoother scroll
vim.keymap.set(
  "",
  "<ScrollWheelUp>",
  "<C-Y>",
  default_options
)
vim.keymap.set(
  "",
  "<ScrollWheelDown>",
  "<C-E>",
  default_options
)

-- Reload vim config file
vim.keymap.set(
  "n",
  "<leader>s",
  ":source %<cr>",
  { noremap = true, silent = false }
)

-- Tabs mappings
vim.keymap.set(
  "n",
  "tn",
  ":tabnew<cr>",
  { noremap = true, silent = true }
)

vim.keymap.set(
  "n",
  "td",
  ":tabclose<cr>",
  { noremap = true, silent = true }
)

-- Buffers mappings
vim.keymap.set(
  "n",
  "<leader>bo",
  function()
    local invalid_count, deleted_count = buffer_utils
        .delete_other_buffers({ force = true, unload = true }, false)
    if invalid_count > 0 then
      print("⚠️ : " .. invalid_count .. " buffers are in modified state")
    else
      print(deleted_count .. " buffers deleted")
    end
  end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>bd",
  function()
    if buffer_utils.delete_buffer(0, { force = true, unload = true }, false) then
      print("Current buffer deleted")
    else
      print("⚠️ : Current buffer is in modified state")
    end
  end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "<leader>bD",
  function()
    if buffer_utils.delete_buffer(0, { force = true, unload = true }, true) then
      print("Current buffer deleted")
    else
      print("⚠️ : Something went wrong - cannot force delete the buffer")
    end
  end,
  { noremap = true, silent = true }
)

-- Copy all
vim.keymap.set(
  "n",
  "yo",
  function()
    vim.cmd("%y+")
  end,
  { noremap = true, silent = true }
)

-- Prepare to print lua code
vim.keymap.set(
  "n",
  "<leader>l",
  ":lua vim.pretty_print()<left>",
  { noremap = true, silent = false }
)
