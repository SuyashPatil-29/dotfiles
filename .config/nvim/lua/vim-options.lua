vim.cmd "set expandtab"
vim.cmd "set tabstop=2"
vim.cmd "set softtabstop=2"
vim.cmd "set shiftwidth=2"
vim.g.mapleader = " "
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)
vim.opt.splitright = true -- force all vertical splits to go to the right of current window
vim.opt.splitbelow = true -- force all horizontal splits to go below current window
vim.opt.ignorecase = true -- ignore case in search patterns
vim.o.conceallevel = 2 -- Something that obsidian requires
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.updatetime = 100 -- faster completion (4000ms default)
vim.opt.undofile = true -- enable persistent undo
vim.opt.swapfile = false -- creates a swapfile
vim.opt.smartindent = true -- make indenting smarter again
vim.opt.smartcase = true -- smart case
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.ttimeoutlen = 10
vim.o.fileencodings = "utf-8"
-- For Lua
vim.opt.runtimepath:append "/home/suyash/.config/nvim/lua"

-- Disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- --Add spellchecks
-- vim.opt.spelllang = 'en_us'
-- vim.opt.spell = true
-- vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
--   require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
--   vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
-- end
