local M = {}

M.base46 = {
	theme = "gruvchad",
	transparency = true,
}

M.ui = {
	statusline = { theme = "vscode_colored" },
	telescope = { style = "bordered" },
	tabufline = {
		enabled = false,
	},
	cmp = {
		lspkind_text = true,
		style = "default", -- default/flat_light/flat_dark/atom/atom_colored
		format_colors = {
			tailwind = false,
		},
	},
}
M.lsp = {
	signature = false,
}

M.colorify = {
	enabled = true,
	mode = "virtual", -- fg, bg, virtual
	virt_text = "󱓻 ",
	highlight = { hex = true, lspvars = true },
}

vim.keymap.set("n", "<C-t>", function()
	require("nvchad.themes").open()
end, { desc = "Nvchad theme picker" })

return M
