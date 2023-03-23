-- Temporarily highlights yanked region after each yank
vim.api.nvim_command([[
 au TextYankPost * silent! lua vim.highlight.on_yank()
]])

vim.go.background = "light"
vim.cmd.colorscheme("coyote")

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

-- Disable redundant messages from ins-completion-menu
vim.opt.shortmess:append("c")
-- Disable intro message
vim.opt.shortmess:append("I")


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
