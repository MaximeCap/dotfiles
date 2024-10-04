return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
			-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
			{
				"s1n7ax/nvim-window-picker",
				version = "2.*",
				config = function()
					require("window-picker").setup({
						filter_rules = {
							include_current_win = false,
							autoselect_one = true,
							-- filter using buffer options
							bo = {
								-- if the file type is one of following, the window will be ignored
								filetype = { "neo-tree", "neo-tree-popup", "notify" },
								-- if the buffer type is one of following, the window will be ignored
								buftype = { "terminal", "quickfix" },
							},
						},
					})
				end,
			},
		},
		cmd = "Neotree",
		init = function()
			-- the remote file handling part
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("RemoteFileInit", { clear = true }),
				callback = function()
					local f = vim.fn.expand("%:p")
					for _, v in ipairs({ "dav", "fetch", "ftp", "http", "rcp", "rsync", "scp", "sftp" }) do
						local p = v .. "://"
						if f:sub(1, #p) == p then
							vim.cmd([[
              unlet g:loaded_netrw
              unlet g:loaded_netrwPlugin
              runtime! plugin/netrwPlugin.vim
              silent Explore %
            ]])
							break
						end
					end
					vim.api.nvim_clear_autocmds({ group = "RemoteFileInit" })
				end,
			})
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
				callback = function()
					local f = vim.fn.expand("%:p")
					if vim.fn.isdirectory(f) ~= 0 then
						vim.cmd("Neotree current dir=" .. f)
						vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
					end
				end,
			})
			-- keymaps
		end,
		keys = {
			{
				"<leader>ee",
				function()
					require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
				end,
				desc = "Explorer NeoTree (cwd)",
			},
			{
				"<leader>ge",
				function()
					require("neo-tree.command").execute({ source = "git_status", toggle = true })
				end,
				desc = "Git Explorer",
			},
		},
		opts = {
			sources = { "filesystem", "buffers", "git_status" },
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			filesystem = {
				hijack_netrw_behavior = "open_current",
				bind_to_cwd = false,
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			window = {
				mappings = {
					["l"] = "open",
					["h"] = "close_node",
					["<space>"] = "none",
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "c")
						end,
						desc = "Copy Path to Clipboard",
					},
					["O"] = {
						function(state)
							require("lazy.util").open(state.tree:get_node().path, { system = true })
						end,
						desc = "Open with System Application",
					},
					["P"] = { "toggle_preview", config = { use_float = false } },
				},
			},
			default_component_configs = {
				indent = {
					with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
					expander_collapsed = "",
					expander_expanded = "",
					expander_highlight = "NeoTreeExpander",
				},
				git_status = {
					symbols = {
						unstaged = "󰄱",
						staged = "󰱒",
					},
				},
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 500
		end,
		opts = {
			spec = {
				{
					mode = { "n", "v" },
					{ "<leader>d", group = "code" },
					{ "<leader>c", group = "code" },
					{ "<leader>e", group = "file/find" },
					{ "<leader>g", group = "git" },
					{ "<leader>gh", group = "hunks" },
					{ "<leader>q", group = "quit/session" },
					{ "<leader>s", group = "search" },
					{ "<leader>t", group = "[T]odo Comments" },
					{ "<leader>w", group = "Window" },
					{ "<leader>x", group = "Trouble" },
					{ "[", group = "prev" },
					{ "]", group = "next" },
					{ "g", group = "goto" },
					{ "gs", group = "surround" },
					{ "z", group = "fold" },
				},
			},
		},
	},
	{ "MunifTanjim/nui.nvim", lazy = true },

	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"folke/todo-comments.nvim",
		},
		keys = {
			-- git
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Status" },
			{
				"<leader>gf",
				"<cmd>Telescope git_files<cr>",
				{ desc = "Find Files (git-files)" },
			},
			-- search
			{
				"<leader>se",
				"<cmd>Telescope find_files<cr>",
				{ desc = "Fuzzy find files in cwd" },
			},
			{ "<leader>sb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
			{
				"<leader>sg",
				"<cmd>Telescope git_files<cr>",
				desc = "Find Files (git-files)",
			},
			{ '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{
				"<leader>ss",
				"<cmd>Telescope live_grep<cr>",
				{ desc = "Find string in cwd" },
			},
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{
				"<leader>sd",
				"<cmd>Telescope diagnostics bufnr=0<cr>",
				desc = "Document Diagnostics",
			},
			{
				"<leader>sD",
				"<cmd>Telescope diagnostics<cr>",
				desc = "Workspace Diagnostics",
			},
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{
				"<leader>sH",
				"<cmd>Telescope highlights<cr>",
				desc = "Search Highlight Groups",
			},
			{ "<leader>sj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sl", "<cmd>Telescope loclist<cr>", desc = "Location List" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
		},
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
				},
			})

			telescope.load_extension("fzf")
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local lualine = require("lualine")
			local lazy_status = require("lazy.status")

			lualine.setup({
				extensions = { "neo-tree", "lazy" },
				options = {
					theme = "catppuccin",
					globalstatus = vim.o.laststatus == 3,
					disabled_filetypes = { statusline = { "neo-tree", "alpha" } },
					component_separators = "",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
					lualine_b = { "filename", "branch" },
					lualine_c = { "diagnostics" },
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#ff9e64" },
						},
						lualine_y = { "filetype" },
						lualine_z = {
							{ "location", separator = { right = "" }, left_padding = 2 },
						},
					},
				},
			})
		end,
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
	},
	{
		"szw/vim-maximizer",
		keys = {
			{ "<leader>wm", "<cmd>MaximizerToggle<CR>", desc = "Maximize / minimize a split" },
		},
	},
	{
		"j-hui/fidget.nvim",
		opts = {
			-- options
		},
	},
	{
		"FabianWirth/search.nvim",
		dependencies = { "nvim-telescope/telescope.nvim" },
		config = function()
			local builtin = require("telescope.builtin")
			local search = require("search")
			search.setup({
				append_tabs = { -- append_tabs will add the provided tabs to the default ones
					{
						"Commits", -- or name = "Commits"
						builtin.git_commits, -- or tele_func = require('telescope.builtin').git_commits
						available = function() -- optional
							return vim.fn.isdirectory(".git") == 1
						end,
					},
				},
			})
			vim.keymap.set("n", "<leader><leader>", search.open, { desc = "Open search" })
		end,
	},
}
