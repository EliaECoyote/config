local utils_window = require("lib.utils_window")
vim.g.foldlevel = 99
vim.g.foldmethod = "expr"
vim.g.foldexpr = "nvim_treesitter#foldexpr()"

-- Remap toggle fold
vim.keymap.set(
  "n",
  "<s-tab>",
  "zA",
  { noremap = true, silent = true }
)

-- Move between folds
vim.keymap.set(
  { "n", "v" },
  "[z",
  "zk",
  { noremap = true, silent = true }
)
vim.keymap.set(
  { "n", "v" },
  "]z",
  "zj",
  { noremap = true, silent = true }
)


---Renders like these:
-- »» TSString = {··} ········································ «« [ 223]····
-- »» Setup function ········································· «« [ 666]····
function _G.custom_fold_text()
  local foldstart = vim.v.foldstart
  local foldend = vim.v.foldend

  local prefix = "»» "
  local suffix = ""
  if type(foldstart) == "number" and type(foldend) == "number" then
    local line_count = vim.v.foldend - vim.v.foldstart + 1
    suffix = "«« [ " .. line_count .. "]"
  end

  local line_text = vim.fn.getline(vim.v.foldstart)
  local no_spaces_line_text = string.gsub(line_text, " *", "", 1)
  local trimmed_line_text = no_spaces_line_text

  local text_width = utils_window.get_text_width(0)
  if (text_width - #prefix - #suffix - #trimmed_line_text < 0) then
    -- vim.pretty_print({ text_width, #prefix, #suffix, 4 })
    trimmed_line_text = string.sub(line_text, 1, text_width - #prefix - #suffix - 4) .. "... "
  end

  local dot_char_count = text_width - #prefix - #suffix - #line_text
  local dots_text = string.rep("·", dot_char_count)

  return prefix .. trimmed_line_text .. dots_text .. suffix
end

vim.opt.foldtext = 'v:lua.custom_fold_text()'
