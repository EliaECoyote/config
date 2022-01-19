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

-- local black = {formatCommand = "black --quiet -", formatStdin = true}

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
    html = {eslint, prettier},
    css = {prettier},
    json = {prettier},
    yaml = {prettier},
  },
}

return efm_settings
