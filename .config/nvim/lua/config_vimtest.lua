vim.g["test#strategy"] = "neovim"
-- Spawns neovim terminal in normal mode
vim.g["test#neovim#start_normal"] = 1
vim.g["test#neovim#term_position"] = "vert botright split"
vim.g["test#python#runner"] = "pytest"

vim.g["test#python#pytest#options"] = "--with-pylons $DATADOG_ROOT/dogweb/test.ini --doctest-modules --disable-warnings"

local function pytest_transform(cmd)
  return "HOST_TEST_RUNNER=1 LOAD_INTEGRATIONS=0 CREATE_DELANCIE_SCHEDULES=0 " .. cmd
end

vim.g['test#custom_transformations'] = { pytest_transform }
vim.g['test#transformation'] = 'pytest_transform'

vim.api.nvim_set_keymap("n", "<leader>tn", "<cmd>TestNearest<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>tl", "<cmd>TestLast<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>tf", "<cmd>TestFile<cr>", {})
vim.api.nvim_set_keymap("n", "<leader>tv", "<cmd>TestVisit<cr>", {})
