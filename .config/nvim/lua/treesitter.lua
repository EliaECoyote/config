local configs = require("nvim-treesitter.configs")

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
  indent = { enable = true },
})
