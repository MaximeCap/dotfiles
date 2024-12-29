return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	"nvim-lua/plenary.nvim",
	"christoomey/vim-tmux-navigator",
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	{
		"nvchad/ui",
		config = function()
			require("nvchad")
		end,
	},
	{
		"nvchad/base46",
		lazy = true,
		build = function()
			require("base46").load_all_highlights()
		end,
	},
	{
		"nvchad/volt",
	},
}
