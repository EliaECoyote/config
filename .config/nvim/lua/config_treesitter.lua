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
    -- Waiting for better treesitter indents for python:
    -- https://github.com/nvim-treesitter/nvim-treesitter/issues/1136
    disable = { "python" },
  },
})

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
