local theme_utils = {}

function theme_utils.get_background()
  local theme = os.getenv("THEME")
  if (theme == nil or (theme ~= "dark" and theme ~= "light")) then
    return "dark"
  end
  return theme
end

function theme_utils.extend_hi(group, new_config)
  local hl = vim.api.nvim_get_hl_by_name(group, true)
  vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, new_config))
end

return theme_utils
