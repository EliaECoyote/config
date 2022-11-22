local utils_table = require("lib.utils_table")
local utils_buffer = require("lib.utils_buffer")


vim.keymap.set(
  "n",
  "0",
  "getline('.')[0 : col('.') - 2] =~# '^\\s\\+$' ? '0' : '^'",
  {
    noremap = true,
    silent = true,
    expr = true,
    desc = "Toggle between col 0 and first char."
  }
)

vim.keymap.set(
  "",
  "<ScrollWheelUp>",
  "<C-Y>",
  {
    noremap = true,
    silent = true,
    desc = "Smooth mouse wheel scroll."
  }
)
vim.keymap.set(
  "",
  "<ScrollWheelDown>",
  "<C-E>",
  {
    noremap = true,
    silent = true,
    desc = "Smooth mouse wheel scroll."
  }
)

-- Tabs mappings
vim.keymap.set(
  "n",
  "tn",
  ":tabnew<cr>",
  {
    noremap = true,
    silent = true,
    desc = "Tab new."
  }
)

vim.keymap.set(
  "n",
  "td",
  ":tabclose<cr>",
  {
    noremap = true,
    silent = true,
    desc = "Tab close."
  }
)

local VOCALS_ACCENTS = {
  a = "à",
  A = "À",
  e = "è",
  E = "È",
  i = "ì",
  I = "Ì",
  o = "ò",
  O = "Ò",
  u = "ù",
  U = "Ù",
}

-- Emulate backtick dead-key for accents
for key, value in pairs(VOCALS_ACCENTS) do
  vim.keymap.set(
    "i",
    "<A-`>" .. key,
    value,
    { noremap = true, silent = true, desc = "Type accent " .. value .. " char" }
  )
end

vim.keymap.set(
  "n",
  "<leader>bo",
  function()
    local invalid_count, deleted_count = utils_buffer
        .delete_other_buffers({ force = true, unload = true }, false)
    if invalid_count > 0 then
      print("⚠️ : " .. invalid_count .. " buffers are in modified state")
    else
      print(deleted_count .. " buffers deleted")
    end
  end,
  {
    noremap = true,
    silent = true,
    desc = "Delete other buffers."
  }
)
vim.keymap.set(
  "n",
  "<leader>bd",
  function()
    if utils_buffer.delete_buffer(0, { force = true, unload = true }, false) then
      print("Current buffer deleted")
    else
      print("⚠️ : Current buffer is in modified state")
    end
  end,
  {
    noremap = true,
    silent = true,
    desc = "Delete current buffer."
  }
)
vim.keymap.set(
  "n",
  "<leader>bD",
  function()
    if utils_buffer.delete_buffer(0, { force = true, unload = true }, true) then
      print("Current buffer deleted")
    else
      print("⚠️ : Something went wrong - cannot force delete the buffer")
    end
  end,
  {
    noremap = true,
    silent = true,
    desc = "Force delete current buffer."
  }
)

vim.keymap.set(
  "i",
  "<C-r>",
  "<C-r><C-o>",
  { noremap = true, desc = "Insert contents of named register. Inserts text literally, not as if you typed it." }
)

-- Move in quickfix
vim.keymap.set(
  "n",
  "[q",
  ":cprevious<cr>",
  { noremap = true, desc = "Prev quickfix." }
)
vim.keymap.set(
  "n",
  "]q",
  ":cnext<cr>",
  { noremap = true, desc = "Next quickfix." }
)

-- Search for visually selected text using '*' and '#'
-- https://vim.fandom.com/wiki/Search_for_visually_selected_text#Simple
vim.cmd([[
  vnoremap <silent> * :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gVzv:call setreg('"', old_reg, old_regtype)<CR>
  vnoremap <silent> # :<C-U>
    \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    \gVzv:call setreg('"', old_reg, old_regtype)<CR>
]])

vim.keymap.set(
  "n",
  "yo",
  function()
    vim.cmd("%y+")
  end,
  {
    noremap = true,
    silent = true,
    desc = "Copy buffer to clipboard.",
  }
)

-- Prepare to print lua code
vim.keymap.set(
  "n",
  "<leader>l",
  ":lua vim.pretty_print()<left>",
  {
    noremap = true,
    silent = false,
    desc = "Log with lua."
  }
)
