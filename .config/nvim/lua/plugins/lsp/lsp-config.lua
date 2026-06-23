return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "williamboman/mason.nvim", config = true },
    "williamboman/mason-lspconfig.nvim",
    { "j-hui/fidget.nvim",       opts = {} },
    { "b0o/schemastore.nvim" },
    "rcarriga/nvim-notify",
  },
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
        vim.tbl_keys(require("config.lsp-servers") or {}),
        { "tailwindcss", "html", "clangd" }
      ),
      -- mason-lspconfig v2 auto-enables installed servers. Exclude legacy pyright
      -- so it doesn't run alongside basedpyright on Python files.
      automatic_enable = {
        exclude = { "pyright" },
      },
      handlers = {
        function(server_name)
          -- Skip servers we configure manually or want to disable
          local skip_servers = {
            "gopls",
            "clangd",
            "ts_ls",
            "pyright",
            "glint",      -- Disable glint (causes conflicts)
            "ember",      -- Disable ember (use ts_ls for .js/.ts files)
          }

          local should_skip = false
          for _, skip_name in ipairs(skip_servers) do
            if server_name == skip_name then
              should_skip = true
              break
            end
          end

          if not should_skip then
            local servers = require("config.lsp-servers")
            local server_config = servers[server_name]

            -- Only set up servers that have explicit configurations
            if server_config then
              setup_lsp_server(server_name, {
                settings = server_config.settings or server_config,
                filetypes = server_config.filetypes,
                cmd = server_config.cmd,
              })
            end
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

    -- =====================================================================
    -- Python: basedpyright (types) + ruff (lint/format/imports)
    -- Virtualenv is detected automatically, so no per-project config needed.
    -- =====================================================================

    -- Resolve the Python interpreter for the current project.
    -- Order: activated shell venv -> conda -> a venv found by walking up the
    -- directory tree from the file/root -> system python3.
    local function resolve_python_path(root_dir)
      if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
        return vim.env.VIRTUAL_ENV .. "/bin/python"
      end
      if vim.env.CONDA_PREFIX and vim.env.CONDA_PREFIX ~= "" then
        return vim.env.CONDA_PREFIX .. "/bin/python"
      end

      local venv_names = { ".venv", "venv", "env", ".env", "virtualenv" }
      local dir = root_dir
      if not dir or dir == "" then
        dir = vim.fn.getcwd()
      end
      -- Also start from the current buffer's directory so it works even when the
      -- LSP root resolves higher up than the venv (e.g. monorepos / scratch dirs).
      local buf_dir = vim.fn.expand("%:p:h")
      for _, start in ipairs({ buf_dir, dir }) do
        local cur = start
        while cur and cur ~= "" do
          for _, name in ipairs(venv_names) do
            local candidate = cur .. "/" .. name .. "/bin/python"
            if vim.fn.executable(candidate) == 1 then
              return candidate
            end
          end
          local parent = vim.fn.fnamemodify(cur, ":h")
          if parent == cur then
            break
          end
          cur = parent
        end
      end

      local sys = vim.fn.exepath("python3")
      return sys ~= "" and sys or "python3"
    end

    setup_lsp_server("basedpyright", {
      cmd = { "basedpyright-langserver", "--stdio" },
      filetypes = { "python" },
      root_markers = {
        "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt",
        "Pipfile", "pyrightconfig.json", ".git",
      },
      settings = {
        basedpyright = {
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
            typeCheckingMode = "standard",
            autoImportCompletions = true,
            inlayHints = {
              variableTypes = true,
              functionReturnTypes = true,
              callArgumentNames = true,
            },
          },
        },
        python = {},
      },
      before_init = function(_, config)
        config.settings = config.settings or {}
        config.settings.python = config.settings.python or {}
        config.settings.python.pythonPath = resolve_python_path(config.root_dir)
      end,
    })

    -- Ruff: linting, formatting and import organization. Let basedpyright own
    -- hover so we don't get duplicate hover popups.
    setup_lsp_server("ruff", {
      cmd = { "ruff", "server" },
      filetypes = { "python" },
      root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("ruff_no_hover", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "ruff" then
          client.server_capabilities.hoverProvider = false
        end
      end,
    })

    -- =====================================================================
    -- Ember: ember-language-server (Ember features) + glint (template types).
    -- ember only attaches to templates/glimmer files inside Ember projects, so
    -- it never conflicts with ts_ls on regular .js/.ts files.
    -- =====================================================================
    setup_lsp_server("ember", {
      cmd = { "ember-language-server", "--stdio" },
      filetypes = { "handlebars", "typescript.glimmer", "javascript.glimmer" },
      root_markers = { "ember-cli-build.js", ".git" },
    })

    -- glint is a project-local dependency (@glint/core). It only starts when a
    -- glint config (or ember-cli-build.js) is present, so it is inert elsewhere.
    setup_lsp_server("glint", {
      cmd = { "glint-language-server", "--stdio" },
      filetypes = {
        "html.handlebars", "handlebars",
        "typescript", "typescript.glimmer",
        "javascript", "javascript.glimmer",
      },
      init_options = { glint = { useGlobal = false } },
      root_markers = {
        ".glintrc.yml", ".glintrc", ".glintrc.json", ".glintrc.js",
        "glint.config.js", "ember-cli-build.js",
      },
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

    -- Diagnostic signs (using new API)
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = signs.Error,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.HINT] = signs.Hint,
            [vim.diagnostic.severity.INFO] = signs.Info,
          }
        }
      })
    end
  end,
}
