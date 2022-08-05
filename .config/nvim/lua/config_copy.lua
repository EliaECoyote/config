-- Stamp (del & replace with yanked text)
vim.keymap.set(
  'n',
  '<C-s>',
  '"_diwP',
  { noremap = true, silent = true }
)

-- Yanked text to-clipboard shortcut
vim.keymap.set(
  { 'n', 'v' },
  'Y',
  '"+y',
  { noremap = true, silent = true }
)

-- Yank current path to clipboard
vim.api.nvim_create_user_command(
  "CopyPath",
  ":let @+ = expand(\"%\")",
  {}
)
