---@type overseer.Config
local M = {
  -- Auto-instantiate templates based on filetype
  auto_deps = true,
  auto_load_templates = true,
  auto_template_highlight = {},
  
  -- Task templates for common languages
  templates = {
    {
      name = "Python: Run",
      filename = "*.py",
      cmd = function(_, opts)
        local bufname = vim.fn.bufname("%")
        local filename = vim.fn.fnamemodify(bufname, ":t")
        return "python " .. filename
      end,
    },
    {
      name = "Node: Run",
      filename = "*.js",
      cmd = function(_, opts)
        local bufname = vim.fn.bufname("%")
        local filename = vim.fn.fnamemodify(bufname, ":t")
        return "node " .. filename
      end,
    },
    {
      name = "Go: Run",
      filename = "*.go",
      cmd = function(_, opts)
        local bufname = vim.fn.bufname("%")
        local filename = vim.fn.fnamemodify(bufname, ":t")
        return "go run " .. filename
      end,
    },
    {
      name = "Rust: Run",
      filename = "*.rs",
      cmd = function(_, opts)
        local bufname = vim.fn.bufname("%")
        local filename = vim.fn.fnamemodify(bufname, ":t")
        return "cargo run"
      end,
    },
    {
      name = "Java: Run",
      filename = "*.java",
      cmd = function(_, opts)
        local bufname = vim.fn.bufname("%")
        local classname = vim.fn.fnamemodify(bufname, ":t:r")
        return "java " .. classname
      end,
    },
  },
}

return M
