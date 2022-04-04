local table_utils = {}

function table_utils.merge(t1, t2)
  local t3 = {}
  for k, v in pairs(t1) do t3[k] = v end
  for k, v in pairs(t2) do t3[k] = v end
  return t3
end

function table_utils.includes(t, value)
  for _, v in ipairs(t) do
    if v == value then
      return true
    end
  end
  return false
end

return table_utils;
