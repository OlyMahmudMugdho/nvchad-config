require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "pyright" }
vim.lsp.enable(servers)

-- Configure YAML for Spring Boot application.yml
vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      validate = true,
      schemaStore = {
        enable = true,
        url = "https://www.schemastore.org/api/json/catalog.json",
      },
      schemas = {
        ["https://raw.githubusercontent.com/spring-projects/scripted/master/src/main/resources/spring-boot-3.x-schema.yaml"] = {
          "application*.yml",
          "application*.yaml",
          "application*.properties",
        },
      },
    },
  },
})

-- Configure pyright with virtualenv detection for uv, venv, etc.
vim.lsp.config("pyright", {
  cmd = (function()
    -- Check VIRTUAL_ENV env var first
    local venv = vim.env.VIRTUAL_ENV
    if venv then
      if vim.fn.has("win32") == 1 then
        return { venv .. "/Scripts/python.exe" }
      else
        return { venv .. "/bin/python" }
      end
    end
    
    -- Check for .venv (uv default) in current directory
    local cwd = vim.fn.getcwd()
    local uv_venv = vim.fn.glob(cwd .. "/.venv/bin/python")
    if uv_venv ~= "" then
      return { uv_venv }
    end
    
    -- Fallback to system python
    return { "pyright" }
  end)(),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
        typeCheckingMode = "basic",
        reportAttributeAccessIssue = false,
      },
    },
  },
})

vim.lsp.enable("yamlls")
