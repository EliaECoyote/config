local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local constants_lsp = require("lib.constants_lsp")

mason.setup({
  ui = { border = "rounded" },
})

mason_lspconfig.setup({
  ensure_installed = constants_lsp.LSP_SERVERS
})
