return {
  "nvimtools/none-ls.nvim", -- The plugin name
  config = function()
    local null_ls = require("null-ls") -- Require the null-ls plugin
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {}) -- Create an autocmd group for formatting

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua, -- Use the built-in stylua formatter
        null_ls.builtins.formatting.prettier, -- Use the built-in prettier formatter
        null_ls.builtins.completion.spell, -- Use the built-in spell completion
      },
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr }) -- Clear existing autocmds for the buffer
          vim.api.nvim_create_autocmd("BufWritePre", { -- Create a new autocmd that runs before saving the buffer
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr }) -- Format the buffer
            end,
          })
        end
      end,
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format buffer" }) -- Keybinding to format the buffer manually
  end,
}
