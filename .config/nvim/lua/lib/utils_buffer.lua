local utils_buffer = {}

-- Computes "true" buffer nr.
function utils_buffer.get_real_bufnr(bufnr)
  if bufnr == nil or bufnr == 0 then
    return vim.api.nvim_get_current_buf()
  end
  return bufnr
end

-- Deletes buffer without losing the window layout
-- Returns `false` when buffer cannot be deleted, returns `true` otherwise.
function utils_buffer.delete_buffer(bufnr, opts, delete_unmodified)
  bufnr = utils_buffer.get_real_bufnr(bufnr)
  opts = opts or {}

  -- If buffer is modified and force isn't true or delete_unmodified isn't true, return false
  -- as we cannot delete this buffer.
  if (not opts.force or not delete_unmodified) and vim.api.nvim_buf_get_option(bufnr, "modified") then
    return false
  end

  -- Get list of windows IDs with the buffer to close
  local windows = vim.tbl_filter(
    function(win) return vim.api.nvim_win_get_buf(win) == bufnr end,
    vim.api.nvim_list_wins()
  )

  -- Replaces the buffer for each window. We try, respectively, to:
  -- - Use the alternate buffer (if listed)
  -- - Use the previous listed buffer
  -- - Create a buffer from scratch

  for _, winnr in ipairs(windows) do
    local cur_bufnr = vim.api.nvim_win_get_buf(winnr)
    vim.api.nvim_win_call(
      winnr,
      function()
        -- Try using alternate buffer
        local alt_bufnr = vim.fn.bufnr('#')
        if alt_bufnr ~= cur_bufnr and vim.fn.buflisted(alt_bufnr) == 1 then
          vim.api.nvim_win_set_buf(winnr, alt_bufnr)
          return
        end

        -- Try using the previous listed buffer
        local ok, result = pcall(vim.cmd, "bprevious")
        vim.print(result)

        -- If there's no other listed buffer, we would get E85.
        -- In that case, we want to create a new buffer instead.
        if ok and (result == nil or not result:find("E85")) and cur_bufnr ~= vim.api.nvim_win_get_buf(winnr) then
          return
        end

        -- Create new listed scratch buffer
        local new_buf = vim.api.nvim_create_buf(true, true)
        vim.api.nvim_win_set_buf(winnr, new_buf)
      end
    )
  end

  local command = string.format("bdelete%s %d", opts.force and "!" or "", bufnr)
  -- Use `pcall` here to take care of case where hiding the buffer was enough. This
  -- can happen with 'bufhidden' option values:
  -- - If hiding already deleted the buffer, we would get E516.
  local ok, result = pcall(vim.cmd, command)
  if not (ok or result ~= nil and result:find('E516')) then
    print(result)
    return false
  end

  return true
end

function utils_buffer.delete_other_buffers(opts, delete_unmodified)
  local cur_buf = utils_buffer.get_real_bufnr(0)
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

return utils_buffer
