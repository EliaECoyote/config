local lspconfig = require  "lspconfig"
local lsp_status = require  "lsp-status"
local lspinstall = require  "lspinstall"

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

local eslint = {
  -- formatCommand = "node /Users/elia.camposilvan/dd/web-ui/.yarn/sdks/eslint/bin/eslint --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  formatCommand = "eslint_d --stdin --fix-to-stdout --stdin-filename=${INPUT}",
  formatStdin = true,
  rootMarkers = {
    "package.json", ".eslintrc.js", ".eslintrc.yaml", ".eslintrc.yml",
    ".eslintrc.json",
  },
}

local prettier = {
  -- formatCommand = "node /Users/elia.camposilvan/dd/web-ui/.yarn/sdks/prettier ${INPUT}",
  formatCommand = 'prettierd "${INPUT}"',
  formatStdin = true,
  env = {
    -- Note: kill `prettierd` process to apply `env` changes
    string.format("PRETTIERD_DEFAULT_CONFIG=%s",
                  vim.fn.expand("~/.config/nvim/defaults/.prettierrc.yaml")),
  },
}

local lua_format = {
  formatCommand = "lua-format -i --config=$HOME/.config/nvim/defaults/.lua-format",
  formatStdin = true,
}

local black = {formatCommand = "black --quiet -", formatStdin = true}

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
    telemetry = {enable = false},
  },
}

local efm_settings = {
  rootMarkers = {".git/", "ROOT"},
  languages = {
    lua = {lua_format},
    javascript = {eslint, prettier},
    javascriptreact = {eslint, prettier},
    typescript = {eslint, prettier},
    typescriptreact = {eslint, prettier},
    ["javascript.jsx"] = {eslint, prettier},
    ["typescript.tsx"] = {eslint, prettier},
    html = {prettier},
    css = {prettier},
    json = {prettier},
    yaml = {prettier},
    python = {black},
  },
}

local function setup_servers()
  lspinstall.setup()
  local servers = lspinstall.installed_servers()

  -- print(vim.inspect(servers))

  for _, server in ipairs(servers) do
    local config = {on_attach = custom_attach, capabilities = capabilities}

    if server == "typescript" then
      function config.on_attach(client)
        -- Disable ts builtin formatting
        client.resolved_capabilities.document_formatting = false
        custom_attach(client)
      end
      config.cmd = {
        "node",
        "/Volumes/Projects/typescript-language-server/server/lib/cli.js",
        "--stdio", "--log-level=4",
      }
    end

    if server == "html" then
      config.filetypes = {
        "html", "aspnetcorerazor", "blade", "django-html", "edge", "ejs",
        "eruby", "gohtml", "haml", "handlebars", "hbs", "html", "html-eex",
        "jade", "leaf", "liquid", "mustache", "njk", "nunjucks", "php", "razor",
        "slim", "twig", -- mixed
        "vue", "svelte",
      }
    end

    if server == "lua" then config.settings = lua_settings end

    if server == "efm" then
      config.cmd = {
        'efm-langserver', '-logfile', '/tmp/efm.log', '-loglevel', '10',
      }
      config.root_dir = require("lspconfig").util.root_pattern  {".git/", "."}
      config.filetypes = {
        "lua", "javascript", "javascriptreact", "typescript", "typescriptreact",
        "javascript.jsx", "typescript.jsx", "html", "css", "json", "yaml",
        "python",
      }
      config.init_options = {documentFormatting = true, codeAction = true}
      config.settings = efm_settings
    end

    lspconfig[server].setup(config)
  end
end

setup_servers()

-- Automatically reload after `:LspInstall <server>` so we don't have to restart neovim
lspinstall.post_install_hook = function()
  setup_servers() -- reload installed servers
  vim.cmd("bufdo e") -- this triggers the FileType autocmd that starts the server
end
