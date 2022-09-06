local utils_window = {}

-- let signlist = split(signs, '\n')
-- let foldColumnWidth = (&foldcolumn ? &foldcolumn : 0)
-- let numberColumnWidth = &number ? strwidth(line('$')) : 0
-- let signColumnWidth = len(signlist) >= 2 ? 2 : 0
-- let width = winwidth(0) - foldColumnWidth - numberColumnWidth - signColumnWidth
function utils_window.get_text_width(win)
  local width = vim.api.nvim_win_get_width(win)
  local number_width = vim.api.nvim_win_get_option(win, "numberwidth")
  local fold_column = vim.api.nvim_win_get_option(win, "foldcolumn")
  -- local signColumnWidth = 0
  -- local foo = vim.api.nvim_exec [[
  --   redir => signs | exe "silent sign place buffer=".bufnr('') | redir end
  --   return signs
  -- ]]
  --
local foo = vim.api.nvim_exec([[
  function! F()
    redir => signs | exe "sign place buffer=".bufnr('') | redir end
    print signs
    return signs
  endfunction!
]], true)
-- vim.pretty_print("Test", foo)

    -- local signlist = split(signs, '\n')
    -- local signColumnWidth = len(signlist) >= 2 ? 2 : 0
  width = width - number_width - fold_column
  return width
end

-- local foo
-- return signs
return utils_window
