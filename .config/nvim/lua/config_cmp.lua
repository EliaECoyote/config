local cmp = require("cmp")

vim.api.nvim_set_option("completeopt", "menu,menuone,noselect")

cmp.setup({
  window = {
    documentation = cmp.config.window.bordered(),
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm(),
  },
  -- Note: The order matches the cmp menu's sort order.
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "buffer" },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
  -- Note: The order matches the cmp menu's sort order.
  sources = cmp.config.sources({
    { name = "cmp_git" },
    { name = "buffer" },
  })
})
