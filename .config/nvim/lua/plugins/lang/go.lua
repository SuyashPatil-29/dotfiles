-- Lightweight Go development setup (replaces heavy go.nvim)
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
        "goimports",
        "gofumpt",
        "golangci-lint",
        "delve",
      },
    },
  },

  -- Lightweight Go utilities
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    build = function()
      vim.cmd.GoInstallDeps()
    end,
    opts = {},
  },

  -- Enhanced Go LSP configuration
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      },
    },
  },

  -- Go treesitter support
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  },

  -- Go-specific keymaps
  {
    "nvim-lspconfig",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          -- Go test commands
          vim.keymap.set("n", "<leader>gt", "<cmd>GoTest<cr>", { desc = "Go Test", buffer = true })
          vim.keymap.set("n", "<leader>gT", "<cmd>GoTestAll<cr>", { desc = "Go Test All", buffer = true })
          vim.keymap.set("n", "<leader>gc", "<cmd>GoCoverage<cr>", { desc = "Go Coverage", buffer = true })
          
          -- Go-specific formatting
          vim.keymap.set("n", "<leader>gf", function()
            require("conform").format({ 
              bufnr = vim.api.nvim_get_current_buf(),
              formatters = { "goimports", "gofumpt" }
            })
          end, { desc = "Format Go file", buffer = true })
        end,
      })
    end,
  },
}
