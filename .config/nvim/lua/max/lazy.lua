local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

require("lazy").setup({ { import = "max.plugins" }, { import = "max.plugins.lsp" } }, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"netrwPlugin",
				-- etc.
			},
		},
	},
	icons = {
		diagnostics = {
			Error = "  ",
			Warn = "  ",
			Hint = "  ",
			Info = "  ",
		},
	},
})

for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
