local buffer_utils = {}

function buffer_utils.buffer_to_string()
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
--
-- Inspired from https://github.com/famiu/bufdelete.nvim
-- Returns `false` when buffer cannot be deleted, returns `true` otherwise.
function buffer_utils.delete_buffer(bufnr, opts)
  opts = opts or {}

  -- If buffer is modified and force isn't true, return false because
  -- as we cannot delete this buffer.
  if not opts.force and vim.api.nvim_buf_get_option(bufnr, "modified") then
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

  -- Check if buffer still exists, to ensure the target buffer wasn't killed
  -- due to options like bufhidden=wipe.
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.api.nvim_buf_delete(bufnr, opts)
    if opts.unload then
      -- If the buffer has just been unloaded, we also remove it from the
      -- buffer list (to replicate the original :bdelete behavior).
      vim.api.nvim_buf_set_option(bufnr, "buflisted", false)
    end
  end
  return true
end

function buffer_utils.delete_other_buffers(opts)
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
      if buffer_utils.delete_buffer(candidate, opts) then
        deleted_count = deleted_count + 1
      else
        invalid_count = invalid_count + 1
      end
    end
  end
  return invalid_count, deleted_count
end

return buffer_utils