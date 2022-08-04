local configs = require  "nvim-treesitter.configs"

configs.setup({
  ensure_installed = {
    "lua",
    "javascript",
    "typescript",
    "jsdoc",
    "json",
    "css",
    "dockerfile",
    "java",
    "python",
    "yaml",
    "markdown",
  },
  highlight = { enable = true },
  -- TODO: enable treesitter indentation once it's more stable
  indent = { enable = true },
})

vim.g.foldmethod = "expr"
vim.g.foldexpr = "nvim_treesitter#foldexpr()"
vim.g.foldlevel = 99
