return {
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "v0.*",
		opts_extend = { "sources.default" },
		config = function()
			local opts = {
				keymap = { preset = "default" },

				appearance = {
					nerd_font_variant = "mono",
					use_nvim_cmp_as_default = true,
				},

				completion = {
					documentation = {
						auto_show = true,
						auto_show_delay_ms = 150,
					},
				},

				signature = {
					enabled = true,
				},
			}
			--opts = vim.tbl_deep_extend("force", opts, require("nvchad.cmp"))
			require("blink.cmp").setup(opts)
		end,
	},
	{
		"numToStr/Comment.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- import comment plugin safely
			local comment = require("Comment")

			local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

			-- enable comment
			comment.setup({
				-- for commenting tsx, jsx, svelte, html files
				pre_hook = ts_context_commentstring.create_pre_hook(),
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local todo_comments = require("todo-comments")

			-- set keymaps
			local keymap = vim.keymap -- for conciseness

			keymap.set("n", "]t", function()
				todo_comments.jump_next()
			end, { desc = "Next todo comment" })

			keymap.set("n", "[t", function()
				todo_comments.jump_prev()
			end, { desc = "Previous todo comment" })

			todo_comments.setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				log_level = vim.log.levels.TRACE,
				formatters_by_ft = {
					--[[ javascript = { "eslint_d" },
	    typescript = { "eslint_d" },
	    javascriptreact = { "eslint_d" },
	    typescriptreact = { "eslint_d" }, ]]
					svelte = { "biome" },
					css = { "prettier" },
					json = { "prettier" },
					html = { "prettier" },
					yaml = { "prettier" },
					markdown = { "prettier" },
					lua = { "stylua" },
					graphql = { "prettier" },
					docker = { "hadolint" },
					go = { "goimports", "gofmt" },
				},
				format_on_save = {
					lsp_format = "fallback",
					timeout_ms = 1000,
				},
				--[[ formatters = {
	eslint_d = {
	lsp_format = "prefer",
	timeout_ms = 1500,
	},
	}, ]]
			})

			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				conform.format({
					lsp_format = "fallback",
					async = true,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint" },
				typescript = { "eslint" },
				javascriptreact = { "eslint" },
				typescriptreact = { "eslint" },
				svelte = { "eslint" },
				yaml = { "yamllint" },
				docker = { "hadolint" },
				go = { "golangcilint" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

			vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					local get_clients = vim.lsp.get_clients
					local client = get_clients({ bufnr = 0 })[1] or {}
					lint.try_lint(nil, { cwd = client.root_dir })
				end,
			})

			vim.keymap.set("n", "<leader>cl", function()
				lint.try_lint()
			end, { desc = "Trigger [l]inting for current file" })
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		dependencies = {
			{
				"zbirenbaum/copilot.lua",
				cmd = "Copilot",
				build = ":Copilot auth",
				opts = {
					suggestion = {
						enabled = true,
						auto_trigger = true,
						keymap = {
							accept = "<C-l>",
						},
					},
					panel = { enabled = true },
					filetypes = {
						markdown = true,
						help = true,
						-- Add more filetypes as needed
					},
				},
			},
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		opts = {
			debug = false, -- Enable debugging
			-- Add more options as needed
		},
		config = function(_, opts)
			local ok, chat = pcall(require, "CopilotChat")
			if not ok then
				vim.notify("Failed to load CopilotChat", vim.log.levels.ERROR)
				return
			end
			chat.setup(opts)

			vim.keymap.set("n", "<leader>at", function()
				chat.toggle({
					window = {
						layout = "float",
					},
				})
			end, { desc = "Open CopilotChat" })
		end,
	},
}
