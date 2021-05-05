local file_utils = require"file_utils"
local scan = require"plenary.scandir"
local telescope = require"telescope"
local pickers = require"telescope.pickers"
local finders = require"telescope.finders"
local previewers = require"telescope.previewers"
local builtin = require"telescope.builtin"
local sorters = require"telescope.sorters"
local config = require"telescope.config"

local set_keymap = vim.api.nvim_set_keymap

telescope.setup{
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case"
    },
    shorten_path = true,
  },
  extensions = {
    fzf = {
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  }
}
telescope.load_extension("fzf")

function _G.git_files()
  return builtin.git_files {
    shorten_path = true,
  }
end

function _G.buffers()
  return builtin.buffers {
    shorten_path = true,
    sort_lastused = true,
  }
end

function _G.common_files(opts)
  local files = {
    "~/.tmux.conf",
    "~/.config/vifm/vifmrc",
    "~/.config/karabiner/karabiner.json",
    "~/.gitconfig",
    "~/.gitignore",
    "~/.shellrc",
    "~/.workrc",
    "~/.zshrc",
  }
  local folders = {
      "~/.config/nvim/",
      "~/Dropbox/vimwiki/",
  }
  local folder_files = file_utils.scan_deep_files(folders)
  for _, path in ipairs(folder_files) do 
    table.insert(files, path)
  end
  local opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Bookmarks",
    finder = finders.new_table(files),
    previewer = config.values.file_previewer(opts),
    sorter = config.values.file_sorter(opts),
  }):find()
end

set_keymap("n", "<leader>p", "v:lua git_files()<cr>", {})
set_keymap("n", "<leader>o", "v:lua buffers()<cr>", {})
set_keymap("n", "<leader>fw", "v:lua common_files()<cr>", {})
set_keymap("n", "<leader>P", "<cmd>lua require('telescope.builtin').git_files()<cr>", {})
set_keymap("n", "<leader>ff", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {})
set_keymap("n", "<leader>?", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", {})
set_keymap("n", "<leader>fp", "<cmd>lua require('telescope.builtin').file_browser()<cr>", {})
set_keymap("n", "<leader>ft", "<cmd>lua require('telescope.builtin').help_tags()<cr>", {})
set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", {})
set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').search_history()<cr>", {})
set_keymap("n", "<leader>fT", "<cmd>lua require('telescope.builtin').colorscheme()<cr>", {})
set_keymap("n", "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>", {})
set_keymap("n", "<leader>fr", "<cmd>lua require('telescope.builtin').registers()<cr>", {})
set_keymap("n", "<leader>f/", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", {})
set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').highlights()<cr>", {})
set_keymap("n", "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>", {})
set_keymap("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>", {})
set_keymap("n", "<leader>fq", "<cmd>lua require('telescope.builtin').quickfix()<cr>", {})
set_keymap("n", "<leader>f?", "<cmd>lua require('telescope.builtin').builtin()<cr>", {})
