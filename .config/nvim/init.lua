local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

require("config.options")
require("config.lazy")

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>")

vim.diagnostic.config({ virtual_text = false })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup("highlight_yank"),
	callback = function()
		vim.highlight.on_yank()
	end,
})
