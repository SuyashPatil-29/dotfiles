-- Auto-install the formatters, linters and debug adapters used across the config
-- so nothing has to be installed by hand (LSP servers are handled by
-- mason-lspconfig in lsp-config.lua).
return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  opts = {
    ensure_installed = {
      -- Python
      "ruff",     -- lint + format + import organization
      "debugpy",  -- debug adapter
      -- Web / general formatters (conform)
      "prettier",
      "stylua",
      "shfmt",
      "clang-format",
      -- Go
      "gofumpt",
      "goimports",
      "delve",
    },
    run_on_start = true,
    start_delay = 2000, -- give the editor a moment to finish startup first
  },
}
