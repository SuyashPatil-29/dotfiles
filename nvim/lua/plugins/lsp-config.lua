return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        PATH = "prepend", -- "skip" seems to cause the spawning error
      })
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "tsserver", "html", "tailwindcss", "clangd" },
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

      lspconfig.tsserver.setup({
        capabilities = capabilities,
      })

      lspconfig.html.setup({
        capabilities = capabilities,
      })

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      lspconfig.tailwindcss.setup({
        capabilities = capabilities,
        inlayHints = {
          assignedClassNameHints = true,
          generateHints = true,
          svgHints = true,
        },
        componentFolderPaths = { "src/**" }, -- Include all subdirectories inside the 'src' folder
        colors = {
          virtual_text = true,
        },
        hovers = {
          detailed = true,
          includeCodeBlocks = true,
          includeComponents = true,
          includeTermColors = true,
        },
      })

      lspconfig.clangd.setup({
        capabilities = capabilities, -- Use the default capabilities
        on_attach = function(client, bufnr)
          -- Disable signature help for clangd
          client.server_capabilities.signatureHelpProvider = false
          require('lsp-config').on_attach(client, bufnr)
        end
      })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}
