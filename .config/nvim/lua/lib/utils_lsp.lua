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
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.list_extend(
    capabilities.textDocument.codeAction.resolveSupport.properties,
    { "documentation", "detail", "additionalTextEdits" }
  )

  return {
    capabilities = vim.tbl_deep_extend(
      "force",
      capabilities,
      cmp_nvim_lsp.default_capabilities({ snippetSupport = true })
    )
  }
end

return utils_lsp
