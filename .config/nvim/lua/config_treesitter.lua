local configs = require("nvim-treesitter.configs")

configs.setup({
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
    disable = function(_, bufnr)
      return vim.api.nvim_buf_line_count(bufnr) > 5000
    end,
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
