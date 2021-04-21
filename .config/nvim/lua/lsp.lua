local lspconfig = require'lspconfig'
local util = require'lspconfig/util'
local lsp_status = require'lsp-status'

lsp_status.register_progress()

lsp_status.config {
  current_function = false,
  indicator_errors = '❌',
  indicator_warnings = '⚠️ ',
  indicator_info = 'ℹ️ ',
  indicator_hint = '❗',
  indicator_ok = 'All good!',
  status_symbol = '',
}

local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
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
    lsp_status.on_attach(client)
  end,
  capabilities = lsp_status.capabilities,
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
    lsp_status.on_attach(client)
  end,
  capabilities = lsp_status.capabilities,
}

lspconfig.vimls.setup {
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
}

local sumneko_root_path = '/Volumes/Projects/lua-language-server'
local sumneko_binary = sumneko_root_path.."/bin/"..system_name.."/lua-language-server"

lspconfig.sumneko_lua.setup {
  cmd = { sumneko_binary, "-E", sumneko_root_path.."/main.lua" };
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using
        -- (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = lsp_status.on_attach,
  capabilities = lsp_status.capabilities,
}
