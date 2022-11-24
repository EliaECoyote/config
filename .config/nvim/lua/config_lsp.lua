local utils_lsp = require("lib.utils_lsp")
local constants_lsp = require("lib.constants_lsp")
local lspconfig = require("lspconfig")

require('lspconfig.ui.windows').default_options.border = "rounded"

utils_lsp.setup_lsp_status()

vim.diagnostic.config({
  float = { source = "always" },
})

for _, lsp in ipairs(constants_lsp.LSP_SERVERS) do
  local config = utils_lsp.make_default_config()

  if lsp == 'denols' then
    config.capabilities = nil
    config.init_options = {
      enable = true,
      lint = false,
      unstable = false,
      importMap = "./import_map.json",
      compilerOptions = {
        target = "es6",
        lib = { "dom", "dom.iterable", "dom.asynciterable", "deno.ns" }
      }
    }
  end

  if lsp == 'tsserver' then
    config.capabilities.textDocument.completion.completionItem.snippetSupport = true
    function config.on_attach(client)
      utils_lsp.custom_attach(client)
      client.server_capabilities.documentFormattingProvider = false
    end

    config.typescript = {
      preferences = {
        importModuleSpecifier = "non-relative"
      }
    }
  end

  if lsp == "html" then
    config.filetypes = {
      "html", "aspnetcorerazor", "blade", "django-html", "edge", "ejs", "eruby",
      "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf",
      "liquid", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", -- mixed
      "vue", "svelte",
    }
  end

  if lsp == "jsonls" then
    config.capabilities.textDocument.completion.completionItem.snippetSupport = true
  end

  -- Setup sumneko_lua to show autocompletion and suggestions for neovim lua
  -- apis.
  -- cf. https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/server_configurations/sumneko_lua.lua
  if lsp == "sumneko_lua" then
    config.settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          -- Disable annoyting popups on startup
          checkThirdParty = false
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = { enable = false },
      },
    }
  end

  if lsp == "eslint" then
    config.settings = {
      -- `packageManager` and `nodePath` are set to ensure that the eslint LS
      -- will work with pnp.
      nodePath = "/Users/elia.camposilvan/dd/web-ui/.yarn/sdks",
      packageManager = "yarn",
      filetypes = utils_lsp.ESLINT_FILETYPES,
    }
  end

  if lsp == "pyright" then
    config = { on_attach = utils_lsp.custom_attach }
  end

  -- jdtls is already handled by ~/.config/nvim/ftplugin/java.lua (through the
  -- nvim-jdtls plugin).
  -- We thus ignore its LSP setup here, in order to avoid setting up the LSP
  -- with 2 different clients.
  if lsp ~= "jdtls" then
    lspconfig[lsp].setup(config)
  end
end
