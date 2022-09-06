local utils_lsp = require("lib.utils_lsp")
local command_resolver = require("null-ls.helpers.command_resolver")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local null_ls = require("null-ls")
local lspconfig = require("lspconfig")
local typescript_config = require("lspconfig.server_configurations.tsserver")

utils_lsp.setup_lsp_status()

local servers = {
  "tsserver",
  "html",
  "cssls",
  "pyright",
  "eslint",
  "sumneko_lua",
  "jdtls",
}

vim.diagnostic.config({
  float = { source = "always" },
})

mason.setup({
  ui = { border = "rounded" },
})
mason_lspconfig.setup({
  ensure_installed = servers
})

local resolve_from_node_modules = command_resolver.from_node_modules()
local resolve_from_yarn_pnp = command_resolver.from_yarn_pnp()

null_ls.setup({
  on_attach = utils_lsp.custom_attach,
  sources = {
    null_ls.builtins.formatting.prettier.with({
      timeout = 2000,
      dynamic_command = function(params)
        return resolve_from_yarn_pnp(params)
            or resolve_from_node_modules(params)
            or vim.fn.executable(params.command) == 1
            and params.command
      end,
      filetypes = {
        -- Here we disable JS filetypes; this is because, more often than not,
        -- prettier is run through eslint with plugins such as
        -- [eslint-plugin-prettier](https://github.com/prettier/eslint-plugin-prettier).
        -- This allows us to improve formatting performances for JS files, while
        -- keeping prettier formatting available for other filetypes.
        --
        "javascript",
        "javascriptreact",
        -- "typescript",
        -- "typescriptreact",
        "vue",
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "graphql",
        "handlebars",
      },
    }),
    -- null_ls.builtins.diagnostics.pydocstyle,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
  },
})

for _, lsp in pairs(servers) do
  local config = utils_lsp.make_default_config()

  if lsp == 'tsserver' then
    function config.on_attach(client)
      client.resolved_capabilities.document_formatting = false
      utils_lsp.custom_attach(client)
    end

    function config.on_init(client)
      local path = client.workspace_folders[1].name
      if string.match(path, "web-ui") then
        client.config.cmd = {
          "yarn",
          "exec",
          unpack(typescript_config.default_config.cmd)
        }
      end
    end
  end

  if lsp == "html" then
    config.filetypes = {
      "html", "aspnetcorerazor", "blade", "django-html", "edge", "ejs", "eruby",
      "gohtml", "haml", "handlebars", "hbs", "html", "html-eex", "jade", "leaf",
      "liquid", "mustache", "njk", "nunjucks", "php", "razor", "slim", "twig", -- mixed
      "vue", "svelte",
    }
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
      packageManager = "yarn",
      nodePath = ".yarn/sdks",
      filetypes = utils_lsp.ESLINT_FILETYPES,
      -- root_dir = function(fname)
      --   print(lspconfig.util.find_git_ancestor(fname))
      --   return lspconfig.util.find_git_ancestor(fname)
      -- end,
    }
  end

  if lsp == "pyright" then
    config = { on_attach = utils_lsp.custom_attach }
  end

  if lsp == "jdtls" then
    -- This is already handled by ~/.config/nvim/ftplugin/java.lua
    -- We return to avoid setting up the LSP with 2 different clients.
    return
  end

  lspconfig[lsp].setup(config)
end
