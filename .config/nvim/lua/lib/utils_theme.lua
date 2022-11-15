local utils_theme = {}

function utils_theme.get_background()
  local theme = os.getenv("THEME")
  if (theme == nil or (theme ~= "dark" and theme ~= "light")) then
    return "light"
  end
  return theme
end

function utils_theme.extend_hi(group, new_config)
  local hl = vim.api.nvim_get_hl_by_name(group, true)
  vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, new_config))
end

return utils_theme
