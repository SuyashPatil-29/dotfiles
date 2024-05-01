local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
vim.cmd('set number relativenumber')

require("vim-options")
require("remaps")
require("snippets")
require("lazy").setup("plugins")

if vim.opt.termguicolors:get() then
  vim.opt.termguicolors = true
end

require("notify").setup({
  background_colour = "#1e1e2e", -- A dark bluish-gray color
})
