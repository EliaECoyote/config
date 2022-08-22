local lsp_status = require("lsp-status")
local table_utils = require("utils.table_utils")
local command_resolver = require("null-ls.helpers.command_resolver")
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local null_ls = require("null-ls")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local typescript_config = require("lspconfig.server_configurations.tsserver")

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

-- Combine capabilities from both nvim-cmp and lsp_status.
local capabilities = cmp_nvim_lsp.update_capabilities(lsp_status.capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport.properties = {
  properties = { "documentation", "detail", "additionalTextEdits" },
}

local servers = {
  "tsserver",
  "html",
  "cssls",
  -- "pyright",
  "eslint",
  "sumneko_lua",
  "jdtls",
}

vim.diagnostic.config({
  float = { source = "always" },
})

local ESLINT_FILETYPES = {
  "javascript",
  "javascript.jsx",
  "javascriptreact",
  "typescript",
  "typescript.tsx",
  "typescriptreact",
}

function _G.format_buffer()
  vim.lsp.buf.formatting_seq_sync()
  -- Run eslint on buffers with JS filetype
  if table_utils.includes(ESLINT_FILETYPES, vim.bo.filetype) then
    vim.cmd("EslintFixAll")
  end
end

local function custom_attach(client)
  lsp_status.on_attach(client)

  local set_keymap = vim.api.nvim_set_keymap
  local options = { noremap = true }

  set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", options)
  set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", options)
  set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", options)
  set_keymap("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", options)
  set_keymap("n", "gW", "<cmd>lua vim.lsp.buf.workspace_symbol()<cr>", options)
  set_keymap("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", options)
  set_keymap("n", "<leader>0", "v:lua format_buffer()<cr>", options)
  set_keymap("n", "]g", "<cmd>lua vim.diagnostic.goto_next()<cr>", options)
  set_keymap("n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<cr>", options)

  -- Uncomment to enable formatting on save
  -- vim.api.nvim_create_autocmd("BufWritePre", {
  --   group = vim.api.nvim_create_augroup("FormatOnSave", { clear = true }),
  --   callback = format_buffer,
  -- })
end

mason.setup({
  ui = { border = "rounded" },
})
mason_lspconfig.setup({
  ensure_installed = servers
})

null_ls.setup({
  on_attach = custom_attach,
  sources = {
    null_ls.builtins.formatting.prettier.with({
      timeout = 2000,
      dynamic_command = function(params)
        return command_resolver.from_node_modules(params)
            or command_resolver.from_yarn_pnp(params)
            or vim.fn.executable(params.command) == 1 and params.command
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
        "typescript",
        "typescriptreact",
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
    -- null_ls.builtins.formatting.isort,
    -- null_ls.builtins.formatting.black,
  },
})

for _, lsp in pairs(servers) do
  local config = { on_attach = custom_attach, capabilities = capabilities }

  if lsp == 'tsserver' then
    function config.on_attach(client)
      client.resolved_capabilities.document_formatting = false
      custom_attach(client)
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

  if lsp == "jdtls" then
    config.capabilities = cmp_nvim_lsp.update_capabilities(lsp_status.capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
  end

  if lsp == "eslint" then
    -- config.settings = {
      -- `packageManager` and `nodePath` are set to ensure that the eslint LS
      -- will work with pnp.
      -- packageManager = "yarn",
      -- nodePath = ".yarn/sdks",
      -- filetypes = ESLINT_FILETYPES,
    -- }
  end

  if lsp == "pyright" then
    config = { on_attach = custom_attach }
  end

  lspconfig[lsp].setup(config)
end
