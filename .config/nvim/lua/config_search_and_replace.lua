vim.g.grepprg = "rg --vimgrep --smart-case"
vim.g.grepformat = "%f:%l:%c:%m,%f:%l:%m"

vim.keymap.set(
  "n",
  "<leader>c",
  ":let @/='\\<'.expand('<cword>').'\\>'<CR>cgn",
  {
    noremap = true,
    desc = "Change word under cursor, and enable repeat on next match through `.` by using `gn`.",
  })
vim.keymap.set(
  "v",
  "<leader>c",
  "\"sy:let @/=@s<CR>cgn",
  {
    noremap = true,
    desc = "Change visual selection, and enable repeat on next match through `.` by using `gn`.",
  }
)

vim.keymap.set(
  "n",
  "<leader>s",
  ":%s///gc<Left><Left><Left>",
  {
    noremap = true,
    desc = "Substitute last pattern."
  }
)
vim.keymap.set(
  "v",
  "<leader>s",
  "\"sy:%s/<C-r>s//<Left>",
  {
    noremap = true,
    desc = "Substitute pattern prepopulated with visual selection.",
  }
)

vim.keymap.set(
  "n",
  "<leader>S",
  ":cdo s///g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
  {
    noremap = true,
    desc = "(Quickfix list) Substitute pattern",
  }
)
vim.keymap.set(
  "v",
  "<leader>S",
  "\"sy:cdo s/<C-r>s//g | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>",
  {
    noremap = true,
    desc = "(Quickfix list) Substitute pattern prepopulated with visual selection.",
  }
)
