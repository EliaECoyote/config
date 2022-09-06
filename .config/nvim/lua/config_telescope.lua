local terminal = require("toggleterm.terminal")
local entry_display = require("telescope.pickers.entry_display")
local utils_file = require("lib.utils_file")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local builtin = require("telescope.builtin")
local config = require("telescope.config")
local actions = require("telescope.actions")
local previewer_utils = require("telescope.previewers.utils")
local action_state = require("telescope.actions.state")

local set_keymap = vim.api.nvim_set_keymap

require("telescope").setup {
  defaults = {
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename", "--line-number",
      "--column", "--smart-case",
    },
    layout_strategy = "vertical",
    layout_config = {
      vertical = { height = 0.9, width = 0.9, preview_cutoff = 10 },
    },
    path_display = { "truncate", "absolute" },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

require("telescope").load_extension("fzf")
require("telescope").load_extension("live_grep_args")

function _G.buffers()
  return builtin.buffers {
    sort_lastused = true,
    layout_strategy = "vertical",
    layout_config = { height = 0.9, width = 0.9, preview_cutoff = 10 },
  }
end

function _G.live_grep()
  return builtin.live_grep({ path_display = { "smart", "absolute" } })
end

function _G.common_files(opts)
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
  for _, path in ipairs(folder_files) do table.insert(files, path) end
  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Bookmarks",
    finder = finders.new_table(files),
    previewer = config.values.file_previewer(opts),
    sorter = config.values.file_sorter(opts),
  }):find()
end

function _G.terminals(opts)
  local function select_term(prompt_bufnr)
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
  end

  local function show_preview(entry, buf)
    local content = entry.content
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, content)
    previewer_utils.highlighter(buf, 'BufferCurrentTarget')

    vim.api.nvim_buf_call(buf, function()
      local win = vim.fn.win_findbuf(buf)[1]
      vim.wo[win].conceallevel = 2
      vim.wo[win].wrap = true
      vim.wo[win].linebreak = true
      vim.bo[buf].textwidth = 80
    end)
  end

  local function get_content_buf(bufnr)
    local content_table = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
    return content_table
  end

  local terms_table = terminal.get_all()
  local terms = {}
  for _, term in pairs(terms_table) do
    table.insert(terms, {
      bufnr = term.bufnr,
      id = term.id,
      content = get_content_buf(term.bufnr),
      name = term.name,
    })
  end

  opts = opts or {}
  pickers.new(opts, {
    prompt_title = "Terms",
    finder = finders.new_table({
      results = terms,
      entry_maker = function(term)
        term.value = term.id
        term.ordinal = term.name
        term.preview_command = show_preview
        term.display = function(entry)
          local displayer = entry_display.create({
            separator = " ",
            items = {
              { width = 40 },
              { width = 18 },
              { remaining = true },
            },
          })
          return displayer({ entry.id .. "\t| " .. entry.name })
        end
        return term
      end,
    }),
    previewer = config.values.file_previewer(opts),
    sorter = config.values.file_sorter(opts),
    attach_mappings = function(prompt_bufnr)
      actions.select_default:replace(function()
        select_term(prompt_bufnr)
      end)
      return true
    end
  }):find()
end

function _G.live_grep_args(opts)
  require("telescope").extensions.live_grep_args.live_grep_args(opts)
end

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

function _G.select_background(opts)
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

local options = { noremap = true }

set_keymap("n", "<leader>o", "v:lua buffers()<cr>", options)

set_keymap("n", "<leader>fw", "v:lua common_files()<cr>", options)
set_keymap("n", "<leader>ft", "v:lua terminals()<cr>", options)

set_keymap("n", "<leader>ff", "v:lua live_grep()<cr>", options)
set_keymap("n", "<leader>fF", "v:lua live_grep_args()<cr>", options)

set_keymap("n", "<leader>fB", "v:lua select_background()<cr>", options)
set_keymap("n", "<leader>p",
  "<cmd>lua require('telescope.builtin').git_files()<cr>", options)
set_keymap("n", "<leader>?",
  "<cmd>lua require('telescope.builtin').oldfiles()<cr>", options)
set_keymap("n", "<leader>fp",
  "<cmd>lua require('telescope.builtin').file_browser()<cr>", options)
-- set_keymap("n", "<leader>ft",
--   "<cmd>lua require('telescope.builtin').help_tags()<cr>", options)
set_keymap("n", "<leader>fb",
  "<cmd>lua require('telescope.builtin').git_branches()<cr>", options)
set_keymap("n", "<leader>fh",
  "<cmd>lua require('telescope.builtin').search_history()<cr>", options)
set_keymap("n", "<leader>fT",
  "<cmd>lua require('telescope.builtin').colorscheme()<cr>", options)
set_keymap("n", "<leader>fm",
  "<cmd>lua require('telescope.builtin').marks()<cr>", options)
set_keymap("n", "<leader>f\"",
  "<cmd>lua require('telescope.builtin').registers()<cr>", options)
set_keymap("n", "<leader>f/",
  "<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>",
  options)
set_keymap("n", "<leader>fhh",
  "<cmd>lua require('telescope.builtin').highlights()<cr>", options)
set_keymap("n", "<leader>fk",
  "<cmd>lua require('telescope.builtin').keymaps()<cr>", options)
set_keymap("n", "<leader>fc",
  "<cmd>lua require('telescope.builtin').commands()<cr>", options)
set_keymap("n", "<leader>fq",
  "<cmd>lua require('telescope.builtin').quickfix()<cr>", options)
set_keymap("n", "<leader>f?",
  "<cmd>lua require('telescope.builtin').builtin()<cr>", options)
set_keymap("n", "<leader>fl",
  "<cmd>lua require('telescope.builtin').loclist()<cr>", options)

-- LSP
vim.keymap.set("n", "<leader>a", '<cmd>lua vim.lsp.buf.code_action()<CR>', options)

set_keymap("n", "gr",
  "<cmd>lua require('telescope.builtin').lsp_references()<cr>", options)

set_keymap("n", "g0",
  "<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>",
  options)

set_keymap("n", "gd",
  "<cmd>lua require('telescope.builtin').lsp_definitions()<cr>",
  options)

set_keymap("n", "<leader>fr",
  "<cmd>lua require('telescope.builtin').resume()<cr>", options)
