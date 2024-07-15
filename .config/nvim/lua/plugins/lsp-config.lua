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
    "rcarriga/nvim-notify",
  },
  lazy = false,
  config = function()
    -- Set up nvim-notify
    vim.notify = require "notify"

    -- Table to store start times for each LSP server
    local lsp_start_times = {}

    -- Flag to check if a start notification has been shown
    local start_notification_shown = false

    -- Function to show LSP loading notification
    local function lsp_notify(msg, level)
      vim.notify(msg, level, {
        title = "LSP",
        timeout = 500,
        keep = function()
          return vim.bo.filetype == "lspinfo"
        end,
      })
    end

    -- Mason setup
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

    -- Mason-lspconfig setup
    require("mason-lspconfig").setup {
      ensure_installed = vim.tbl_keys(require "plugins.lsp.servers"),
    }

    require("mason-lspconfig").setup {
      ensure_installed = { "tailwindcss", "html", "clangd" },
    }

    -- Set up neodev before setting up other LSPs
    require("neodev").setup()

    -- LSP configurations
    local lspconfig = require "lspconfig"
    local util = require "lspconfig/util"

    -- Capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

    -- On attach function
    local on_attach = function(client, bufnr)
      local start_time = lsp_start_times[client.name]
      if start_time then
        local load_time = vim.loop.hrtime() - start_time
        local load_time_ms = load_time / 1e6 -- Convert nanoseconds to milliseconds
        lsp_notify(string.format("%s LSP loaded in %.2f ms", client.name, load_time_ms), "info")
      else
        lsp_notify(client.name .. " LSP loaded", "info")
      end

      -- Keybinding for go to definition
      local opts = { noremap = true, silent = true }
      vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)

      -- Your existing on_attach logic here
    end

    -- Function to set up LSP servers
    local function setup_lsp(server_name, config)
      config = config or {}
      config.on_attach = on_attach
      config.capabilities = capabilities

      -- Show start notification if not already shown
      if not start_notification_shown then
        lsp_notify("Starting LSP servers...", "info")
        start_notification_shown = true
      end

      lsp_start_times[server_name] = vim.loop.hrtime()

      lspconfig[server_name].setup(config)
    end

    -- Clangd setup
    setup_lsp("clangd", {
      filetypes = { "c", "cpp", "objc", "objcpp" },
    })

    -- TypeScript setup
    setup_lsp("tsserver", {
      filetypes = {
        "typescript",
        "typescriptreact",
        "typescript.tsx",
        "javascript",
        "javascriptreact",
        "javascript.jsx",
      },
      settings = {
        typescript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
        javascript = {
          inlayHints = {
            includeInlayEnumMemberValueHints = true,
            includeInlayFunctionLikeReturnTypeHints = true,
            includeInlayParameterNameHints = "all",
            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            includeInlayPropertyDeclarationTypeHints = true,
            includeInlayVariableTypeHints = true,
          },
        },
      },
    })

    -- Gopls setup
    setup_lsp("gopls", {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_dir = util.root_pattern("go.work", "go.mod", ".git"),
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        },
      },
    })

    -- Python setup
    setup_lsp("pyright", {
      before_init = function(_, config)
        local path = util.path
        local default_venv_path = path.join(vim.env.HOME, "Desktop", "NHCE", "Sem4", "ds", "bin", "python")
        local default_venv_path_for_DAA = path.join(vim.env.HOME, "Desktop", "NHCE", "Sem4", "daa", "bin", "python")
        config.settings.python.pythonPath = default_venv_path
        config.settings.python.pythonPath = default_venv_path_for_DAA
      end,
      filetypes = { "python" },
    })

    -- Mason-lspconfig handler for other servers
    local mason_lspconfig = require "mason-lspconfig"
    mason_lspconfig.setup_handlers {
      function(server_name)
        if
          server_name ~= "gopls"
          and server_name ~= "clangd"
          and server_name ~= "tsserver"
          and server_name ~= "pyright"
        then
          setup_lsp(server_name, {
            settings = require("plugins.lsp.servers")[server_name],
            filetypes = (require("plugins.lsp.servers")[server_name] or {}).filetypes,
          })
        end
      end,
    }

    -- Diagnostic configuration
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

    -- Diagnostic signs
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end
  end,
}
