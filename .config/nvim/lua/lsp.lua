local lspconfig = require"lspconfig"
local util = require"lspconfig/util"
local lsp_status = require"lsp-status"

lsp_status.register_progress()

lsp_status.config {
  current_function = false,
  indicator_errors = "❌",
  indicator_warnings = "⚠️ ",
  indicator_info = "ℹ️ ",
  indicator_hint = "❗",
  indicator_ok = "All good!",
  status_symbol = "",
}

-- Snippets support
local capabilities = lsp_status.capabilities
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

local function custom_attach(client)
  print("LSP 🙏")
  lsp_status.on_attach(client)
  print("LSP 🙏")

  local set_keymap = vim.api.nvim_set_keymap
  local options = { silent = true, noremap = true }

  set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", options)
  set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", options)
  set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", options)
  set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", options)
  set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", options)
  set_keymap("n", "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", options)
  set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", options)
  set_keymap("n", "g0", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", options)
  set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", options)
  set_keymap("n", "F2", "<cmd>lua vim.lsp.buf.rename()<cr>", options)
  set_keymap("n", "F12", "<cmd>lua vim.lsp.buf.formatting()<cr>", options)
  set_keymap("n", "<leader>a", "<cmd>lua vim.lsp.buf.code_action()<cr>", options)
  set_keymap("n", "]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", options)
  set_keymap("n", "[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", options)
end

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  lintIgnoreExitCode = true,
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  rootMarkers = {
    "package.json",
    ".eslintrc.js",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json"
  },
  formatStdin = true,
}

local prettier = {
    formatCommand = "yarn prettier --stdin --stdin-filepath ${INPUT}",
    formatStdin = true
}

lspconfig.efm.setup {
  root_dir = util.root_pattern(".git", vim.fn.getcwd()),
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    custom_attach(client)
  end,
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
  },
  settings = {
    rootMarkers = { ".git", "package.json" },
    languages = {
      javascript = { eslint, prettier },
      javascriptreact = { eslint, prettier },
      typescript = { eslint, prettier },
      typescriptreact = { eslint, prettier },
      ["javascript.jsx"] = { eslint, prettier },
      ["typescript.tsx"] = { eslint, prettier },
    },
  },
}

lspconfig.tsserver.setup {
  on_attach = function (client)
    -- Disable ts builtin formatting
    client.resolved_capabilities.document_formatting = false
    custom_attach(client)
  end,
  capabilities = capabilities,
}

lspconfig.vimls.setup {
  on_attach = custom_attach,
  capabilities = capabilities,
}

local javals_root_path = "/Volumes/Projects/java-language-server"
local javals_binary = javals_root_path.."/dist/lang_server_mac.sh"
lspconfig.java_language_server.setup {
  cmd = { javals_binary },
  on_attach = custom_attach,
  capabilities = capabilities,
}

local luals_root_path = "/Volumes/Projects/lua-language-server"
local luals_binary = luals_root_path.."/bin/macOS/lua-language-server"
lspconfig.sumneko_lua.setup {
  cmd = { luals_binary , "-E", luals_root_path.."/main.lua" };
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you"re using
        -- (most likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Setup your lua path
        path = vim.split(package.path, ";"),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {"vim"},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand("$VIMRUNTIME/lua")] = true,
          [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = custom_attach,
  capabilities = capabilities,
}
