-- Minimal configuration that is loaded instead of my main configuration when invoking `nvim -c DiffEditor`
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- Swap : and ,
map({ "n", "v" }, ",", ":", { desc = "enter command mode" })
map({ "n", "v" }, ":", ",", { desc = "repeat latest f, t, F, or T in opposite direction" })

-- Swap ' and `
map({ "n", "v" }, "'", "`", { desc = "jump to mark in the current buffer" })
map({ "n", "v" }, "`", "'", { desc = "jump to mark in the current buffer" })

map("n", "<leader>-", "<c-w>_", { desc = "maximize vertically" })
map("n", "<leader>=", "<c-w>=", { desc = "equal window sizes" })

map("n", "<c-left>", "<c-w>h", { desc = "move to window on left" })
map("n", "<c-down>", "<c-w>j", { desc = "move to window below" })
map("n", "<c-up>", "<c-w>k", { desc = "move to window above" })
map("n", "<c-right>", "<c-w>l", { desc = "move to window on right" })
