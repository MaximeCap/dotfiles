local M = {}

M.base46 = {
	theme = "ayu_dark",
	transparency = true,
}

M.ui = {
	statusline = { theme = "minimal", separator_style = "round" },
	cmp = {},
	telescope = { style = "bordered" },
	tabufline = {
		enabled = false,
	},
}

M.colorify = {
	enabled = true,
	mode = "virtual", -- fg, bg, virtual
	virt_text = "󱓻 ",
	highlight = { hex = true, lspvars = true },
}

M.cheatsheet = {
	theme = "grid", -- simple/grid
	excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
}

vim.keymap.set("n", "<C-t>", function()
	require("nvchad.themes").open()
end, { desc = "Nvchad theme picker" })

return M
