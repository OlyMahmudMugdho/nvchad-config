require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("i", "<C-h>", "<C-w>", { desc = "Delete word before cursor" })
map("i", "<C-Del>", "<C-o>dw", { desc = "Delete word after cursor" })

map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", '<ESC>"+p', { desc = "Paste from system clipboard" })

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
