local table_utils = {}

function table_utils.merge(t1, t2)
  local t3 = {}
  for k, v in pairs(t1) do t3[k] = v end
  for k, v in pairs(t2) do t3[k] = v end
  return t3
end

return table_utils;
