-- Python: treesitter + debugging.
-- LSP (basedpyright + ruff) and automatic venv detection live in
-- lua/plugins/lsp/lsp-config.lua. Formatting (ruff) lives in lsp/formatting.lua.
return {
  -- Ensure the Python parser is installed
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "python", "toml" } },
  },

  -- Debugging with debugpy. nvim-dap-python auto-discovers the project venv's
  -- python (or debugpy installed by Mason) so there is nothing to configure.
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      -- Prefer a project virtualenv, else fall back to Mason's debugpy.
      local function venv_python()
        if vim.env.VIRTUAL_ENV and vim.env.VIRTUAL_ENV ~= "" then
          local p = vim.env.VIRTUAL_ENV .. "/bin/python"
          if vim.fn.executable(p) == 1 then
            return p
          end
        end
        local mason_dbg = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        if vim.fn.executable(mason_dbg) == 1 then
          return mason_dbg
        end
        return vim.fn.exepath("python3")
      end

      require("dap-python").setup(venv_python())

      vim.keymap.set("n", "<leader>dn", function()
        require("dap-python").test_method()
      end, { desc = "Debug nearest Python test" })
      vim.keymap.set("n", "<leader>df", function()
        require("dap-python").test_class()
      end, { desc = "Debug Python test class" })
    end,
  },
}
