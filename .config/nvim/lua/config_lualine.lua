-- Lualine sections visualization:
-- +-------------------------------------------------+
-- | A | B | C                             X | Y | Z |
-- +-------------------------------------------------+

local coyote_theme = {
  inactive = {
    a = {
      bg = "#F5F5F5",
      fg = "#4d4d4c"
    },
    b = {
      bg = "#F5F5F5",
      fg = "#4d4d4c"
    },
    c = {
      bg = "#F5F5F5",
      fg = "#4d4d4c"
    }
  },
  insert = {
    a = {
      bg = "#F5F5F5",
      fg = "#d70087"
    }
  },
  normal = {
    a = {
      bg = "#F5F5F5",
      fg = "#4d4d4c"
    },
    b = {
      bg = "#005f87",
      fg = "#ffffff"
    },
    c = {
      bg = "#F5F5F5",
      fg = "#4d4d4c"
    }
  },
  replace = {
    a = {
      bg = "#d7005f",
      fg = "#F5F5F5"
    }
  },
  visual = {
    a = {
      bg = "#5f8700",
      fg = "#F5F5F5"
    }
  }
}

require("lualine").setup({
  options = {
    theme = coyote_theme,
    component_separators = "",
    section_separators = "",
    refresh = {
      statusline = 200,
    },
    globalstatus = true,
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
