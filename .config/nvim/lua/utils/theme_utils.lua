local theme_utils = {}

function theme_utils.get_background()
  local theme = os.getenv("THEME")
  if (theme == nil or (theme ~= "dark" and theme ~= "light")) then
    return "dark"
  end
  return theme
end

return theme_utils
