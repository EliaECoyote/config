local utils_buffer = require("lib.utils_buffer")

vim.keymap.set(
  "",
  "<ScrollWheelUp>",
  "<C-Y>",
  {
    silent = true,
    desc = "Smooth mouse wheel scroll."
  }
)
vim.keymap.set(
  "",
  "<ScrollWheelDown>",
  "<C-E>",
  {
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
    silent = true,
    desc = "Tab new."
  }
)

vim.keymap.set(
  "n",
  "td",
  ":tabclose<cr>",
  {
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
  ":lua vim.print()<left>",
  {
    noremap = true,
    silent = false,
    desc = "Log with lua."
  }
)

vim.keymap.set("n", "<C-f>", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
vim.keymap.set("n", "gs", vim.lsp.buf.signature_help)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol)
vim.keymap.set("n", "<F2>", vim.lsp.buf.rename)
vim.keymap.set("n", "]g", vim.diagnostic.goto_next)
vim.keymap.set("n", "[g", vim.diagnostic.goto_prev)
