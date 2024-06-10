return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim", opts = {} },
    { "b0o/schemastore.nvim" },
    "folke/neodev.nvim",
    "OmniSharp/omnisharp-vim",
  },
  lazy = false,
  config = function()
    require("mason").setup {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    }
    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(require "plugins.lsp.servers"),
    }

    require("mason-lspconfig").setup {
      ensure_installed = { "tailwindcss", "html" },
    }

    require("lspconfig.ui.windows").default_options.border = "single"

    require("neodev").setup()

    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    local mason_lspconfig = require "mason-lspconfig"

    mason_lspconfig.setup_handlers {
      function(server_name)
        require("lspconfig")[server_name].setup {
          capabilities = capabilities,
          on_attach = require("plugins.lsp.on_attach").on_attach,
          settings = require("plugins.lsp.servers")[server_name],
          filetypes = (require("plugins.lsp.servers")[server_name] or {}).filetypes,
        }
      end,
    }

    -- Python environment
    local util = require "lspconfig/util"
    local path = util.path
    require("lspconfig").pyright.setup {
      on_attach = require("plugins.lsp.on_attach").on_attach,
      capabilities = capabilities,
      before_init = function(_, config)
        -- pwd path where all python codes should be stored for python to work properly
        local default_venv_path = path.join(vim.env.HOME, "Desktop", "NHCE", "Sem4", "ds", "bin", "python")
        local default_venv_path_for_DAA = path.join(vim.env.HOME, "Desktop", "NHCE", "Sem4", "daa", "bin", "python")
        config.settings.python.pythonPath = default_venv_path
        config.settings.python.pythonPath = default_venv_path_for_DAA
      end,
    }

    vim.diagnostic.config {
      title = false,
      underline = true,
      virtual_text = true,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        source = "always",
        style = "minimal",
        border = "rounded",
        header = "",
        prefix = "",
      },
    }

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
