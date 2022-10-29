local utils_buffer = {}

function utils_buffer.buffer_to_string()
  local content = vim.api.nvim_buf_get_lines(
    0,
    0,
    vim.api.nvim_buf_line_count(0),
    false
  )
  return table.concat(content, "\n")
end

-- Enhanced deletes buffer function.
-- Features:
-- - Deletes buffer without losing the window layout
-- - When passing `opts.loading = true`, the buffer will be de-listed
-- - Will create a new empty buffer before deleting the last buffer
-- - Doesn't delete modified buffers if keep_unmodified is true
--
-- Inspired from https://github.com/famiu/bufdelete.nvim
-- Returns `false` when buffer cannot be deleted, returns `true` otherwise.
function utils_buffer.delete_buffer(bufnr, opts, delete_unmodified)
  opts = opts or {}

  -- If buffer is modified and force isn't true or delete_unmodified isn't true, return false
  -- as we cannot delete this buffer.
  if (not opts.force or not delete_unmodified) and vim.api.nvim_buf_get_option(bufnr, "modified") then
    return false
  end

  if bufnr == 0 or bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end

  -- Get list of windows IDs with the buffer to close
  local windows = vim.tbl_filter(
    function(win)
      return vim.api.nvim_win_get_buf(win) == bufnr
    end,
    vim.api.nvim_list_wins()
  )

  -- Get list of valid and listed buffers
  local buffers = vim.tbl_filter(
    function(buf)
      return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
    end,
    vim.api.nvim_list_bufs()
  )

  if #buffers == 0 then
    return false
  end

  -- If there is only one buffer (which has to be `bufnr`), we will create a
  -- new buffer before deleting the previous one.
  if #buffers == 1 and buffers[1] == bufnr then
    local next_buffer = vim.api.nvim_create_buf(true, true)
    if next_buffer == 0 then
      return false
    end
    table.insert(buffers, next_buffer)
  end

  -- We pick and set the next buffer available.
  -- This will replace the old buffer in all windows that were referencing it.
  for i, candidate in ipairs(buffers) do
    if candidate == bufnr then
      local next_buffer = buffers[i % #buffers + 1]
      for _, win in ipairs(windows) do
        vim.api.nvim_win_set_buf(win, next_buffer)
      end
      break
    end
  end

  -- Before deleting, ensure the target buffer:
  -- - wasn't killed due to options like bufhidden=wipe
  -- - is still listed
  if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
    if opts.unload then
      -- If the buffer has just been unloaded, we also remove it from the
      -- buffer list (to replicate the original :bdelete behavior).
      vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
    end
    vim.api.nvim_buf_delete(bufnr, opts)
  end
  return true
end

function utils_buffer.delete_other_buffers(opts, delete_unmodified)
  local cur_buf = vim.api.nvim_get_current_buf()
  local deleted_count, invalid_count = 0, 0
  -- Get list of valid and listed buffers
  local buffers = vim.tbl_filter(
    function(buf)
      return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buflisted")
    end,
    vim.api.nvim_list_bufs()
  )
  for _, candidate in ipairs(buffers) do
    if candidate ~= cur_buf then
      if utils_buffer.delete_buffer(candidate, opts, delete_unmodified) then
        deleted_count = deleted_count + 1
      else
        invalid_count = invalid_count + 1
      end
    end
  end
  return invalid_count, deleted_count
end

-- Does not handle rectangular selection
-- local function get_visual_selection_content()
--   local _, row_start, col_start, _ = unpack(vim.fn.getpos("'<"))
--   local _, row_end, col_end, _ = unpack(vim.fn.getpos("'>"))
--   local lines = vim.api.nvim_buf_get_lines(0, row_start - 1, row_end, false)
--   local lines_length = #lines
--   if lines_length > 0 then
--     -- Strip down unselected content from last line
--     -- print("stripping from " .. col_end)
--     lines[lines_length] = string.sub(lines[lines_length], 1, col_end)
--     -- Strip down unselected content from first line
--     lines[1] = string.sub(lines[1], col_start)
--   end
--   vim.pretty_print(lines)
--   return table.concat(lines, '\n')
-- end

return utils_buffer
