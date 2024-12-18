local js_based_languages = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
}

return {
	{
		"Joakker/lua-json5",
		build = "./install.sh",
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup()
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			{
				"leoluz/nvim-dap-go",
				ft = "go",
				opts = {
					dap_configurations = {
						{
							type = "go",
							name = "Attach remote",
							mode = "remote",
							request = "attach",
						},
					},
					delve = {
						path = "dlv",
						initialize_timeout_sec = 20,
						port = "${port}",
					},
				},
				config = function(_, opts)
					local dapGo = require("dap-go")
					dapGo.setup(opts)
				end,
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				dependencies = {
					"microsoft/vscode-js-debug",
					version = "1.x",
					build = "npm i && npm run compile vsDebugServerBundle && mv dist out",
				},
				config = function()
					local dap = require("dap")
					--local utils = require 'dap.utils'
					local dap_js = require("dap-vscode-js")
					--local mason = require 'mason-registry'

					---@diagnostic disable-next-line: missing-fields
					dap_js.setup({
						-- debugger_path = mason.get_package('js-debug-adapter'):get_install_path(),
						debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
						adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
					})

					local langs = { "javascript", "typescript", "svelte", "astro" }
					for _, lang in ipairs(langs) do
						dap.configurations[lang] = {
							{
								type = "pwa-node",
								request = "attach",
								name = "Attach debugger to existing `node --inspect` process",
								cwd = "${workspaceFolder}",
								skipFiles = {
									"${workspaceFolder}/node_modules/**/*.js",
									"${workspaceFolder}/packages/**/node_modules/**/*.js",
									"${workspaceFolder}/packages/**/**/node_modules/**/*.js",
									"<node_internals>/**",
									"node_modules/**",
								},
								sourceMaps = true,
								resolveSourceMapLocations = {
									"${workspaceFolder}/**",
									"!**/node_modules/**",
								},
							},
						}
					end
				end,
			},
		},
		config = function()
			table.insert(vim._so_trails, "/?.dylib")
			local keymap = vim.keymap
			local dap = require("dap")
			keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			keymap.set("n", "<Leader>dc", ':lua require("dap").continue()<CR>', { desc = "Continue" })
			keymap.set("n", "<Leader>dC", ':lua require("dap").disconnect()<CR>', { desc = "Disconnect" })
			keymap.set("n", "<Leader>dn", ':lua require("dap").step_over()<CR>', { desc = "Step Over" })
			keymap.set("n", "<Leader>dN", ':lua require("dap").step_into()<CR>', { desc = "Step Into" })
			keymap.set("n", "<Leader>do", ':lua require("dap").step_out()<CR>', { desc = "Step Out" })
			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Attach",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = 'Start Chrome with "localhost"',
						host = "localhost",
						port = function()
							local val = tonumber(vim.fn.input("Port: "))
							return val
						end,
						webRoot = "${workspaceFolder}",
						userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
					},
				}
			end
		end,
	},
}
