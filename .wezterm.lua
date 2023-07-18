local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.term = "wezterm"
config.set_environment_variables = {
  SHELL = "/bin/bash"
}

config.enable_tab_bar = false

config.font = wezterm.font_with_fallback({
  "Inconsolata Nerd Font Mono",
  "Monaco",
})
config.font_size = 22

config.colors = {
  foreground = "#000000",
  background = "#fcfcf2",
  cursor_bg = "#000000",
  cursor_fg = "#ffffff",
  ansi = {
    "black",
    "maroon",
    "green",
    "olive",
    "navy",
    "purple",
    "teal",
    "silver",
  },
  brights = {
    "#666666",
    "red",
    "#00b800",
    "#e5e500",
    "blue",
    "fuchsia",
    "#0087af",
    "white",
  },
}

return config
