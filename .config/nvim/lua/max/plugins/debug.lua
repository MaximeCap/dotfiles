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
			keymap.set("n", "<Leader>di", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			keymap.set("n", "<Leader>ds", ':lua require("dap").continue()<CR>', { desc = "Continue" })
			keymap.set("n", "<Leader>dS", ':lua require("dap").disconnect()<CR>', { desc = "Disconnect" })
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
	--[[ {
		"mfussenegger/nvim-dap",
		dependencies = {
			"theHamsta/nvim-dap-virtual-text",
			{
				"microsoft/vscode-js-debug",
				-- After install, build it and rename the dist directory to out
				build = "npm install --legacy-peer-deps --no-save && npx gulp vsDebugServerBundle && rm -rf out && mv dist out",
				version = "1.x",
			},
			{
				"mxsdev/nvim-dap-vscode-js",
				config = function()
					---@diagnostic disable-next-line: missing-fields
					require("dap-vscode-js").setup({
						-- Path of node executable. Defaults to $NODE_PATH, and then "node"
						-- node_path = "node",

						-- Path to vscode-js-debug installation.
						node_path = "node", -- Path to node executable
						debugger_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter", -- Path to js-debug package in Mason

						-- Command to use to launch the debug server. Takes precedence over "node_path" and "debugger_path"
						-- debugger_cmd = { "js-debug-adapter" },

						-- which adapters to register in nvim-dap
						adapters = {
							"chrome",
							"pwa-node",
							"pwa-chrome",
							"pwa-msedge",
							"pwa-extensionHost",
							"node-terminal",
						},

						-- Path for file logging
						-- log_file_path = "(stdpath cache)/dap_vscode_js.log",

						-- Logging level for output to file. Set to false to disable logging.
						-- log_file_level = false,

						-- Logging level for output to console. Set to false to disable console output.
						-- log_console_level = vim.log.levels.ERROR,
					})
				end,
			},
		},
		config = function()
			local dap = require("dap")
			local dap_virtual_text = require("nvim-dap-virtual-text")
			local keymap = vim.keymap

			keymap.set("n", "<Leader>di", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			keymap.set(
				"n",
				"<Leader>dI",
				':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>',
				{ desc = "Set breakpoint with condition" }
			)
			keymap.set("n", "<Leader>ds", ':lua require("dap").continue()<CR>', { desc = "Continue" })
			keymap.set("n", "<Leader>dS", ':lua require("dap").disconnect()<CR>', { desc = "Disconnect" })
			keymap.set("n", "<Leader>dn", ':lua require("dap").step_over()<CR>', { desc = "Step Over" })
			keymap.set("n", "<Leader>dN", ':lua require("dap").step_into()<CR>', { desc = "Step Into" })
			keymap.set("n", "<Leader>do", ':lua require("dap").step_out()<CR>', { desc = "Step Out" })

			dap_virtual_text.setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				filter_references_pattern = "<module",
				virt_text_pos = "eol",
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})

			for _, language in ipairs(js_based_languages) do
				dap.configurations[language] = {
					{
						type = "pwa-node",
						request = "launch",
						name = "Launch file",
						program = "${file}",
						cwd = "${workspaceFolder}",
						runtimeExecutable = "node",
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Auto attach",
						cwd = vim.fn.getcwd(),
						skipFiles = { "<node_internals>/**" },
					},
					{
						type = "pwa-node",
						request = "attach",
						name = "Choose Process",
						processId = require("dap.utils").pick_process,
						cwd = "${workspaceFolder}",
						sourceMaps = true,
					},
					{
						type = "pwa-chrome",
						request = "launch",
						name = "Launch & Debug Chrome",
						url = function()
							local co = coroutine.running()
							return coroutine.create(function()
								vim.ui.input({
									prompt = "Enter URL: ",
									default = "http://localhost:3000",
								}, function(url)
									if url == nil or url == "" then
										return
									else
										coroutine.resume(co, url)
									end
								end)
							end)
						end,
						webRoot = vim.fn.getcwd(),
						protocol = "inspector",
						sourceMaps = true,
						userDataDir = false,
					},
					{
						name = "----- ↓ launch.json configs ↓ -----",
						type = "",
						request = "launch",
					},
				}
			end
		end,
		keys = {
			{
				"<leader>da",
				function()
					if vim.fn.filereadable(".vscode/launch.json") then
						local dap_vscode = require("dap.ext.vscode")
						dap_vscode.load_launchjs(nil, {
							["pwa-node"] = js_based_languages,
							["chrome"] = js_based_languages,
							["pwa-chrome"] = js_based_languages,
						})
					end
					require("dap").continue()
				end,
				desc = "Run with Args",
			},
		},
	}, ]]
}
