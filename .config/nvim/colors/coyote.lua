local utils_theme = require("lib.utils_theme")

vim.g.colors_name = "coyote"

-- See :h cterm-colors
utils_theme.setup_theme(
  {
    base00 = "White",
    base01 = "LightGrey",
    base02 = "LightGrey",
    base03 = "DarkGrey",
    base04 = "Black",
    base05 = "Black",
    base06 = "Red",
    base07 = "Yellow",
    base08 = "Black",
    base09 = "DarkMagenta",
    base0A = "DarkCyan",
    base0B = "DarkGreen",
    base0C = "Blue",
    base0D = "Blue",
    base0E = "Magenta",
    base0F = "Red",
  },
  {
    info_fg = "DarkCyan",
    success = "LightGreen",
    success_fg = "Green",
    warn = "LightYellow",
    warn_fg = "DarkYellow",
    error = "LightRed",
    error_fg = "Red",
  }
)

local hi_overrides = {
  StatusLine = { fg = "White", bg = "Black" },
  MatchParen = { bg = "Magenta" },
  Whitespace = { fg = "LightGrey" },
  ["@text.reference"] = { fg = "Cyan" }
}

for name, value in pairs(hi_overrides) do
  value.ctermfg = value.ctermfg or value.fg
  value.ctermbg = value.ctermbg or value.bg
  vim.api.nvim_set_hl(0, name, value)
end
