local utils_lsp = require("lib.utils_lsp")
local command_resolver = require("null-ls.helpers.command_resolver")
local null_ls = require("null-ls")

local resolve_from_node_modules = command_resolver.from_node_modules()
local resolve_from_yarn_pnp = command_resolver.from_yarn_pnp()

null_ls.setup({
  on_attach = utils_lsp.custom_attach,
  sources = {
    null_ls.builtins.formatting.prettier.with({
      timeout = 8000,
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
        -- "json",
        -- "jsonc",
        "yaml",
        "markdown",
        "graphql",
        "handlebars",
      },
    }),
    -- null_ls.builtins.diagnostics.pydocstyle,
    null_ls.builtins.formatting.isort,
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.google_java_format.with({
      timeout = 8000,
    }),
    null_ls.builtins.formatting.shfmt.with({
      -- `-i 2` sets indentation to 2 spaces.
      args = { "-filename", "$FILENAME", "-i", "2" }
    }),
  },
})
