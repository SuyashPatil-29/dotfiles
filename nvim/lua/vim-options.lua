vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
--   require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
--   vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
-- end
