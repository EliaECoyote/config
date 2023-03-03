local utils_file    = require("lib.utils_file")
local utils_buffer  = require("lib.utils_buffer")
local telescope     = require("telescope")
local entry_display = require("telescope.pickers.entry_display")
local pickers       = require("telescope.pickers")
local finders       = require("telescope.finders")
local builtin       = require("telescope.builtin")
local config        = require("telescope.config")
local themes        = require("telescope.themes")
local actions       = require("telescope.actions")
local action_state  = require("telescope.actions.state")
local make_entry    = require("telescope.make_entry")

local file_browser_actions = require("telescope").extensions.file_browser.actions

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

local function set_current_folder_as_cwd(prompt_bufnr)
  local file_browser_utils = require("telescope._extensions.file_browser.utils")
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local finder = current_picker.finder
  finder.cwd = finder.path
  vim.cmd("cd " .. finder.path)
  file_browser_utils.redraw_border_title(current_picker)
  current_picker:refresh(finder, { reset_prompt = true, multi = current_picker._multi })
  print("CWD changed to " .. finder.path)
end

local function bookmarks(opts)
  local files = {
    "~/.profile", "~/.bash_profile",
    "~/.tmux.conf", "~/.config/vifm/vifmrc", "~/.config/alacritty.yml",
    "~/.config/karabiner/karabiner.json", "~/.gitconfig", "~/.gitignore",
    "~/.shellrc", "~/.workrc", "~/.bashrc", "~/.zshrc",
  }
  local folders = {
    "~/.config/nvim/",
    "~/.config/fzf/",
    "~/.config/karabiner/",
    "~/.config/vifm/",
    "~/.local/bin/",
    "~/.github/",
    "~/Dropbox/",
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
        map("n", "<C-x>", function()
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
    file_browser = {
      theme = "ivy",
      path_display = { "smart" },
      hidden = true,
      path = "%:p:h",
      mappings = {
        ["i"] = {
          ["<M-c>"] = false,
          ["<M-r>"] = false,
          ["<M-m>"] = false,
          ["<M-y>"] = false,
          ["<M-d>"] = false,
          ["<C-o>"] = false,
          ["<C-g>"] = false,
          ["<C-e>"] = false,
          ["<C-w>"] = false,
          ["<C-t>"] = false,
          ["<C-f>"] = false,
          ["<C-h>"] = false,
          ["<C-s>"] = false,
          ["<S-CR>"] = false,
        },
        ["n"] = {
          h = false,
          c = false,
          r = false,
          d = false,
          o = false,
          g = false,
          e = false,
          w = false,
          t = false,
          f = false,
          s = false,
          ["<S-CR>"] = false,
          ["<C-o>"] = file_browser_actions.create,
          ["<C-cr>"] = file_browser_actions.open,
          ["<C-c>"] = file_browser_actions.rename,
          ["<C-p>"] = file_browser_actions.move,
          ["<C-y>"] = file_browser_actions.copy,
          ["<C-x>"] = file_browser_actions.remove,
          ["<C-r>"] = file_browser_actions.goto_cwd,
          ["<C-w>"] = set_current_folder_as_cwd,
          ["<C-f>"] = file_browser_actions.toggle_browser,
          ["<C-s>"] = file_browser_actions.toggle_all,
          ["<C-h>"] = file_browser_actions.goto_parent_dir,
        },
      },
    },
  },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("file_browser")

local options = { noremap = true }

vim.keymap.set("n", "<C-p>", function() builtin.find_files(themes.get_dropdown({ previewer = false })) end, options)
vim.keymap.set("n", "<leader>o", builtin.buffers, options)
vim.keymap.set("n", "<leader>ff", telescope.extensions.live_grep_args.live_grep_args, options)
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, options)
vim.keymap.set("n", "<leader>f?", builtin.builtin, options)
vim.keymap.set("n", "<leader>fw", bookmarks, options)
vim.keymap.set("n", "<leader>fr", builtin.resume, options)

-- LSP
vim.keymap.set("n", "gr", builtin.lsp_references, options)
vim.keymap.set("n", "gd", builtin.lsp_definitions, options)
