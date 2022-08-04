-- Lualine sections visualization:
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+

require("lualine").setup({
  options = {
    component_separators = '',
    section_separators = '',
    refresh = {
      statusline = 200,
    },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "filename" },
    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
      },
      "require'lsp-status'.status()",
    },
    lualine_x = {},
    lualine_y = { "filetype" },
    lualine_z = { "location" },
  },
})
