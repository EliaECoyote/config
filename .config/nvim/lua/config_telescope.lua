local utils_file    = require("lib.utils_file")
local utils_buffer  = require("lib.utils_buffer")
local telescope     = require("telescope")
local terminal      = require("toggleterm.terminal")
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
    "~/.tmux.conf", "~/.config/vifm/vifmrc",
    "~/.config/karabiner/karabiner.json", "~/.gitconfig", "~/.gitignore",
    "~/.shellrc", "~/.workrc", "~/.zshrc",
  }
  local folders = {
    "~/.config/nvim/",
    "~/.config/fzf/",
    "~/.config/karabiner/",
    "~/.config/vifm/",
    "~/Dropbox/vimwiki/",
    "/Volumes/Projects/playground/"
  }
  local folder_files = utils_file.scan_deep_files(folders)
  for _, path in ipairs(folder_files) do
    table.insert(files, path)
  end
  opts = opts or {}
  opts.prompt_title = "Bookmarks"
  opts.path_display = { "truncate" }
  opts.finder = finders.new_table({
    results = files,
    entry_maker = make_entry.gen_from_file(opts)
  })
  opts.previewer = config.values.file_previewer(opts)
  opts.sorter = config.values.file_sorter(opts)
  pickers.new(themes.get_ivy(opts), telescope_defaults):find()
end

local function terminals()
  local terms_table = terminal.get_all()
  local terms = {}
  for _, term in pairs(terms_table) do
    table.insert(terms, {
      bufnr = term.bufnr,
      id = term.id,
      name = term.name,
    })
  end

  local opts = themes.get_dropdown()
  pickers.new(opts, {
    prompt_title = "Terms",
    finder = finders.new_table({
      results = terms,
      entry_maker = function(term)
        term.value = term.id
        term.ordinal = term.name
        term.display = function(entry)
          local displayer = entry_display.create({
            separator = " ",
            items = {
              { width = 40 },
              { width = 18 },
              { remaining = true },
            },
          })
          return displayer({ entry.id .. "\t|\t" .. entry.name })
        end
        return term
      end,
    }),
    sorter = config.values.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        if entry.id == nil then
          return
        end
        actions.close(prompt_bufnr)

        local term = terminal.get(entry.id)
        if term == nil then
          return
        end

        if term:is_open() then
          vim.api.nvim_set_current_win(term.window)
        else
          term:open()
        end
      end)
      return true
    end
  }):find()
end

local function project_files(opts)
  local ok = pcall(builtin.git_files, opts)
  if not ok then builtin.find_files(opts) end
end

local function select_background(opts)
  local function load_iterm_background(file_name)
    local apple_script = string.format([[
        tell application "iTerm2"
          tell current session of current window
            set background image to "%s" 
          end tell
        end tell
    ]], file_name)
    vim.fn.system(string.format("osascript -e '%s'", apple_script))
  end

  local folders = { "~/.config/wallpapers/" }
  local folder_files = utils_file.scan_deep_files(folders)
  local entries = {}
  for _, path in ipairs(folder_files) do table.insert(entries, path) end
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Select Background",
    finder = finders.new_table(entries),
    previewer = false,
    sorter = config.values.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()[1]
        load_iterm_background(selection)
      end)
      return true
    end
  }):find()
end

telescope.setup({
  defaults = telescope_defaults,
  pickers = {
    lsp_references = {
      theme = "ivy",
    },
    lsp_definitions = {
      theme = "ivy",
    },
    buffers = {
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
      hidden = true,
      hijack_netrw = true,
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

vim.keymap.set("n", "<leader>o", builtin.buffers, options)
vim.keymap.set("n", "<leader>ff", builtin.live_grep, options)
vim.keymap.set("n", "<leader>F", telescope.extensions.live_grep_args.live_grep_args, options)
vim.keymap.set("n", "<leader>p", project_files, options)
vim.keymap.set("n", "<leader>?", builtin.oldfiles, options)
vim.keymap.set("n", "<leader>fq", builtin.quickfix, options)
vim.keymap.set("n", "<leader>f?", builtin.builtin, options)
vim.keymap.set("n", "<leader>fl", builtin.loclist, options)
vim.keymap.set("n", "<leader>fb", telescope.extensions.file_browser.file_browser, options)
vim.keymap.set("n", "<leader>fw", bookmarks, options)
vim.keymap.set("n", "<leader>ft", terminals, options)
vim.keymap.set("n", "<leader>fB", select_background, options)
vim.keymap.set("n", "<leader>fr", builtin.resume, options)

-- LSP
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, options)
vim.keymap.set("n", "gr", builtin.lsp_references, options)
vim.keymap.set("n", "gd", builtin.lsp_definitions, options)
