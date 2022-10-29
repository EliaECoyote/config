local toggleterm = require("toggleterm")
local Terminal   = require("toggleterm.terminal").Terminal

toggleterm.setup({
  open_mapping = "<c-\\>",
  -- direction = "horizontal",
  direction = "float",
  float_opts = {
    border = "rounded"
  },
  env = { VIM_SHELL = false }
})

local function set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", "<C-\\><C-n>", opts)
  -- vim.keymap.set('t', '<C-h>', "<Cmd>wincmd h<CR>", opts)
  -- vim.keymap.set('t', '<C-j>', "<Cmd>wincmd j<CR>", opts)
  -- vim.keymap.set('t', '<C-k>', "<Cmd>wincmd k<CR>", opts)
  -- vim.keymap.set('t', '<C-l>', "<Cmd>wincmd l<CR>", opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "term://*",
  callback = function()
    set_terminal_keymaps()
    vim.opt_local.textwidth = 72
  end,
  group = vim.api.nvim_create_augroup("TermSetup", { clear = true }),
})

vim.keymap.set(
  "n",
  "<c-\\>",
  "<Cmd>exe v:count1 . \"ToggleTerm\"<CR>",
  { noremap = true, silent = true }
)

local lazygit = Terminal:new({
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "rounded",
    width = vim.o.columns,
    height = 100,
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function(_)
    vim.cmd("startinsert!")
  end,
})

vim.keymap.set(
  "n",
  "<leader>g",
  function() lazygit:toggle() end,
  { noremap = true, silent = true }
)
