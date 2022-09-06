local lsp_status = require("lsp-status")
local table_utils = require("utils.table_utils")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

local lsp_utils = {}

lsp_utils.ESLINT_FILETYPES = {
  "javascript",
  "javascript.jsx",
  "javascriptreact",
  "typescript",
  "typescript.tsx",
  "typescriptreact",
}

function lsp_utils.setup_lsp_status()
  lsp_status.register_progress()

  lsp_status.config {
    current_function = false,
    indicator_errors = "❌",
    indicator_warnings = "⚠️ ",
    indicator_info = "ℹ️ ",
    indicator_hint = "❗",
    indicator_ok = "All good!",
    diagnostics = false,
    status_symbol = "",
  }
end

function lsp_utils.format_buffer()
  vim.lsp.buf.formatting_seq_sync()
  -- Run eslint on buffers with JS filetype
  if table_utils.includes(lsp_utils.ESLINT_FILETYPES, vim.bo.filetype) then
    vim.cmd("EslintFixAll")
  end
end

function lsp_utils.custom_attach(client)
  lsp_status.on_attach(client)

  local options = { noremap = true }


  vim.keymap.set("n", "<leader>0", lsp_utils.format_buffer, options)
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

function lsp_utils.make_default_config()
  -- Combine capabilities from both nvim-cmp and lsp_status.
  local capabilities = cmp_nvim_lsp.update_capabilities(lsp_status.capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport.properties = {
    properties = { "documentation", "detail", "additionalTextEdits" },
  }
  return { on_attach = lsp_utils.custom_attach, capabilities = capabilities }
end

return lsp_utils
