require('dressing').setup({
  input = {
    win_options = {
      winblend = 0,
    },
  },
  select = {
    -- Priority list of preferred vim.select implementations
    backend = { "telescope", "builtin" },

    -- Options for telescope selector
    -- These are passed into the telescope picker directly. Can be used like:
    -- telescope = require('telescope.themes').get_ivy({...})
    telescope = nil,
  },
})
