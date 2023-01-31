local constants_path = {}

local MASON_ROOT = vim.fn.stdpath("data") .. "/mason"

constants_path.EXECUTABLES = MASON_ROOT .. "/bin"
constants_path.LSP_SERVERS = MASON_ROOT .. "/packages"

return constants_path
