local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local constants_lsp = require("lib.constants_lsp")

mason.setup({
  ui = { border = "rounded" },
})

local mason_packages = {}
for _, v in constants_lsp.LSP_SERVERS do
  table.insert(mason_packages, v)
end
table.insert(mason_packages, "prettier")
table.insert(mason_packages, "black")
table.insert(mason_packages, "isort")
table.insert(mason_packages, "yamllint")


mason_lspconfig.setup({ ensure_installed = mason_packages })
