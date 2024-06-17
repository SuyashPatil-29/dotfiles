-- return {
--   "nvimtools/none-ls.nvim", -- The plugin name
--   config = function()
--     local null_ls = require("null-ls") -- Require the null-ls plugin
--
--     null_ls.setup({
--       sources = {
--         null_ls.builtins.formatting.stylua, -- Use the built-in stylua formatter
--         null_ls.builtins.formatting.prettier, -- Use the built-in prettier formatter
--         null_ls.builtins.completion.spell, -- Use the built-in spell completion
--       },
--     })
--
--   end,
-- }

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
      local null_ls = require "null-ls"

      local null_ls_utils = require "null-ls.utils"
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {}) -- Create an autocmd group for formatting

      mason_null_ls.setup {
        ensure_installed = {
          "prettier", -- prettier formatter
          "stylua", -- lua formatter
          "eslint_d", -- js linter
          "golangci_lint", -- go linter
          "shellcheck", -- shell linter
          "buf", -- buf formatter
          "gofumpt", -- go formatter
          "spell", -- spell checker
          "black", -- python formatter
        },
      }

      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local code_actions = null_ls.builtins.code_actions

      -- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      null_ls.setup {
        root_dir = null_ls_utils.root_pattern(".null-ls-root", "Makefile", ".git", "package.json"),

        sources = {
          formatting.stylua,
          formatting.prettier,
          formatting.gofumpt,
          formatting.goimports_reviser,
          formatting.golines,
          formatting.buf,
          formatting.black,

          diagnostics.golangci_lint,

          code_actions.gitsigns,
          code_actions.refactoring,
        },
        on_attach = function(client, bufnr)
          if client.supports_method "textDocument/formatting" then
            vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr } -- Clear existing autocmds for the buffer
            vim.api.nvim_create_autocmd("BufWritePre", { -- Create a new autocmd that runs before saving the buffer
              group = augroup,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format { bufnr = bufnr } -- Format the buffer
              end,
            })
          end
        end,
        -- configure format on save
        -- on_attach = function(current_client, bufnr)
        --   if current_client.supports_method("textDocument/formatting") then
        --     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        --     vim.api.nvim_create_autocmd("BufWritePre", {
        --       group = augroup,
        --       buffer = bufnr,
        --       callback = function()
        --         vim.lsp.buf.format({
        --           filter = function(client)
        --             --  only use null-ls for formatting instead of lsp server
        --             return client.name == "null-ls"
        --           end,
        --           bufnr = bufnr,
        --         })
        --       end,
        --     })
        --   end
        -- end,
      }
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" }) -- Keybinding to format the buffer manually
    end,
  },
}
