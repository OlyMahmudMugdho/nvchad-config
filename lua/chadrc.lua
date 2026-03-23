-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "gruvbox",
}

M.ui = {
	tabufline = {
		lazyload = false,
		buttons = {
			{ vim.fn.stdpath("config") .. "/lua/mappings.lua", "配置文件", "e" },
			{
				function()
					local bufname = vim.fn.bufname("%")
					local ft = vim.bo.filetype
					
					local run_cmds = {
						python = "python",
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
						
						vim.cmd("terminal " .. cmd)
					else
						vim.cmd("OverseerRun")
					end
				end,
				"Run Code",
				"r",
			},
			{ "Lazy", "Lazy", "l" },
			{ "Mason", "Mason", "m" },
			{ "Quit", "quit", "q" },
		},
	},
}

return M