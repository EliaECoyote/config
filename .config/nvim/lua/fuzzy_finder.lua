local file_utils = require"utils.file_utils"
local telescope = require"telescope"
local pickers = require"telescope.pickers"
local finders = require"telescope.finders"
local builtin = require"telescope.builtin"
local config = require"telescope.config"
local previewers = require"telescope.previewers"
local themes = require"telescope.themes"

local set_keymap = vim.api.nvim_set_keymap

telescope.setup {
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
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  }
}

require('telescope').load_extension('fzf')

function _G.git_files()
  return builtin.git_files {
    layout_strategy = "vertical",
    layout_config = {
      height = 0.9,
      width = 0.9,
      preview_cutoff = 10,
    },
  }
end

function _G.buffers()
  return builtin.buffers {
    sort_lastused = true,
    layout_strategy = "vertical",
    layout_config = {
      height = 0.9,
      width = 0.9,
      preview_cutoff = 10,
    },
  }
end

function _G.live_grep()
  return builtin.live_grep({
      path_display = { "smart", "absolute" },
      layout_strategy = "vertical",
      layout_config = {
        height = 0.9,
        width = 0.9,
        preview_cutoff = 10,
      },
  })
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
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Bookmarks",
    finder = finders.new_table(files),
    previewer = config.values.file_previewer(opts),
    sorter = config.values.file_sorter(opts),
  }):find()
end

local options = { noremap = true }

set_keymap("n", "<leader>p", "v:lua git_files()<cr>", options)
set_keymap("n", "<leader>o", "v:lua buffers()<cr>", options)
set_keymap("n", "<leader>fw", "v:lua common_files()<cr>", options)
set_keymap("n", "<leader>ff", "v:lua live_grep()<cr>", options)
set_keymap("n", "<leader>P", "<cmd>lua require('telescope.builtin').git_files()<cr>", options)
set_keymap("n", "<leader>?", "<cmd>lua require('telescope.builtin').oldfiles()<cr>", options)
set_keymap("n", "<leader>fp", "<cmd>lua require('telescope.builtin').file_browser()<cr>", options)
set_keymap("n", "<leader>ft", "<cmd>lua require('telescope.builtin').help_tags()<cr>", options)
set_keymap("n", "<leader>fb", "<cmd>lua require('telescope.builtin').git_branches()<cr>", options)
set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').search_history()<cr>", options)
set_keymap("n", "<leader>fT", "<cmd>lua require('telescope.builtin').colorscheme()<cr>", options)
set_keymap("n", "<leader>fm", "<cmd>lua require('telescope.builtin').marks()<cr>", options)
set_keymap("n", "<leader>f\"", "<cmd>lua require('telescope.builtin').registers()<cr>", options)
set_keymap("n", "<leader>f/", "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>", options)
set_keymap("n", "<leader>fh", "<cmd>lua require('telescope.builtin').highlights()<cr>", options)
set_keymap("n", "<leader>fk", "<cmd>lua require('telescope.builtin').keymaps()<cr>", options)
set_keymap("n", "<leader>fc", "<cmd>lua require('telescope.builtin').commands()<cr>", options)
set_keymap("n", "<leader>fq", "<cmd>lua require('telescope.builtin').quickfix()<cr>", options)
set_keymap("n", "<leader>f?", "<cmd>lua require('telescope.builtin').builtin()<cr>", options)
set_keymap("n", "<leader>fr", "<cmd>lua require('telescope.builtin').resume()<cr>", options)
