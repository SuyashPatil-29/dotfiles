-- Translate TypeScript errors to human-readable messages
return {
  "dmmulroy/ts-error-translator.nvim",
  ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  config = function()
    require("ts-error-translator").setup({
      auto_attach = true, -- Updated from deprecated auto_override_publish_diagnostics
    })
  end
}
