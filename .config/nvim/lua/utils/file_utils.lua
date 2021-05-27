local file_utils = {}

function file_utils.scan_deep_files(paths, pattern)
  pattern = pattern or "**/*"
  return vim.fn.globpath(
    table.concat(paths, ","),
    pattern,
    true,
    true
  )
end

return file_utils
