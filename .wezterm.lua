local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.term = "wezterm"
config.set_environment_variables = {
  SHELL = "/bin/bash"
}

config.enable_tab_bar = false

config.font = wezterm.font_with_fallback({
  "FiraMono Nerd Font Mono",
  "Cousine Nerd Font Mono",
  "GoMono Nerd Font Mono",
  "3270 Nerd Font Mono",
  "Monaco",
  "JetBrainsMono Nerd Font Mono",
  "Agave Nerd Font Mono",
})
config.font_size = 22

config.colors = {
  foreground = "#000000",
  background = "#fcfcf2",
  cursor_bg = "#000000",
  cursor_fg = "#ffffff",
  ansi = {
    "#000000",
    "#d73a49",
    "#5f8700",
    "#999900",
    "#005faf",
    "#b200b2",
    "#0087af",
    "#e5e5e5",
  },
  brights = {
    "#666666",
    "#d54e53",
    "#00b800",
    "#e5e500",
    "#005faf",
    "#e500e5",
    "#0087af",
    "#ffffff",
  },
}

return config
