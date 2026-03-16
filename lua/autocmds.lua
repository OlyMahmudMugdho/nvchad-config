require "nvchad.autocmds"

-- Fix nvim-tree fs_event watcher issue
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Disable nvim-tree fs_events (fixes watcher issues on WSL/network drives)
vim.g.nvim_tree_respawn_on_bufenter = 1
