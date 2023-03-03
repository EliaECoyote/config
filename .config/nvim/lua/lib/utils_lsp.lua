local utils_table = require("lib.utils_table")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local utils_lsp = {}

utils_lsp.ESLINT_FILETYPES = {
  "javascript",
  "javascript.jsx",
  "javascriptreact",
  "typescript",
  "typescript.tsx",
  "typescriptreact",
}

function utils_lsp.make_default_config()
  local capabilities = cmp_nvim_lsp.default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport.properties = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  return { capabilities = capabilities }
end

return utils_lsp
