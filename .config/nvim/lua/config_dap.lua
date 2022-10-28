local constants_path = require("lib.constants_path")
local dap = require("dap")
local widgets = require("dap.ui.widgets")

vim.fn.sign_define("DapBreakpoint", { text = "🅱️ ", texthl = "", linehl = "", numhl = "" })
vim.fn.sign_define("DapStopped", { text = "🟢", texthl = "", linehl = "", numhl = "" })

dap.adapters.node2 = {
  type = "executable",
  command = constants_path.EXECUTABLES .. "/node-debug2-adapter",
  args = {}
}

vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint)
vim.keymap.set("n", "<leader>B", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end)
vim.keymap.set("n", "<leader>dc", dap.continue)
vim.keymap.set("n", "<leader>do", dap.step_over)
vim.keymap.set("n", "<leader>di", dap.step_into)
vim.keymap.set("n", "<leader>dl", dap.run_last)
vim.keymap.set("n", "<leader>dr", dap.repl.open)
vim.keymap.set("n", "<leader>dj", dap.down)
vim.keymap.set("n", "<leader>dk", dap.up)
-- vim.keymap.set("n", "K", widgets.hover)
