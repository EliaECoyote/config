local configs = require  "nvim-treesitter.configs"

configs.setup  {
  ensure_installed = "maintained",
  -- highlight = {enable = true},
  -- TODO: enable treesitter indentation once it's more stable
  -- indent = {
  --   enable = true,
  -- },
}

vim.api.nvim_set_option("foldmethod", "expr")
vim.api.nvim_set_option("foldexpr", "nvim_treesitter#foldexpr()")
vim.api.nvim_set_option("foldlevel", 99)

