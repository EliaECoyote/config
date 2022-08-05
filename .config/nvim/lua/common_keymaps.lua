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
  "bo",
  function()
    local modified_count, deleted_count = buffer_utils.delete_other_buffers()
    if modified_count > 0 then
      print("⚠️ : " .. modified_count .. " buffers are in modified state")
    else
      print(deleted_count .. " buffers deleted")
    end
  end,
  { noremap = true, silent = true }
)
vim.keymap.set(
  "n",
  "bd",
  function()
      vim.api.nvim_buf_delete(0, {})
  end,
  { noremap = true, silent = true }
)




-- vim.api.nvim_buf_set_lines
-- function _G.copy_buffer()
--   local content = buffer_utils.buffer_to_string()
--   vim.api.nvim_del_keymap
--   vim.api. f
--  local content = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_buf_line_count(0), false)
--   return table.concat(content, "\n")
--   vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
-- end
-- -- Copy all
-- vim.api.nvim_set_keymap(
--   "n",
--   "yA",
--   ":lua copy_buffer()
--   )
