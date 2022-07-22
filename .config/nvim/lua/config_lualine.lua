-- Lualine sections visualization:
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+

require('lualine').setup({
  options = { theme = 'gruvbox' },
  sections =  {
    lualine_a = {'mode'},
    lualine_b = {'filename'},
    lualine_c = {
      "require'lsp-status'.status()",
      {
        'diagnostics',
        sources = { 'nvim_lsp', "nvim_diagnostic" },
      },
    },
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
  }
})
