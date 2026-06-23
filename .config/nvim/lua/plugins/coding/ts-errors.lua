-- TypeScript error ergonomics
return {
  -- Translate TypeScript errors to human-readable messages
  {
    "dmmulroy/ts-error-translator.nvim",
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    config = function()
      require("ts-error-translator").setup({
        auto_attach = true, -- Updated from deprecated auto_override_publish_diagnostics
      })
    end,
  },

  -- Prettier inline display of TS errors
  {
    "OlegGulevskyy/better-ts-errors.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = { "typescript", "typescriptreact" },
    config = {
      keymaps = {
        toggle = "<leader>dd",          -- default '<leader>dd'
        go_to_definition = "<leader>dx", -- default '<leader>dx'
      },
    },
  },
}
