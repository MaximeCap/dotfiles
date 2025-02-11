return {
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			view_options = {
				show_hidden = true,
			},
		},
		config = function(_, opts)
			vim.keymap.set("n", "<leader>e", ":e %:h<CR>")
			require("oil").setup(opts)
		end,
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},
}
