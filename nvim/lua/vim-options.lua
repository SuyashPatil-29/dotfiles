vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Explore, { desc = "Open NetRW" })
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
-- Copy text to " register
vim.keymap.set("n", "<leader>y", '"+y', { desc = 'Yank into " register' })
vim.keymap.set("v", "<leader>y", '"+y', { desc = 'Yank into " register' })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = 'Yank into " register' })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", '"_d', { desc = 'Delete into " register' })
vim.keymap.set("v", "<leader>d", '"_d', { desc = 'Delete into " register' })
-- Replace word under cursor across entire buffer
vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word under cursor" }
)

-- Set mapping for Ctrl-d
vim.api.nvim_set_keymap("n", "<C-d>", "<C-d>zz", { noremap = true, silent = true })

-- Set mapping for Ctrl-u
vim.api.nvim_set_keymap("n", "<C-u>", "<C-u>zz", { noremap = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>vv', ':split<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Left>', '<C-w>h', { noremap = true })

vim.api.nvim_set_keymap('n', '<leader>ha', '<cmd>lua harpoon_mark.add_file()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>hh', '<cmd>lua harpoon.ui.toggle_quick_menu()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>hj', '<cmd>lua harpoon.ui.nav_next()<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<leader>hk', '<cmd>lua harpoon.ui.nav_prev()<CR>', {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>m', ':MaximizerToggle<CR>', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<C-s>', '<cmd>lua require("spectre").toggle()<CR>', {noremap = true, silent = true})

