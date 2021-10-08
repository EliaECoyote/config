local lspconfig = require"lspconfig"
local lsp_status = require"lsp-status"
local lspinstall = require"lspinstall"

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
  lsp_status.on_attach(client)
  print("LSP 🚀")

  local set_keymap = vim.api.nvim_set_keymap
  local options = { noremap = true }

  set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", options)
  set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", options)
  set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", options)
  set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", options)
  set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", options)
  set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", options)
  set_keymap("n", "<leader>0", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<cr>", options)
  set_keymap("n", "]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", options)
  set_keymap("n", "[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", options)
  set_keymap("n", "<leader>A", "<cmd>lua vim.lsp.buf.code_action()<cr>", options)

  vim.cmd [[
    augroup lsp_formatting
    autocmd!
    autocmd BufWritePre <buffer> :lua vim.lsp.buf.formatting_seq_sync(nil, 3000)
    augroup END
  ]]
end

local eslint = {
  -- lintCommand = "node /Users/elia.camposilvan/dd/web-ui/.yarn/sdks/eslint/bin/eslint -f unix --stdin --stdin-filename ${INPUT}",
  -- formatCommand = "node /Users/elia.camposilvan/dd/web-ui/.yarn/sdks/eslint/bin/eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  formatStdin = true,
  rootMarkers = {
    "package.json",
    ".eslintrc.js",
    ".eslintrc.yaml",
    ".eslintrc.yml",
    ".eslintrc.json"
  },
}

local prettier = {
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
  env = {
    string.format('PRETTIERD_DEFAULT_CONFIG=%s', vim.fn.expand('~/.config/nvim/utils/linter-config/.prettierrc.json')),
  },
  rootMarkers = { ".git/" },
  -- formatCommand = "node /Users/elia.camposilvan/dd/web-ui/.yarn/sdks/prettier ${INPUT}",
  -- formatCommand = "prettier ${INPUT}",
  -- formatCommand = "yarn prettier ${INPUT}",
  -- formatStdin = true,
}

lspconfig.efm.setup {
  init_options = { documentFormatting = true, codeAction = true },
  on_attach = custom_attach,
  capabilities = capabilities,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "javascript.jsx",
    "typescript.jsx",
    "html",
    "css",
    "json",
    "yaml",
  },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      javascript = { eslint, prettier },
      javascriptreact = { eslint, prettier },
      typescript = { eslint, prettier },
      typescriptreact = { eslint, prettier },
      ["javascript.jsx"] = { eslint, prettier },
      ["typescript.tsx"] = { eslint, prettier },
      html = { eslint, prettier },
      css = { prettier },
      json = { prettier },
      yaml = { prettier },
    },
  },
}

-- lspconfig.jdtls.setup {
--   cmd = {
--     "java",
--     "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1044",
--     "-Declipse.application=org.eclipse.jdt.ls.core.id1",
--     "-Dosgi.bundles.defaultStartLevel=4",
--     "-Declipse.product=org.eclipse.jdt.ls.core.product",
--     "-Dlog.level=ALL",
--     "-Xmx1G",
--     "-jar",
--     "/Volumes/Projects/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_1.6.100.v20201223-0822.jar",
--     "-configuration",
--     "/Volumes/Projects/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/config_mac",
--     "-data",
--     "${1:-$HOME/workspace}",
--     "--add-modules=ALL-SYSTEM",
--     "--add-opens",
--     "java.base/java.util=ALL-UNNAMED",
--     "--add-opens",
--     "java.base/java.lang=ALL-UNNAMED"
--   },

  -- cmd_env = {
    -- JAR = "/Volumes/Projects/eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/plugins/org.eclipse.equinox.launcher_*.jar",
  -- },
-- }
--

local lua_settings = {
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
}


local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()

  print(vim.inspect(servers))

  for _, server in ipairs(servers) do
    local config = {
      on_attach = custom_attach,
      capabilities = capabilities,
    }

    if server == "typescript" then
      function config.on_attach(client)
        -- Disable ts builtin formatting
        client.resolved_capabilities.document_formatting = false
        custom_attach(client)
      end
      config.cmd = {"node", "/Volumes/Projects/typescript-language-server/server/lib/cli.js", "--stdio", "--log-level=4"}
    end

    if server == "lua" then
      config.settings = lua_settings
    end

    lspconfig[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function ()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end

