return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim",       opts = {} },
    { "b0o/schemastore.nvim" },
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

    local function organize_imports()
      local params = {
        command = "_typescript.organizeImports",
        arguments = { vim.api.nvim_buf_get_name(0) },
        title = ""
      }
      vim.lsp.buf.execute_command(params)
    end

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

    -- Function to configure LSP servers using new vim.lsp.config API
    local function setup_lsp_server(server_name, config)
      config = config or {}
      config.on_attach = on_attach
      config.capabilities = capabilities

      -- Show start notification if not already shown
      if not start_notification_shown then
        lsp_notify("Starting LSP servers...", "info")
        start_notification_shown = true
      end

      lsp_start_times[server_name] = vim.loop.hrtime()

      -- Use new vim.lsp.config API if available, fallback to lspconfig for compatibility
      if vim.lsp.config and vim.lsp.enable then
        -- Configure the server using new API
        vim.lsp.config[server_name] = config
        vim.lsp.enable(server_name)
      else
        -- Fallback to old lspconfig API for older Neovim versions
        local lspconfig = require "lspconfig"
        lspconfig[server_name].setup(config)
      end
    end

    -- Mason-lspconfig setup (single consolidated setup)
    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup {
      ensure_installed = vim.tbl_extend("force",
        vim.tbl_keys(require("plugins.lsp.servers") or {}),
        { "tailwindcss", "html", "clangd" }
      ),
      handlers = {
        function(server_name)
          if
              server_name ~= "gopls"
              and server_name ~= "clangd"
              and server_name ~= "ts_ls"
              and server_name ~= "pyright"
          then
            local server_config = require("plugins.lsp.servers")[server_name] or {}
            setup_lsp_server(server_name, {
              settings = server_config.settings or server_config,
              filetypes = server_config.filetypes,
              cmd = server_config.cmd,
            })
          end
        end,
      }
    }

    -- Clangd setup
    setup_lsp_server("clangd", {
      filetypes = { "c", "cpp", "objc", "objcpp" },
      cmd = { "clangd", "--background-index" },
      root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
    })

    -- TypeScript setup
    setup_lsp_server("ts_ls", {
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
      commands = {
        OrganizeImports = {
          organize_imports,
          description = "Organize Imports"
        }
      }
    })

    -- Gopls setup
    setup_lsp_server("gopls", {
      cmd = { "gopls" },
      filetypes = { "go", "gomod", "gowork", "gotmpl" },
      root_markers = { "go.work", "go.mod", ".git" },
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
    setup_lsp_server("pyright", {
      filetypes = { "python" },
      settings = {
        python = {
          pythonPath = vim.fn.expand("~/Desktop/practice/bin/python"), -- Default path
        }
      },
      before_init = function(_, config)
        -- Try to find virtual environment paths
        local venv_paths = {
          vim.fn.expand("~/Desktop/practice/bin/python"),
          vim.fn.expand("~/Desktop/practice-django/bin/python"),
        }
        
        for _, path in ipairs(venv_paths) do
          if vim.fn.executable(path) == 1 then
            config.settings.python.pythonPath = path
            break
          end
        end
      end,
    })

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
