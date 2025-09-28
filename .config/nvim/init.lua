local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)
vim.cmd "set number relativenumber"

-- Load compatibility layer for deprecated functions
require "config.compatibility"

require "vim-options"
require "remaps"
require "snippets"
require("lazy").setup "plugins"

if vim.opt.termguicolors:get() then
  vim.opt.termguicolors = true
end
