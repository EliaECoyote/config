local string = require("string")
-- Press * to search for the term under the cursor or a visual selection and
-- then press a key below to replace all instances of it in the current file.

vim.keymap.set(
  "n",
  "<Leader>r",
  ":%s///gc<Left><Left><Left>",
  { noremap = true, silent = true }
)

-- After searching for text, press this mapping to do a project wide find and
-- replace. It's similar to <leader>r except this one applies to all matches
-- across all files instead of just the current file.
vim.keymap.set(
  "n",
  "<Leader>R",
  [[
      \ :let @s='\<'.expand('<cword>').'\>'<CR>
      \ :Grepper -cword -noprompt<CR>
      \ :cfdo %s/<C-r>s//g \| update
      \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
  ]],
  { noremap = true, silent = true }
)

-- The same as above except it works with a visual selection.
vim.keymap.set(
  "v",
  "<Leader>R",
  [[
      \ "sy
      \ gvgr
      \ :cfdo %s/<C-r>s//g \| update
      \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
  ]],
  { noremap = true, silent = true }
)

-- Get the range of the current visual selection.
-- The range start with 1 and the ending is inclusive.
-- local function visual_selection_range()
--   local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
--   local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))

--   local start_row, start_col, end_row, end_col

--   if csrow < cerow or (csrow == cerow and cscol <= cecol) then
--     start_row = csrow
--     start_col = cscol
--     end_row = cerow
--     end_col = cecol
--   else
--     start_row = cerow
--     start_col = cecol
--     end_row = csrow
--     end_col = cscol
--   end

--   return start_row, start_col, end_row, end_col
-- end

-- Does not handle rectangular selection
local function get_visual_selection_content()
  local _, row_start, col_start, _ = unpack(vim.fn.getpos("'<"))
  local _, row_end, col_end, _ = unpack(vim.fn.getpos("'>"))
  local lines = vim.api.nvim_buf_get_lines(0, row_start - 1, row_end, false)
  local lines_length = #lines
  if lines_length > 0 then
    -- Strip down unselected content from last line
    -- print("stripping from " .. col_end)
    lines[lines_length] = string.sub(lines[lines_length], 1, col_end)
    -- Strip down unselected content from first line
    lines[1] = string.sub(lines[1], col_start)
  end
  vim.pretty_print(lines)
  return table.concat(lines, '\n')
end

-- Search visual selected text
vim.keymap.set(
  "v",
  "*",
  function()
    -- Go back to normal mode, in order to have the '< and '> marks
    -- available, and retrieve the visual selection content.
    vim.api.nvim_input("<esc>")
    local content = get_visual_selection_content()
    vim.pretty_print(content)
    -- vim.cmd([[\%s<cr>]], content)
    -- vim.fn.search(content)

    -- vim.cmd("/" .. content .. "<cr>")
    --
    -- vim.pretty_print("/" .. content .. "<cr>")
    -- vim.api.search(content)
    -- Try getpos...
    --
    -- - Gather selected text
    -- - Perform a search (e.g. with `/`) in the current file 
    -- - Move to the next occurrence
  end,
  { noremap = true, silent = false }
    -- :<C-U>
    --   \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
    --   \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
    --   \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
    --   \gVzv:call setreg('"', old_reg, old_regtype)<CR>
  -- ]],
)
