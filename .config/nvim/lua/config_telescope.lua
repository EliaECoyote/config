local utils_file         = require("lib.utils_file")
local utils_buffer       = require("lib.utils_buffer")
local telescope          = require("telescope")
local pickers            = require("telescope.pickers")
local finders            = require("telescope.finders")
local builtin            = require("telescope.builtin")
local config             = require("telescope.config")
local themes             = require("telescope.themes")
local actions            = require("telescope.actions")
local action_state       = require("telescope.actions.state")
local make_entry         = require("telescope.make_entry")

local telescope_defaults = {
  theme = "ivy",
  path_display = { "truncate" },
  vimgrep_arguments = {
    "rg", "--color=never", "--no-heading", "--with-filename", "--line-number",
    "--column", "--smart-case", "--trim",
  },
  mappings = {
    i = {
      ["<C-s>"] = actions.cycle_previewers_next,
      ["<C-a>"] = actions.cycle_previewers_prev,
    },
  },
}

local function bookmarks(opts)
  local files = {
    "~/.profile", "~/.bash_profile", "~/Brewfile", "~/.tmux.conf",
    "~/.config/vifm/vifmrc", "~/.config/alacritty.yml",
    "~/.config/lazygit/config.yml", "~/.config/lazydocker/config.yml",
    "~/.config/karabiner/karabiner.json", "~/.gitconfig", "~/.gitignore",
    "~/.shellrc", "~/.workrc", "~/.bashrc", "~/.zshrc", "~/.ideavimrc",
  }
  local folders = {
    "~/.config/nvim/",
    "~/.config/fzf/",
    "~/.config/karabiner/",
    "~/.config/vifm/",
    "~/.local/bin/",
    "~/.github/",
    "~/Library/CloudStorage/Dropbox/",
    "~/dev/playground",
    "~/dev/EPIJudge",
  }
  local folder_files = utils_file.scan_deep_files(folders)
  for _, path in ipairs(folder_files) do
    table.insert(files, path)
  end
  opts = opts or {}
  opts.prompt_title = "Bookmarks"
  opts.path_display = telescope_defaults.path_display
  opts.finder = finders.new_table({
    results = files,
    entry_maker = make_entry.gen_from_file(opts)
  })
  opts.previewer = config.values.file_previewer(opts)
  opts.sorter = config.values.file_sorter(opts)
  pickers.new(themes.get_ivy(opts), telescope_defaults):find()
end

telescope.setup({
  defaults = telescope_defaults,
  pickers = {
    live_grep = {
      theme = telescope_defaults.theme,
    },
    oldfiles = {
      theme = telescope_defaults.theme,
    },
    git_files = {
      theme = telescope_defaults.theme,
    },
    find_files = {
      theme = telescope_defaults.theme,
    },
    lsp_references = {
      theme = telescope_defaults.theme,
    },
    lsp_definitions = {
      theme = telescope_defaults.theme,
    },
    builtin = {
      theme = telescope_defaults.theme,
    },
    buffers = {
      theme = telescope_defaults.theme,
      attach_mappings = function(prompt_bufnr, map)
        map({ "n", "i" }, "<C-x>", function()
          local current_picker = action_state.get_current_picker(prompt_bufnr)
          current_picker:delete_selection(function(selection)
            utils_buffer.delete_buffer(selection.bufnr, { force = true, unload = true }, false)
          end)
        end)
        return true
      end,
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    live_grep_args = {
      theme = "ivy",
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("live_grep_args")

vim.keymap.set("n", "<leader>p", function() builtin.find_files(themes.get_dropdown({ previewer = false })) end)
vim.keymap.set("n", "<leader>o", builtin.buffers)
vim.keymap.set("n", "<leader>ff", telescope.extensions.live_grep_args.live_grep_args)
vim.keymap.set("n", "<leader>fo", builtin.oldfiles)
vim.keymap.set("n", "<leader>f?", builtin.builtin)
vim.keymap.set("n", "<leader>fw", bookmarks)
vim.keymap.set("n", "<leader>fr", builtin.resume)

-- LSP
vim.keymap.set("n", "gr", builtin.lsp_references)
vim.keymap.set("n", "gd", builtin.lsp_definitions)
