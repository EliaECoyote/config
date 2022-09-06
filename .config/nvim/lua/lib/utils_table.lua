local utils_table = {}

function utils_table.merge(t1, t2)
  local t3 = {}
  for k, v in pairs(t1) do t3[k] = v end
  for k, v in pairs(t2) do t3[k] = v end
  return t3
end

function utils_table.includes(t, value)
  for _, v in ipairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

return utils_table
