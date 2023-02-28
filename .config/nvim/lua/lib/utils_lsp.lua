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

function utils_lsp.format_buffer()
  vim.lsp.buf.format()
  -- Run eslint on buffers with JS filetype
  if utils_table.includes(utils_lsp.ESLINT_FILETYPES, vim.bo.filetype) then
    vim.cmd("EslintFixAll")
  end
end

function utils_lsp.custom_attach()
  local options = { noremap = true }


  vim.keymap.set("n", "<leader>0", utils_lsp.format_buffer, options)
  vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action, options)
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, options)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, options)
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, options)
  vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, options)
  vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, options)
  vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, options)
  vim.keymap.set("n", "]g", vim.diagnostic.goto_next, options)
  vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, options)

  -- Uncomment to enable formatting on save
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  --   callback = format_buffer,
  -- })
end

function utils_lsp.make_default_config()
  local capabilities = cmp_nvim_lsp.default_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport.properties = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }

  return { on_attach = utils_lsp.custom_attach, capabilities = capabilities }
end

return utils_lsp
