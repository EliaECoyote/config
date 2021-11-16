vim.api.nvim_set_option("completeopt", "menuone,noselect")

require"compe".setup  {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "always",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = true,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = true,
  },
}

local set_keymap = vim.api.nvim_set_keymap
local options = {expr = true, silent = true}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col(".") - 1
  if col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end
_G.tab_complete = function()
  if vim.fn.call("vsnip#available", {1}) == 1 then
    return t  "<plug>(vsnip-expand-or-jump)"
  elseif check_back_space() then
    return t  "<tab>"
  else
    return vim.fn["compe#complete"]()
  end
end
_G.s_tab_complete = function()
  if vim.fn.call("vsnip#jumpable", {-1}) == 1 then
    return t  "<Plug>(vsnip-jump-prev)"
  else
    return t  "<s-tab>"
  end
end
_G.completion_confirm = function()
  print("test" .. vim.fn.pumvisible())
  if vim.fn.pumvisible() ~= 0 then
    if vim.fn.complete_info()["selected"] ~= -1 then
      vim.fn["compe#confirm"]()
      print(vim.fn.complete_info()["selected"])
      return vim.fn["compe#complete"]()
    else
      vim.api.nvim_select_popupmenu_item(0, false, false, {})
      return vim.fn["compe#confirm"]()
    end
  else
    return t  "<cr>"
  end
end

set_keymap("i", "<cr>", "v:lua.completion_confirm()", options)
set_keymap("i", "<Tab>", "v:lua.tab_complete()", options)
set_keymap("s", "<Tab>", "v:lua.tab_complete()", options)
set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", options)
set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", options)
