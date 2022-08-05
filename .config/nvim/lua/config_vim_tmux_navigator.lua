vim.g.tmux_navigator_no_mappings = 1

vim.keymap.set(
  'n',
  '<C-w>h',
  ':TmuxNavigateLeft<cr>',
  { noremap = true, silent = true }
)

vim.keymap.set(
  'n',
  '<C-w>j',
  ':TmuxNavigateDown<cr>',
  { noremap = true, silent = true }
)

vim.keymap.set(
  'n',
  '<C-w>k',
  ':TmuxNavigateUp<cr>',
  { noremap = true, silent = true }
)

vim.keymap.set(
  'n',
  '<C-w>l',
  ':TmuxNavigateRight<cr>',
  { noremap = true, silent = true }
)

vim.keymap.set(
  'n',
  '<C-w>\\',
  ':TmuxNavigatePrevious<cr>',
  { noremap = true, silent = true }
)
