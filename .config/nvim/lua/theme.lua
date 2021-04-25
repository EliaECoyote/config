vim.api.nvim_command([[
  if has('termguicolors')
    set termguicolors
  endif
]])

vim.api.nvim_set_option("background", "dark")

-- `:h gruvbox-material.txt` for more details
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_palette = "original"
vim.api.nvim_command("colorscheme gruvbox-material")


-- Use default terminal bg color
vim.api.nvim_command("hi Normal guibg=none")
-- Set line-number fg colors
vim.api.nvim_command("hi LineNr guifg=#5eacd3")
vim.api.nvim_command("hi CursorLineNr guifg=#ff8533")
-- Use default terminal bg colors
vim.api.nvim_command("hi SignColumn guibg=none")
vim.api.nvim_command("hi NonText guibg=none")
vim.api.nvim_command("hi EndOfBuffer guibg=none")


-- Soft line wrap
vim.api.nvim_command("set linebreak wrap tw=0")
-- Cusomize vimdiff colors
vim.api.nvim_command("hi DiffAdd      gui=none    guifg=NONE          guibg=#23414f")
vim.api.nvim_command("hi DiffChange   gui=none    guifg=NONE          guibg=#383725")
vim.api.nvim_command("hi DiffDelete   gui=none    guifg=#3d2b28       guibg=#3d2b28")
vim.api.nvim_command("hi DiffText     gui=none    guifg=NONE          guibg=#454425")

-- Makes vimdiff easier to read
vim.api.nvim_command("set diffopt+=algorithm:patience")
vim.api.nvim_command("set diffopt+=vertical")
-- set diffopt+=indent-heuristic

vim.api.nvim_command("set cursorline")
vim.api.nvim_command("set relativenumber")
vim.api.nvim_command("set number")
vim.api.nvim_command("set updatetime=300")
vim.api.nvim_command("set shortmess+=c")
