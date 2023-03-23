local utils_theme = require("lib.utils_theme")

-- Clear predefined colors or background
if vim.fn.exists("syntax_on") ~= 0 then
  vim.cmd("syntax reset")
end

-- See *:h cterm-colors*
utils_theme.setup_theme(
   {
     base00 = "White", base01 = "LightYellow", base02 = "LightYellow", base03 = "Grey",
       base04 = "LightGrey", base05 = "Black", base06 = "DarkCyan", base07 = "LightGrey",
     base08 = "Black", base09 = "DarkMagenta", base0A = "DarkCyan", base0B = "DarkGreen",
     base0C = "Blue", base0D = "Blue", base0E = "Magenta", base0F = "Red",
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
