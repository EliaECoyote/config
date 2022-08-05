local theme_utils = require("utils.theme_utils")

vim.api.nvim_command([[
  if has('termguicolors')
    set termguicolors
  endif
]])

-- Temporarily highlights yanked region after each yank
vim.api.nvim_command([[
 au TextYankPost * silent! lua vim.highlight.on_yank()
]])

-- Hides "-- INSERT --" from under to statusline
vim.api.nvim_command('set noshowmode')

-- Default indentation & font settings
vim.opt.smartindent = true
vim.api.nvim_command("filetype plugin indent on")

-- Use spaces instead of tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Case options
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- Enables text wrap
vim.opt.linebreak = true
vim.opt.wrap = true

-- Disables hard-wrap
vim.opt.textwidth = 0

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 72
  end,
  group = vim.api.nvim_create_augroup("CommitMsg", { clear = true }),
})

-- -- Lua function
-- local myluafun = function() print("This buffer enters") end

-- -- Vimscript function name (as a string)
-- local myvimfun = "g:MyVimFunction"

-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
-- pattern = {"*.c", "*.h"},
-- callback = myluafun,  -- Or myvimfun
-- })


-- Makes vimdiff easier to read
vim.opt.diffopt:append("vertical")

vim.opt.cursorline = true
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")

-- Highlights end-of-line
vim.opt.list = true
vim.opt.listchars = { space = " ", tab = "->", eol = "¬" }

vim.g.markdown_fenced_languages = {
  'html',
  'python',
  'lua',
  'vim',
  'typescript',
  'javascript'
}


local function setup_standard_highlight_groups()
  vim.api.nvim_set_hl(0, "LineNr", { fg = "#5eacd3" })
  vim.api.nvim_set_hl(0, "CursorLineNr", { bg = "none", fg = "#ff8533" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })

  -- Make bg transparent, to display the default terminal bg color
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })

  -- For LSP-related UI customzations, see
  -- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization

  -- Sets transparent bg for LSP floating windows.
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  -- Links LSP floating windows border color with telescope border color.
  vim.api.nvim_set_hl(0, "FloatBorder", { link = "TelescopeBorder" })
  -- Don't replace text color on diff view.
  theme_utils.extend_hi("DiffAdd", { fg = "none" });
  theme_utils.extend_hi("DiffChange", { fg = "none" });
  theme_utils.extend_hi("DiffDelete", { fg = "none" });
  theme_utils.extend_hi("DiffText", { fg = "none" });
end

local function setup_dark_theme()
  vim.g.gruvbox_material_background = "hard"
  vim.g.gruvbox_material_palette = "original"
  vim.api.nvim_command("colorscheme gruvbox-material")

  vim.api.nvim_set_hl(0, "CursorLine", { bg = "#4f4f4f" })
  vim.api.nvim_set_hl(0, "Visual", { bg = "#434f4e" })
  vim.api.nvim_set_hl(0, "NonText", { fg = "#4a4a4a", bg = "none" })
  vim.api.nvim_set_hl(0, "MatchParen", { bg = "#c90000" })

  -- Cusomize vimdiff colors
  vim.api.nvim_set_hl(0, "DiffAdd", { underline = 0, standout = 0, fg = "none", bg = "#23414f" })
  vim.api.nvim_set_hl(0, "DiffChange", { underline = 0, standout = 0, fg = "none", bg = "#383725" })
  vim.api.nvim_set_hl(0, "DiffDelete", { bold = 0, fg = "#3d2b28", bg = "#3d2b28" })
  vim.api.nvim_set_hl(0, "DiffText", { underline = 0, standout = 0, fg = "none", bg = "#454425" })
end

local function setup_light_theme()
  require('github-theme').setup({
    theme_style = "light",
  })
end

local background = theme_utils.get_background()
vim.api.nvim_set_option("background", background)

if (background == "light") then
  setup_light_theme()
else
  setup_dark_theme()
end
setup_standard_highlight_groups()

-- Enable floating window borders by default
local original_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return original_open_floating_preview(contents, syntax, opts, ...)
end

-- Enable window borders by default
-- (enables border for commands like `LspInfo`)
local win = require("lspconfig.ui.windows")
local _default_opts = win.default_opts
function win.default_opts(options)
  local opts = _default_opts(options)
  opts.border = "rounded"
  return opts
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
  -- Disable diagnostic icons in sign column
  signs = false,
}
)
