vim.cmd "set expandtab"
vim.cmd "set tabstop=2"
vim.cmd "set softtabstop=2"
vim.cmd "set shiftwidth=2"
vim.g.mapleader = " "
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.splitright = true    -- force all vertical splits to go to the right of current window
vim.opt.splitbelow = true    -- force all horizontal splits to go below current window
vim.opt.ignorecase = true    -- ignore case in search patterns

-- Disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
--   require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
--   vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
-- end
