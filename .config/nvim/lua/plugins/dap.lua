-- -- Import utility functions
-- local util = require("util")
local homeDir = os.getenv("HOME")
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")

return {
	-- Configure debug adapter
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = function(_, opts)
					opts.ensure_installed = opts.ensure_installed or {}
					table.insert(opts.ensure_installed, "js-debug-adapter")
				end,
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					require("dap-vscode-js").setup({
						debugger_path = homeDir .. "/apps/vscode-js-debug",
						adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
					})
				end,
			},
			{
				"mfussenegger/nvim-dap-python",
				keys = {
					{
						"<leader>dPt",
						function()
							require("dap-python").test_method()
						end,
						desc = "Debug Method",
						ft = "python",
					},
					{
						"<leader>dPc",
						function()
							require("dap-python").test_class()
						end,
						desc = "Debug Class",
						ft = "python",
					},
				},
				config = function()
					require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
				end,
			},
			{
				"rcarriga/nvim-dap-ui",

				config = function()
					local dap = require("dap")
					local dapui = require("dapui")
					dapui.setup()
					-- Auto open debug ui
					dap.listeners.after.event_initialized["dapui_config"] = function()
						require("dapui").open()
					end
				end,
			},
			{ "theHamsta/nvim-dap-virtual-text" },
		},
		config = function()
			local dap = require("dap")
			for _, language in ipairs({ "typescript", "javascript", "vue" }) do
				local yarnPathHandle = io.popen("which yarn")
				local yarnPathWithSpace = yarnPathHandle:read("*a")
				yarnPathHandle:close()
				yarnPath = string.gsub(yarnPathWithSpace, "\n", "")
				require("dap").configurations[language] = {
					{
						type = "pwa-node",
						request = "attach",
						name = "[1] Attach 5858",
						protocol = "inspector",
						sourceMaps = true,
						trace = true,
						-- processId = require'dap.utils'.pick_process,
						--cwd = "${workspaceFolder}",
						port = 5858,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "[2] Run jest test on file",
						cwd = vim.fn.getcwd(),
						runtimeArgs = { "--inspect-brk", yarnPath, "test", "${relativeFile}" },
						sourceMaps = true,
						protocol = "inspector",
						skipFiles = { "<node_internals>/**/*.js" },
						console = "integratedTerminal",
						port = 9229,
						-- protocol = inspector,
					},
					{
						type = "pwa-node",
						request = "launch",
						name = "[3] Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "[4] Attach select",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
					--{
					--type = "pwa-chrome",
					--request = "launch",
					--name = "client: chrome",
					--url = "http://localhost:4000",
					--webRoot = "${workspaceFolder}",
					--},
				}
			end

			dap.configurations.python = {
				{
					type = "python",
					request = "attach",
					name = "[5] Attach remote",
					port = 5678,
					--           #mode = "remote",
					-- host = function()
					-- 	local host = vim.fn.input("Host [127.0.0.1]: ")
					-- 	return host ~= "" and host or "127.0.0.1"
					-- end,
					-- port = function()
					-- 	return tonumber(vim.fn.input("Port [8080]: ")) or 8080
					-- end,
				},
			}

			if not dap.adapters.node then
				dap.adapters.node = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			-- require("dap.ext.vscode").load_launchjs(nil, {
			-- 	node = { "javascript", "typescript" },
			-- })

			-- Styles
			vim.api.nvim_set_hl(0, "blue", { fg = "#3d59a1" })
			vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
			vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
			vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })

			vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "green", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "green", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "red", linehl = "", numhl = "" })
			vim.fn.sign_define("DapStopped", { text = "󰁕 ", texthl = "yellow", linehl = "yellow", numhl = "yellow" })
			vim.fn.sign_define("DapLogPoint", { text = "󱂅 ", texthl = "green", linehl = "", numhl = "" })
		end,
	},

	-- Configure test runner
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/neotest-jest",
			"nvim-neotest/nvim-nio",
		},
		opts = {
			adapters = {
				["neotest-jest"] = {
					cwd = function()
						return vim.fn.getcwd()
					end,
				},
			},
		},
	},
}
