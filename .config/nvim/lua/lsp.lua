local lsp_status = require  "lsp-status"
local lsp_installer = require  "nvim-lsp-installer"
local null_ls = require "null-ls"
local eslint_config = require("lspconfig.server_configurations.eslint")
local typescript_config = require("lspconfig.server_configurations.tsserver")

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
  set_keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<cr>", options)
  set_keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<cr>", options)
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

null_ls.setup({
  on_attach = custom_attach,
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.completion.spell,
  },
})

local function setup_server(server)
  local config = {on_attach = custom_attach, capabilities = capabilities}

  if server.name == "typescript" then
    function config.on_attach(client)
      -- Disable ts builtin formatting
      client.resolved_capabilities.document_formatting = false
      custom_attach(client)
    end
    config.cmd = { "yarn", "exec", unpack(typescript_config.default_config.cmd) }
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

  if server.name == "eslint" then
    -- Ensures that eslint works with pnp
    config.cmd = { "yarn", "exec", unpack(eslint_config.default_config.cmd) }
    function config.on_attach(client)
      -- neovim's LSP client does not currently support dynamic
      -- capabilities registration, so we need to set the resolved
      -- capabilities of the eslint server ourselves!
      client.resolved_capabilities.document_formatting = true
      custom_attach(client)
    end
    config.settings = {
      -- this will enable formatting
      format = { enable = true }
    }
  end

  server:setup(config)
end

lsp_installer.on_server_ready(setup_server)
