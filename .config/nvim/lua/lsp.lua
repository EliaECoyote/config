local lspconfig = require  "lspconfig"
local lsp_status = require  "lsp-status"
local lsp_installer = require  "nvim-lsp-installer"
local efm_settings = require  "efm_settings"

lsp_status.register_progress()

lsp_status.config  {
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
  properties = {"documentation", "detail", "additionalTextEdits"},
}

local function custom_attach(client)
  lsp_status.on_attach(client)
  print("LSP 🚀")

  local set_keymap = vim.api.nvim_set_keymap
  local options = {noremap = true}

  set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", options)
  set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", options)
  set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", options)
  set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", options)
  set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", options)
  set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", options)
  set_keymap("n", "<leader>0", "<cmd>lua vim.lsp.buf.formatting_seq_sync()<cr>",
             options)
  set_keymap("n", "]g", "<cmd>lua vim.lsp.diagnostic.goto_next()<cr>", options)
  set_keymap("n", "[g", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", options)
  set_keymap("n", "<leader>A", "<cmd>lua vim.lsp.buf.code_action()<cr>", options)

  -- Uncomment to enable formatting on save
  -- vim.cmd  [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
end

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
    telemetry = {enable = false},
  },
}

lsp_installer.settings({
  ui = {
    icons = {
      server_installed = "✓",
      server_pending = "➜",
      server_uninstalled = "✗",
    },
  },
  log_level = vim.log.levels.DEBUG,
})

local function setup_server(server)
  print("Setting up server " .. server.name)
  local config = {on_attach = custom_attach, capabilities = capabilities}

  if server.name == "typescript" then
    function config.on_attach(client)
      -- Disable ts builtin formatting
      client.resolved_capabilities.document_formatting = false
      custom_attach(client)
    end
    config.cmd = {
      "node", "/Volumes/Projects/typescript-language-server/server/lib/cli.js",
      "--stdio", "--log-level=4",
    }
  end

  if server.name == "html" then
    config.filetypes = {
      "html", "aspnetcorerazor", "blade", "django-html", "edge", "ejs", "eruby",
      "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf",
      "liquid", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", -- mixed
      "vue", "svelte",
    }
  end

  if server.name == "sumneko_lua" then config.settings = lua_settings end

  if server.name == "efm" then
    config.cmd = {
      'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '5',
    }
    config.root_dir = lspconfig.util.root_pattern  {".git/", "."}
    config.filetypes = {
      "lua", "javascript", "javascriptreact", "typescript", "typescriptreact",
      "javascript.jsx", "typescript.jsx", "html", "css", "json", "yaml",
      "python",
    }
    config.init_options = {documentFormatting = true, codeAction = true}
    config.settings = efm_settings
  end

  server:setup(config)
end

lsp_installer.on_server_ready(setup_server)
