vim.api.nvim_command([[
  if has('termguicolors')
    set termguicolors
  endif
]])

vim.api.nvim_set_option("background", "dark")

-- `:h gruvbox-material.txt` for more details

-- Sets contrast
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_palette = "original"
vim.api.nvim_command("colorscheme gruvbox-material")

-- Soft line wrap
vim.api.nvim_command("set linebreak wrap tw=0")
-- Makes vimdiff easier to read
vim.api.nvim_command("set diffopt+=algorithm:patience")
vim.api.nvim_command("set diffopt+=vertical")
-- set diffopt+=indent-heuristic
vim.api.nvim_command("set cursorline")
vim.api.nvim_command("set relativenumber")
vim.api.nvim_command("set number")
vim.api.nvim_command("set updatetime=300")
vim.api.nvim_command("set shortmess+=c")

vim.api.nvim_command("hi LineNr guifg=#5eacd3")
vim.api.nvim_command("hi CursorLine guibg=#4f4f4f")
vim.api.nvim_command("hi CursorLineNr guibg=none guifg=#ff8533")
vim.api.nvim_command("hi Visual guibg=#434f4e")
vim.api.nvim_command("hi MatchParen guibg=#c90000")
-- Use default terminal bg colors
vim.api.nvim_command("hi SignColumn guibg=none")
vim.api.nvim_command("hi NonText guibg=none")
vim.api.nvim_command("hi EndOfBuffer guibg=none")
-- Use default terminal bg color
vim.api.nvim_command("hi Normal guibg=none")
-- Cusomize vimdiff colors
vim.api.nvim_command("hi DiffAdd      gui=none    guifg=none          guibg=#23414f")
vim.api.nvim_command("hi DiffChange   gui=none    guifg=none          guibg=#383725")
vim.api.nvim_command("hi DiffDelete   gui=none    guifg=#3d2b28       guibg=#3d2b28")
vim.api.nvim_command("hi DiffText     gui=none    guifg=none          guibg=#454425")

-- cf. https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
-- Sets transparent bg for LSP floating windows.
vim.api.nvim_command("hi NormalFloat guibg=none")
-- Links LSP floating windows border color with telescope border color.
vim.api.nvim_command("hi link FloatBorder TelescopeBorder")

local win = require('lspconfig.ui.windows')
local _default_opts = win.default_opts

win.default_opts = function(options)
  local opts = _default_opts(options)
  opts.border = 'single'
  return opts
end

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = "rounded" }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = "rounded" }
)

