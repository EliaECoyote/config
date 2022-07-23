-- Lualine sections visualization:
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+

require("lualine").setup({
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"filename"},
    lualine_c = {
      {
        "diagnostics",
        sources = { "nvim_diagnostic" },
      },
      "require'lsp-status'.status()",
    },
    lualine_x = {"filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"},
  },
})
