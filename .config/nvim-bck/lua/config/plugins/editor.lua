return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the listed parsers MUST always be installed)
				ensure_installed = {
					"c",
					"lua",
					"vim",
					"vimdoc",
					"query",
					"markdown",
					"markdown_inline",
					"html",
					"css",
					"json",
					"yaml",
					"toml",
					"javascript",
					"typescript",
					"tsx",
					"svelte",
					"graphql",
					"dockerfile",
					"jsonc",
					"lua",
				},
				ignore_install = {},
				modules = {},
				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = true,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = false,

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
					additional_vim_regex_highlighting = true,
				},
			})
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		config = true,
	},
	{
		"smoka7/hop.nvim",
		version = "*",
		lazy = false,
		opts = {
			keys = "etovxqpdygfblzhckisuran",
		},
		config = function(_, opts)
			local hop = require("hop")
			hop.setup(opts)
			local hop_hint = require("hop.hint")

			vim.keymap.set("", "f", function()
				---@diagnostic disable-next-line: missing-fields
				return hop.hint_char1({
					direction = hop_hint.HintDirection.AFTER_CURSOR,
					current_line_only = true,
				})
			end, { remap = true })

			vim.keymap.set("", "F", function()
				---@diagnostic disable-next-line: missing-fields
				return hop.hint_char1({
					direction = hop_hint.HintDirection.BEFORE_CURSOR,
					current_line_only = true,
				})
			end, { remap = true })

			vim.keymap.set("", "<leader>h", function()
				---@diagnostic disable-next-line: missing-fields
				hop.hint_words({
					direction = hop_hint.HintDirection.AFTER_CURSOR,
					current_line_only = true,
				})
			end, { desc = "Hop word" })
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		config = function()
			local builtin = require("telescope.builtin")
			require("telescope").setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
					},
					file_ignore_patterns = {
						"node_modules/.*",
						"%.git/.*",
						"%.DS_Store",
						"dist/.*",
						"build/.*",
						"%.lock",
					},
				},
				pickers = {
					find_files = {
						--theme = "ivy",
						hidden = true,
					},
					live_grep = {
						--theme = "ivy",
						hidden = true,
					},
				},
			})
			vim.keymap.set("n", "<leader>fd", builtin.find_files, { desc = "Telescope find files" })
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
		end,
	},
	{
		"mg979/vim-visual-multi",
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "┊" },
		},
	},
	{
		"echasnovski/mini.surround",
		version = "*",
		config = true,
	},
	--[[ {
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
    -- stylua: ignore
    keys = {
      { "f", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    },
	} ]]
	{ "echasnovski/mini.diff", version = false, config = true },
	{
		"kdheepak/lazygit.nvim",
		cmd = {
			"LazyGit",
			"LazyGitConfig",
			"LazyGitCurrentFile",
			"LazyGitFilter",
			"LazyGitFilterCurrentFile",
		},
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
		},
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equivalent to setup({}) function
	},
	{
		"ramilito/kubectl.nvim",
		lazy = true,
		keys = {
			{
				"<leader>k",
				'<cmd>lua require("kubectl").toggle()<cr>',
				desc = "Toggle kubectl",
				noremap = true,
				silent = true,
			},
		},
		config = function(_, opts)
			require("kubectl").setup(opts)
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = function()
			-- Toggle the profiler
			Snacks.toggle.profiler():map("<leader>pp")
			-- Toggle the profiler highlights
			Snacks.toggle.profiler_highlights():map("<leader>ph")
			return {
				indent = {},
				dashboard = {
					enabled = true,
					preset = {
						header = [[
                                     ,
              ,-.       _,---._ __  / \
             /  )    .-'       `./ /   \
            (  (   ,'            `/    /|
             \  `-"             \'\   / |
              `.              ,  \ \ /  |
               /`.          ,'-`----Y   |
              (            ;        |   '
              |  ,-.    ,-'         |  / 
              |  | (   |        hjw | /  
              )  |  \  `.___________|/   
              `--'   `--'                
            ]],
					},
				},
			}
		end,
	},
}
