require "nvchad.mappings"

local map = vim.keymap.set

local telescope = require("telescope.builtin")
local harpoon = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")

-- add yours here

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("i", "<C-h>", "<C-w>", { desc = "Delete word before cursor" })
map("i", "<C-Del>", "<C-o>dw", { desc = "Delete word after cursor" })

map({ "n", "v" }, "<C-c>", '"+y', { desc = "Copy to system clipboard" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste from system clipboard" })
map("i", "<C-v>", '<ESC>"+p', { desc = "Paste from system clipboard" })

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Spring Boot keybindings
local function spring()
  local ok, spring = pcall(require, "spring-boot-nvim")
  if ok then
    return spring
  end
  return nil
end

local function java()
  local ok, java = pcall(require, "jdtls")
  if ok then
    return java
  end
  return nil
end

map("n", "<leader>jsb", function()
  local s = spring()
  if s then s.find_beans() end
end, { desc = "Find Spring Beans" })

map("n", "<leader>jse", function()
  local s = spring()
  if s then s.find_endpoints() end
end, { desc = "Find Spring Endpoints" })

map("n", "<leader>jsp", function()
  local s = spring()
  if s then s.project_properties() end
end, { desc = "Spring Project Properties" })

map("n", "<leader>jo", function()
  local j = java()
  if j then j.organize_imports() end
end, { desc = "Organize Java Imports" })

map("n", "<leader>jc", function()
  vim.cmd("LspWorkspaceDiagnostics")
end, { desc = "Show Java Diagnostics" })

map("n", "<leader>jdt", function()
  local j = java()
  if j then j.test_class() end
end, { desc = "Debug Test Class" })

map("n", "<leader>jrm", function()
  local j = java()
  if j then j.run_main_class() end
end, { desc = "Run Main Class" })

-- LSP keybindings
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover symbol" })
map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbol" })
map("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Diagnostic open float" })
map("n", "[d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "]d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "<leader>vca", vim.lsp.buf.code_action, { desc = "Code action" })
map({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Code action (Ctrl+.)" })
map("n", "<leader>vrr", vim.lsp.buf.references, { desc = "References" })
map("n", "<leader>vrn", vim.lsp.buf.rename, { desc = "Rename" })

-- Telescope keybindings
map("n", "<leader>pf", telescope.find_files, { desc = "Find files" })
map("n", "<C-g>", telescope.git_files, { desc = "Git files" })
map("n", "<leader>ps", function()
  telescope.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep" })

-- Harpoon keybindings
map("n", "<leader>e", harpoon.toggle_quick_menu, { desc = "Toggle harpoon menu" })
map("n", "<leader>a", harpoon_mark.add_file, { desc = "Add file to harpoon" })
map("n", "<C-j>", harpoon.nav_next, { desc = "Harpoon nav next" })
map("n", "<C-k>", harpoon.nav_prev, { desc = "Harpoon nav prev" })

-- Undotree keybinding
map("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

-- Fugitive keybinding
map("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })
