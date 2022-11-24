local utils_theme = require("lib.utils_theme")

vim.api.nvim_command([[
  if has("termguicolors")
    set termguicolors
  endif
]])

-- Temporarily highlights yanked region after each yank
vim.api.nvim_command([[
 au TextYankPost * silent! lua vim.highlight.on_yank()
]])

-- Hides "-- INSERT --" from under to statusline
vim.api.nvim_command("set noshowmode")

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
  "html",
  "python",
  "lua",
  "vim",
  "typescript",
  "javascript",
}

local THEMES = {
  github_light = {
    base00 = "#ffffff", base01 = "#f5f5f5", base02 = "#c8c8fa", base03 = "#969896",
    base04 = "#e8e8e8", base05 = "#333333", base06 = "#ffffff", base07 = "#ffffff",
    base08 = "#ed6a43", base09 = "#0086b3", base0A = "#795da3", base0B = "#183691",
    base0C = "#183691", base0D = "#795da3", base0E = "#a71d5d", base0F = "#333333",
  },
  papercolor_light = {
    base00 = "#ffffff", base01 = "#eeeeee", base02 = "#bcbcbc", base03 = "#878787",
    base04 = "#0087af", base05 = "#000000", base06 = "#005f87", base07 = "#444444",
    base08 = "#8700af", base09 = "#d70000", base0A = "#d70087", base0B = "#5f8700",
    base0C = "#d75f00", base0D = "#d75f00", base0E = "#005faf", base0F = "#005f87",
  },
  coyote = {
    base00 = "#ffffff", base01 = "#eeeeee", base02 = "#bcbcbc", base03 = "#878787",
    base04 = "#0087af", base05 = "#000000", base06 = "#005f87", base07 = "#444444",
    base08 = "#000000", base09 = "#d70000", base0A = "#005faf", base0B = "#5f8700",
    base0C = "#005f87", base0D = "#00425e", base0E = "#d70087", base0F = "#005f87",
  },
  google_light = {
    base00 = "#ffffff", base01 = "#e0e0e0", base02 = "#c5c8c6", base03 = "#b4b7b4",
    base04 = "#969896", base05 = "#373b41", base06 = "#282a2e", base07 = "#1d1f21",
    base08 = "#CC342B", base09 = "#F96A38", base0A = "#FBA922", base0B = "#198844",
    base0C = "#3971ED", base0D = "#3971ED", base0E = "#A36AC7", base0F = "#3971ED",
  },
  one_light = {
    base00 = "#fafafa", base01 = "#f0f0f1", base02 = "#e5e5e6", base03 = "#a0a1a7",
    base04 = "#696c77", base05 = "#383a42", base06 = "#202227", base07 = "#090a0b",
    base08 = "#ca1243", base09 = "#d75f00", base0A = "#c18401", base0B = "#50a14f",
    base0C = "#0184bc", base0D = "#4078f2", base0E = "#a626a4", base0F = "#986801",
  }
}

-- local function setup_dark_theme()
--   -- Cusomize vimdiff colors
--   vim.api.nvim_set_hl(0, "DiffAdd", { underline = 0, standout = 0, bg = "#23414f" })
--   vim.api.nvim_set_hl(0, "DiffChange", { underline = 0, standout = 0, bg = "#383725" })
--   vim.api.nvim_set_hl(0, "DiffDelete", { bold = 0, fg = "#3d2b28", bg = "#3d2b28" })
--   vim.api.nvim_set_hl(0, "DiffText", { underline = 0, standout = 0, bg = "#454425" })
-- end

vim.api.nvim_set_option("background", "light")

utils_theme.setup_theme(THEMES.coyote)

-- For LSP-related UI customzations, see
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization

vim.diagnostic.config({ signs = false, float = { border = "rounded" } })

-- Override all LSP floating windows borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
