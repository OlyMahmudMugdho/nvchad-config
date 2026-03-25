require("nvchad.configs.lspconfig").defaults()

local servers = { "pyright", "jdtls", "vtsls", "eslint", "gopls", "rust_analyzer" }
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
  cmd = function()
    local venv = vim.env.VIRTUAL_ENV
    if venv then
      if vim.fn.has("win32") == 1 then
        return { venv .. "/Scripts/python.exe", "--stdio" }
      else
        return { venv .. "/bin/python", "--stdio" }
      end
    end

    local cwd = vim.fn.getcwd()
    local uv_venv = vim.fn.glob(cwd .. "/.venv/bin/python")
    if uv_venv ~= "" then
      return { uv_venv, "--stdio" }
    end

    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
    return { mason_bin .. "/pyright-langserver", "--stdio" }
  end,
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

-- Configure vtsls for TypeScript/JavaScript (Express.js, NestJS, Vue)
vim.lsp.config("vtsls", {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        autoImports = true,
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      suggest = {
        autoImports = true,
        completeFunctionCalls = true,
        includeCompletionsForModuleExports = true,
      },
    },
    vtsls = {
      experimental = {
        completions = {
          excludeWordsInCompletions = true,
        },
      },
      autoUseWorkspaceTsdk = true,
    },
  },
})

-- Configure ESLint
vim.lsp.config("eslint", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    codeAction = {
      disableRuleComment = {
        seeConfig = true,
      },
    },
    format = true,
    nodePath = "",
    onIgnored = "none",
    packageManager = "npm",
    quiet = true,
    rulesCustomizations = {},
    run = "onType",
    useESLintClass = false,
    validate = "on",
    workingDirectory = {
      mode = "location",
    },
  },
})

vim.lsp.enable("yamlls")


-- Configure gopls for Go (golang) with auto-import and suggestions
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      -- Enable analyses
      analyses = {
        unusedvars = true,
        shadow = true,
        ["nil"] = true,
        unreachable = true,
        composite = true,
      },
      -- Use gofumpt for formatting
      ui = {
        format = {
          ["local"] = "gofumpt",
        },
      },
      -- Semantic tokens
      semanticTokens = true,
    },
  },
})

-- Add gopls to enabled servers
vim.lsp.enable("gopls")

-- Configure rust-analyzer for Rust
vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
        loadOutDirsFromCheck = true,
        runBuildScripts = true,
      },
      checkOnSave = {
        command = "clippy",
      },
      procMacro = {
        enable = true,
      },
    },
  },
})

vim.lsp.enable("rust_analyzer")
