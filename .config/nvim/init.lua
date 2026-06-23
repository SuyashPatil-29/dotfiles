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

-- Load compatibility layer for deprecated functions
require "config.compatibility"

-- Load vim options first (including leader key)
require "vim-options"
require "remaps"
require "snippets"

-- Plugins are organized into category folders under lua/plugins/.
-- lazy.nvim does not recurse into subdirectories automatically, so each
-- category is imported explicitly here.
require("lazy").setup({
  spec = {
    { import = "plugins.ui" },
    { import = "plugins.editor" },
    { import = "plugins.coding" },
    { import = "plugins.lsp" },
    { import = "plugins.ai" },
    { import = "plugins.lang" },
    { import = "plugins.git" },
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = false },
})

if vim.opt.termguicolors:get() then
  vim.opt.termguicolors = true
end
