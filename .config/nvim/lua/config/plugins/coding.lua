return {
	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-buffer", -- source for text in buffer
			"hrsh7th/cmp-path", -- source for file system paths
			{
				"L3MON4D3/LuaSnip",
				-- follow latest release.
				version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
			},
			"saadparwaiz1/cmp_luasnip", -- for autocompletion
			"rafamadriz/friendly-snippets", -- useful snippets
			"onsails/lspkind.nvim", -- vs-code like pictograms
		},
		config = function()
			local cmp = require("cmp")

			local luasnip = require("luasnip")

			--[[ -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
			require("luasnip.loaders.from_vscode").lazy_load() ]]

			local opts = {
				completion = {
					completeopt = "menu,menuone,preview,noselect",
				},
				snippet = { -- configure how nvim-cmp interacts with snippet engine
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<C-y>"] = cmp.mapping.confirm({ select = false }),
				}),
				-- sources for autocompletion
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- snippets
					{ name = "buffer" }, -- text within current buffer
					{ name = "path" }, -- file system paths
				}),
			}

			opts = vim.tbl_deep_extend("force", opts, require("nvchad.cmp"))

			cmp.setup(opts)
		end,
},
{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	{
		"saghen/blink.cmp",
		dependencies = "rafamadriz/friendly-snippets",
		version = "v0.*",
		enabled = false,
		opts = {

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
		},
		opts_extend = { "sources.default" },
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
					timeout_ms = 5000,
				},
				--[[ formatters = {
	eslint_d = {
	lsp_format = "prefer",
	timeout_ms = 1500,
	},
	}, ]]
			})

			vim.keymap.set({ "n", "v" }, "<leader>cf", function()
				print("formatting")
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

			vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
				group = lint_augroup,
				callback = function()
					local get_clients = vim.lsp.get_clients
					local client = get_clients({ bufnr = 0 })[1] or {}
					if client.name ~= "vtsls" then
						lint.try_lint(nil, { cwd = client.root_dir })
					end
				end,
			})

			vim.keymap.set("n", "<leader>cl", function()
				lint.try_lint()
			end, { desc = "Trigger [l]inting for current file" })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		enabled = function()
			local isThales = vim.fn.getenv("IS_THALES")

			if isThales == "true" then
				return false
			else
				return true
			end
		end,
		build = ":Copilot auth",
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-CR>",
				},
			},
			panel = { enabled = true },
			filetypes = {
				markdown = true,
				help = true,
				["*"] = true,
				-- Add more filetypes as needed
			},
		},
	},
	--[[ {
		"CopilotC-Nvim/CopilotChat.nvim",
		event = "BufEnter",
		branch = "main",
		enabled = function()
			local isThales = vim.fn.getenv("IS_THALES")

			if isThales == "true" then
				return false
			else
				return true
			end
		end,
		dependencies = {
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
	}, ]]
	{
		"milanglacier/minuet-ai.nvim",
		enabled = function()
			local isThales = vim.fn.getenv("IS_THALES")

			if isThales == "true" then
				return true
			else
				return false
			end
		end,
		config = function()
			require("minuet").setup({
				-- Your configuration options here
				virtualtext = {
					auto_trigger_ft = { "*" },
					keymap = {
						accept = "<C-CR>",
						accept_line = "<C-TAB>",
						-- Cycle to prev completion item, or manually invoke completion
						prev = "<C-h>",
						-- Cycle to next completion item, or manually invoke completion
						next = "<C-l>",
						dismiss = "<A-e>",
					},
				},
				notify = false,
				provider = "openai_fim_compatible",
				provider_options = {
					openai_fim_compatible = {
						model = "qwen2.5-coder:1.5b-base",
						end_point = "http://localhost:11434/v1/completions",
						name = "Ollama",
						stream = true,
						api_key = "IS_THALES",
						optional = {
							stop = nil,
							max_tokens = nil,
						},
					},
				},
			})
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		enabled = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			local isThales = vim.fn.getenv("IS_THALES")

			local adapterToUse = "copilot"
			if isThales == "true" then
				adapterToUse = "ollama"
			end

			require("codecompanion").setup({
				display = {
					show_settings = true,
					chat = {
						diff = {
							provider = "mini_diff", -- default|mini_diff
						},
					},
				},
				strategies = {
					chat = {
						adapter = adapterToUse,
					},
					inline = {
						adapter = adapterToUse,
					},
				},
				adapters = {
					ollama = function()
						return require("codecompanion.adapters").extend("openai_compatible", {
							env = {
								url = "http://localhost:11434",
								--api_key = "OpenAI_API_KEY", -- optional: if your endpoint is authenticated
								chat_url = "/v1/chat/completions", -- optional: default value, override if different
							},
							schema = {
								model = {
									default = "llama3.1:8b",
								},
							},
						})
					end,
				},
			})
		end,
	},
}
