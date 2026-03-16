return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- Disable nvim-jdtls (conflicts with nvim-java)
  disabled = {
    "mfussenegger/nvim-jdtls",
  },

  -- nvim-java with dependencies
  {
    "nvim-java/nvim-java",
    dependencies = {
      "nvim-java/lua-async-await",
      "nvim-java/nvim-java-refactor",
      "nvim-java/nvim-java-test",
      "nvim-java/nvim-java-dap",
      "MunifTanjim/nui.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("java").setup({
        jdk = {
          auto_install = true,
        },
        test = {
          enable = true,
        },
        debug = {
          enable = true,
        },
      })
    end,
  },

  -- Spring Boot support
  {
    "JavaHello/spring-boot.nvim",
    commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
    ft = { "java", "yaml", "jproperties" },
    config = function()
      local present, spring = pcall(require, "spring-boot-nvim")
      if present then
        spring.setup({
          ui = {
            picker = "fzf", -- or "telescope"
          },
        })
      end
    end,
  },

  -- Mason - LSP installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "jdtls",
        "jdtls-debug-adapter",
        "jdtls-test",
        "yaml-language-server",
        "pyright",
        "typescript-language-server",
        "volar",
        "eslint",
        "prettier",
      },
      registries = {
        "github:mason-org/mason-registry",
      },
    },
  },

  -- mason-lspconfig for Java LSP handling
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      handlers = {
        jdtls = function()
          require("java").lspconfig().start()
        end,
      },
    },
  },

  -- fzf for spring-boot.nvim picker
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },

  -- Telescope - fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope")
      local config = require("configs.telescope")
      telescope.setup(config)
    end,
  },

  -- Harpoon - quick file navigation
  {
    "ThePrimeagen/harpoon",
    cmd = { "Harpoon" },
    dependencies = "nvim-lua/plenary.nvim",
  },

  -- Undotree - visual undo history
  {
    "mbbill/undotree",
    cmd = "Undotree",
  },

  -- Fugitive - git integration
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },

  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "InsertEnter",
    build = ":Copilot setup",
  },

  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    cmd = {
      "CopilotChat",
      "CopilotChatToggle",
      "CopilotChatOpen",
      "CopilotChatClose",
    },
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- Treesitter for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css", "javascript", "typescript",
        "python", "java", "json", "yaml", "markdown",
        "go", "rust", "c", "cpp",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- nvim-cmp for completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", keyword_length = 1 },
          { name = "nvim_lsp_signature_help" },  -- for function signatures
          { name = "nvim_lua" },
          { name = "luasnip" },
          { name = "path" },
          { name = "buffer", keyword_length = 3 },
        }),
        -- Enable code actions in completion menu
        cmp.setup.filetype("python", {
          sources = cmp.config.sources({
            { name = "nvim_lsp", keyword_length = 1 },
            { name = "nvim_lsp_signature_help" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "path" },
            { name = "buffer", keyword_length = 3 },
          }),
        }),
        formatting = {
          format = function(entry, vim_item)
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              nvim_lua = "[Lua]",
              luasnip = "[Snip]",
              buffer = "[Buf]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
      })
    end,
  },
}

