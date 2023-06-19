-- Temporarily highlights yanked region after each yank
vim.api.nvim_command([[
 au TextYankPost * silent! lua vim.highlight.on_yank()
]])

vim.go.background = "light"
vim.cmd.colorscheme("coyote")

-- Global statusline
vim.opt.laststatus = 3

-- Default indentation & font settings
vim.opt.smartindent = true
vim.api.nvim_command("filetype plugin indent on")

-- Always display signcolumn with width 1
vim.opt.signcolumn = "yes:1"

vim.opt.conceallevel = 2

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

-- Unfold by default
vim.opt.foldenable = false

vim.api.nvim_create_autocmd("FileType", {
  pattern = "gitcommit",
  callback = function()
    vim.opt_local.textwidth = 72
    vim.opt_local.colorcolumn = "+1"
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
vim.opt.listchars = { tab = "▶ ", trail = "•", precedes = "<", extends = ">" }

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
vim.diagnostic.config({
  float = { source = "always", border = "rounded" },
  virtual_text = false,
})

-- Override all LSP floating windows borders
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

function _G.custom_status_line()
  local file_name = "%-.16t"
  local modified = "%-m"
  local file_type = "%y"
  local space_middle = "%="
  local col_row = "[%c:%l]"

  local counts = { 0, 0, 0, 0 }
  for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
    counts[diagnostic.severity] = counts[diagnostic.severity] + 1
  end

  local lsp_segment = ''
  local severity_labels = { 'Error', 'Warn', 'Info', 'Hint' }
  for severity_index, count in ipairs(counts) do
    if count > 0 then
      local type = severity_labels[severity_index]
      lsp_segment = string.format(
        '%s%%#StatusLineLsp%s# %d%s ',
        lsp_segment,
        type,
        count,
        type:sub(0, 1)
      )
    end
  end

  return string.format(
    "%s %s %s %%#StatusLine# %s %s %s",
    file_name,
    modified,
    lsp_segment,
    space_middle,
    file_type,
    col_row
  )
end

vim.opt.statusline = "%!v:lua.custom_status_line()"
