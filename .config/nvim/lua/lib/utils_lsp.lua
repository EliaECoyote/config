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
  local default_capabilities = vim.lsp.protocol.make_client_capabilities()
  local capabilities = {
    textDocument = {
      completion = { completionItem = { snippetSupport = true } },
    },
    codeAction = {
      vim.list_extend(
        default_capabilities.textDocument.codeAction.resolveSupport.properties,
        { "documentation", "detail", "additionalTextEdits" }
      ),
    }
  }

  return {
    capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_nvim_lsp.default_capabilities(capabilities)
    ),
  }
end

return utils_lsp
