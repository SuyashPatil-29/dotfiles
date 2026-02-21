-- Set leader key first (must be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Tab settings
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
-- UI Settings
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.colorcolumn = "120"

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- Editing behavior
vim.opt.smartindent = true
vim.opt.textwidth = 118
vim.opt.scrolloff = 22
vim.opt.conceallevel = 2
vim.opt.ttimeoutlen = 10

-- File handling
vim.opt.fileencodings = "utf-8"
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.writebackup = false
vim.opt.updatetime = 100

-- Completion
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.pumheight = 10

-- Disable netrw (using snacks.nvim explorer instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Filetype associations
vim.filetype.add({
  filename = {
    [".env"] = "sh",
    [".envrc"] = "sh",
  },
  extension = {
    gjs = "javascript",  -- Use JavaScript highlighting for .gjs
    gts = "typescript",  -- Use TypeScript highlighting for .gts
  },
  pattern = {
    ["%.env%..*"] = "sh",
  }
})
