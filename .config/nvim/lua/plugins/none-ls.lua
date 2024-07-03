local null_ls = require "null-ls"
local null_ls_utils = require "null-ls.utils"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

return {
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "jay-babu/mason-null-ls.nvim",
      "nvim-lua/plenary.nvim",
      "nvimtools/none-ls-extras.nvim",
      "gbprod/none-ls-shellcheck.nvim",
    },
    config = function()
      require("null-ls").register(require "none-ls-shellcheck.diagnostics")
      require("null-ls").register(require "none-ls-shellcheck.code_actions")

      local mason_null_ls = require "mason-null-ls"
      mason_null_ls.setup {
        ensure_installed = {
          "prettier",
          "stylua",
          "eslint_d",
          "golangci_lint",
          "shellcheck",
          "buf",
          "gofumpt",
          "spell",
          "black",
        },
      }

      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      local sources = {
        -- Formatting
        formatting.stylua,
        formatting.prettier,
        formatting.gofumpt,
        formatting.goimports_reviser,
        formatting.golines,
        formatting.buf,
        formatting.black,

        -- Diagnostics
        diagnostics.golangci_lint,

        -- Code Actions
        code_actions.gitsigns,
        code_actions.refactoring,
      }

      local on_attach = function(client, bufnr)
        if client.supports_method "textDocument/formatting" then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { bufnr = bufnr }
            end,
          })
        end
      end

      null_ls.setup {
        root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),
        sources = sources,
        on_attach = on_attach,
      }

      -- Keybinding to format the buffer manually
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" })
    end,
  },
}
