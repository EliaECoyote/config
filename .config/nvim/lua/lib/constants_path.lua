local constants_path = {}

local MASON_ROOT = vim.fn.stdpath("data") .. "/mason"

constants_path.EXECUTABLES = MASON_ROOT .. "/bin"
constants_path.LSP_SERVERS = vim.fn.stdpath("data") .. "/lsp_servers"

return constants_path
