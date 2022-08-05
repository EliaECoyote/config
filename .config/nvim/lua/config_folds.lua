-- Customize foldtext
vim.cmd [[
  source ~/.config/nvim/foldtext.vim
]]

-- Remap toggle fold
vim.keymap.set(
  "n",
  "<s-tab>",
  "zA",
  { noremap = true, silent = true }
)

-- Move between folds
vim.keymap.set(
  {"n", "v"},
  "[z",
  "zk",
  { noremap = true, silent = true }
)
vim.keymap.set(
  {"n", "v"},
  "]z",
  "zj",
  { noremap = true, silent = true }
)
