local jdtls = require("jdtls")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local constants_path = require("lib.constants_path")
local lspconfig_util = require("lspconfig.util")
-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
local workspace_dir = vim.fn.expand('$HOME/dev/jdtls-data-config/') .. project_name
local utils_lsp = require("lib.utils_lsp")
local utils_table = require("lib.utils_table")

local config = utils_table.merge(
  utils_lsp.make_default_config(),
  {
    -- The command that starts the language server
    -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
    cmd = {
      "java",

      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xms1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens", "java.base/java.util=ALL-UNNAMED",
      "--add-opens", "java.base/java.lang=ALL-UNNAMED",

      "-jar",
      constants_path.LSP_SERVERS .. "/jdtls/plugins/org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar",
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                                       ^^^^^^^^^^^^^^
      -- Must point to the                                                     Change this to
      -- eclipse.jdt.ls installation                                           the actual version

      "-configuration", constants_path.LSP_SERVERS .. "/jdtls/config_mac",
      -- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^        ^^^^^^
      -- Must point to the                      Change to one of `linux`, `win` or `mac`
      -- eclipse.jdt.ls installation            Depending on your system.


      -- 💀
      -- See `data directory configuration` section in the README
      "-data", workspace_dir
    },
    -- 💀
    -- This is the default if not provided, you can remove it. Or adjust as needed.
    -- One dedicated LSP server & client will be started per unique root_dir
    root_dir = require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew" }),
    -- Here you can configure eclipse.jdt.ls specific settings
    -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
    -- for a list of options
    settings = {
      java = {
        home = "/Users/elia.camposilvan/.sdkman/candidates/maven/current",
        import = {
          gradle = {
            jvmArguments = { "-Xms1024m", "", "-Xmx4096m" }
          }
        }
      }
    },
    -- Language server `initializationOptions`
    -- You need to extend the `bundles` with paths to jar files
    -- if you want to use additional eclipse.jdt.ls plugins.
    --
    -- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
    --
    -- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
    init_options = {
      bundles = {}
    },
    capabilities = cmp_nvim_lsp.default_capabilities()
  })

-- Disable blocking messages
-- cf. https://github.com/mfussenegger/nvim-jdtls/issues/207
config.handlers = config.handlers or {}
config.handlers['language/status'] = function()
end

jdtls.start_or_attach(config)

-- Updates the pom.xml path, in order to make tests run in "multi-root" projects.
local current_path = vim.api.nvim_buf_get_name(0)
local pom_root = lspconfig_util.search_ancestors(current_path, function(path)
  if lspconfig_util.path.is_file(lspconfig_util.path.join(path, "pom.xml")) then
    return path
  end
end)

if pom_root ~= nil then
  vim.g["test#project_root"] = pom_root
end

-- nnoremap <leader>df <Cmd>lua require'jdtls'.test_class()<CR>
-- nnoremap <leader>dn <Cmd>lua require'jdtls'.test_nearest_method()<CR>
