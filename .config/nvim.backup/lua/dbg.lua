vim.g.dap_virtual_text = true
require("dapui").setup()

vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })

vim.fn.sign_define(
	"DapBreakpoint",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapBreakpointCondition",
	{ text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
	"DapLogPoint",
	{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define(
	"DapBreakpointRejected",
	{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end

require("nvim-dap-virtual-text").setup({
	virt_text_win_col = 100,
})
require("dap-vscode-js").setup({
	-- debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
	-- debugger_cmd = { 'js-debug-adapter' },
	--  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },

	-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
	-- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
	adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
})

for _, language in ipairs({ "typescript", "javascript" }) do
	local yarnPathHandle = io.popen("which yarn")
	local yarnPathWithSpace = yarnPathHandle:read("*a")
	yarnPathHandle:close()
	yarnPath = string.gsub(yarnPathWithSpace, "\n", "")
	require("dap").configurations[language] = {
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			protocol = inspector,
			sourceMaps = true,
			trace = true,
			-- processId = require'dap.utils'.pick_process,
			--cwd = "${workspaceFolder}",
			port = 5858,
		},
		{
			type = "pwa-node",
			request = "launch",
			name = "Run jest test on file",
			cwd = vim.fn.getcwd(),
			runtimeArgs = { "--inspect-brk", yarnPath, "test", "${relativeFile}" },
			sourceMaps = true,
			protocol = "inspector",
			skipFiles = { "<node_internals>/**/*.js" },
			console = "integratedTerminal",
			port = 9229,
			-- protocol = inspector,
		},
	}
end

--[[
dap.configurations.typescript = {
 {
    name ='Attach to typescript',
    type= 'node2',
    request= 'attach',
    protocol= 'inspector'
  }
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    name = 'Attach to running loopback',
    type = 'node2',
    request = 'attach',
    protocol = 'inspector',
    port = 5858
  },
}
]]
--
