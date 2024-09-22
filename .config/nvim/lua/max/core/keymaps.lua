vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.trouble_lualine = true
-- LazyVim auto format
vim.g.autoformat = true

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>")

-- Window management
keymap.set("n", "<leader>wv", "<C-w>v", { desc = "Split window [v]ertically" })
keymap.set("n", "<leader>wh", "<C-w>s", { desc = "Split window [h]orizontally" })
keymap.set("n", "<leader>we", "<C-w>=", { desc = "Make split equal" })
keymap.set("n", "<leader>wx", "<cmd>close<CR>", { desc = "Close current split" })

-- Page up and down + center
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "<C-d>", "<C-d>zz")

-- Move Lines
keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move Down" })
keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move Up" })

-- Clear search with <esc>
keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })
