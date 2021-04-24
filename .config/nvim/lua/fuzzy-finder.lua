local builtin = require("telescope.builtin")

local map = vim.api.nvim_set_keymap

-- require('telescope').setup{
--   defaults = {
--     vimgrep_arguments = {
--       'rg',
--       '--color=never',
--       '--no-heading',
--       '--with-filename',
--       '--line-number',
--       '--column',
--       '--smart-case'
--     },
--     prompt_position = "bottom",
--     prompt_prefix = "> ",
--     selection_caret = "> ",
--     entry_prefix = "  ",
--     initial_mode = "insert",
--     selection_strategy = "reset",
--     sorting_strategy = "descending",
--     layout_strategy = "horizontal",
--     layout_defaults = {
--       horizontal = {
--         mirror = false,
--       },
--       vertical = {
--         mirror = false,
--       },
--     },
--     file_sorter =  require'telescope.sorters'.get_fuzzy_file,
--     file_ignore_patterns = {},
--     generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
--     shorten_path = true,
--     winblend = 0,
--     width = 0.75,
--     preview_cutoff = 120,
--     results_height = 1,
--     results_width = 0.8,
--     border = {},
--     borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
--     color_devicons = true,
--     use_less = true,
--     set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
--     file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
--     grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
--     qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

--     -- Developer configurations: Not meant for general override
--     buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
--   }
-- }

function _G.git_files()
  builtin.git_files {
    shorten_path = true,
  }
end

map("n", "<leader>p", "v:lua git_files()<cr>", {})
map("n", "<leader>ff", ":Telescope live_grep<cr>", {})
map("n", "<leader>o", ":Telescope buffers<cr>", {})
map("n", "<leader>ft", ":Telescope help_tags<cr>", {})
map("n", "<leader>fb", ":Telescope git_branches<cr>", {})
map("n", "<leader>fh", ":Telescope search_history<cr>", {})
