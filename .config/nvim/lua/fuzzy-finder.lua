local map = vim.api.nvim_set_keymap

map("n", "<leader>p", ":Telescope find_files<cr>", {})
map("n", "<leader>ff", ":Telescope live_grep<cr>", {})
map("n", "<leader>o", ":Telescope buffers<cr>", {})
map("n", "<leader>ft", ":Telescope help_tags<cr>", {})
