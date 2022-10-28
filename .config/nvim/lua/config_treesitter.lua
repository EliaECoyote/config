local configs = require("nvim-treesitter.configs")

configs.setup({
  ensure_installed = "all",
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = {
      -- Waiting for better treesitter indents for python:
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
      "python",
    },
  },
})

vim.g.foldmethod = "expr"
vim.g.foldexpr = "nvim_treesitter#foldexpr()"
