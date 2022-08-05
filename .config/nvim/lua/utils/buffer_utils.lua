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

function buffer_utils.delete_other_buffers()
  local cur_buf = vim.api.nvim_get_current_buf()
  local deleted_count, modified_count = 0, 0
  local buffers = vim.api.nvim_list_bufs()
  for _, n in ipairs(buffers) do
    -- If the buffer is modified, skip it.
    if vim.api.nvim_buf_get_option(n, "modified") then
      modified_count = modified_count + 1
    -- Otherwise, if it's not current buf, delete it.
    elseif n ~= cur_buf then
      vim.api.nvim_buf_delete(n, {})
      deleted_count = deleted_count + 1
    end
  end
  return modified_count, deleted_count
end

return buffer_utils
