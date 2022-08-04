vim.g["test#strategy"] = "neovim"
-- Spawns neovim terminal in normal mode
vim.g["test#neovim#start_normal"] = 1
vim.g["test#neovim#term_position"] = "vert botright split"
vim.g["test#python#runner"] = "pytest"
vim.g["test#javascript#runner"] = "jest"
vim.g["test#javascript#jest#executable"] = "yarn test:unit"
vim.g["test#javascript#jest#file_pattern"] = "\\v(__tests__/.*|(spec|test|unit))\\.(js|jsx|coffee|ts|tsx)$"

-- Make it work with dogweb
vim.g["test#python#pytest#options"] = "--with-pylons $DATADOG_ROOT/dogweb/test.ini --doctest-modules --disable-warnings"

local function pytest_transform(cmd)
  return "HOST_TEST_RUNNER=1 LOAD_INTEGRATIONS=0 CREATE_DELANCIE_SCHEDULES=0 " .. cmd
end

vim.g['test#custom_transformations'] = { pytest_transform }
vim.g['test#transformation'] = 'pytest_transform'

vim.keymap.set("n", "<leader>tn", "<cmd>TestNearest<cr>", {})
vim.keymap.set("n", "<leader>tl", "<cmd>TestLast<cr>", {})
vim.keymap.set("n", "<leader>tf", "<cmd>TestFile<cr>", {})
vim.keymap.set("n", "<leader>tv", "<cmd>TestVisit<cr>", {})
