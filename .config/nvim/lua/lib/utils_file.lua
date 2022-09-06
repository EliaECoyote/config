local utils_file = {}

function utils_file.scan_deep_files(paths, pattern)
  pattern = pattern or "**/*"
  return vim.fn.globpath(table.concat(paths, ","), pattern, true, true)
end

return utils_file
