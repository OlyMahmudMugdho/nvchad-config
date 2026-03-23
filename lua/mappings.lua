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

local function java_organize_imports()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.organizeImports" },
      diagnostics = {},
    },
  })
end

local function java_test_class()
  local ok, java_test = pcall(require, "java-test")
  if ok and java_test then
    java_test.test_class()
  else
    vim.cmd("wa")
    vim.cmd("TestFile")
  end
end

local function java_run_main_class()
  local ok, java_debug = pcall(require, "java-debug")
  if ok and java_debug then
    java_debug.attach()
  else
    vim.cmd("wa")
    local bufname = vim.fn.bufname("%")
    local classname = vim.fn.fnamemodify(bufname, ":t:r")
    if classname and classname ~= "" then
      vim.cmd("!java " .. classname)
    end
  end
end

map("n", "<leader>jo", java_organize_imports, { desc = "Organize Java Imports" })

map("n", "<leader>jc", function()
  vim.cmd("LspWorkspaceDiagnostics")
end, { desc = "Show Java Diagnostics" })

map("n", "<leader>jdt", java_test_class, { desc = "Debug Test Class" })

map("n", "<leader>jrm", java_run_main_class, { desc = "Run Main Class" })

-- LSP keybindings
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover symbol" })
map("n", "<leader>vws", vim.lsp.buf.workspace_symbol, { desc = "Workspace symbol" })
map("n", "<leader>vd", vim.diagnostic.open_float, { desc = "Diagnostic open float" })
map("n", "[d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "]d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
map("n", "<leader>vca", vim.lsp.buf.code_action, { desc = "Code action (show menu)" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action (show menu)" })

-- Alt+Enter to apply LSP fix (VS Code style)
map({ "n", "i" }, "<M-CR>", vim.lsp.buf.code_action, { desc = "Code action (Alt+Enter)" })

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

-- Code runner keybindings
map("n", "<leader>rr", function()
  local bufname = vim.fn.bufname("%")
  local ft = vim.bo.filetype
  
  -- Define run commands for common filetypes
  local run_cmds = {
    python = "python3",
    javascript = "node",
    typescript = "npx ts-node",
    go = "go run",
    rust = "cargo run",
    java = "java",
    lua = "luajit",
  }
  
  local runner = run_cmds[ft]
  if runner then
    local filepath = vim.api.nvim_buf_get_name(0)
    local filedir = vim.fn.fnamemodify(filepath, ":p:h")
    
    local cmd
    if ft == "rust" then
      cmd = "cd " .. filedir .. " && cargo run"
    elseif ft == "go" then
      cmd = "cd " .. filedir .. " && go run " .. vim.fn.fnamemodify(filepath, ":t")
    else
      cmd = runner .. " " .. filepath
    end
    
    -- Use terminal for cleaner output
    vim.cmd("terminal " .. cmd)
  else
    vim.cmd("OverseerRun")
  end
end, { desc = "Run current file" })

map("n", "<leader>rt", vim.cmd.OverseerToggle, { desc = "Toggle Overseer task list" })
