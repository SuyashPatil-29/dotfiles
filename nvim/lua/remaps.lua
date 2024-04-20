vim.keymap.set("n", "<leader>pv", vim.cmd.Explore, { desc = "Open NetRW" })
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })
-- Copy text to " register
vim.keymap.set("n", "<leader>y", '"+y', { desc = 'Yank into " register' })
vim.keymap.set("v", "<leader>y", '"+y<CR>gv', { desc = 'Yank into " register' })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = 'Yank into " register' })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", '"_d', { desc = 'Delete into " register' })
    vim.keymap.set("v", "<leader>d", '"_d', { desc = 'Delete into " register' })

-- Space + a to select all text
vim.api.nvim_set_keymap('n', '<leader>a', 'ggVG', { noremap = true })

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

-- Map g+Up to Up
vim.api.nvim_set_keymap('n', '<Up>', 'g<Up>', { noremap = true })

-- Map g+Down to Down
vim.api.nvim_set_keymap('n', '<Down>', 'g<Down>', { noremap = true })

-- Split screen vertically
vim.api.nvim_set_keymap('n', '<leader>v', ':vsplit<CR>', { noremap = true })

-- Split screen horizontally
vim.api.nvim_set_keymap('n', '<leader>vv', ':split<CR>', { noremap = true })

-- Navigate between splits
vim.api.nvim_set_keymap('n', '<C-Right>', '<C-w>l', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Left>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Down>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Up>', '<C-w>k', { noremap = true })


-- Harpoon keymaps
vim.api.nvim_set_keymap('n', '<leader>ha', '<cmd>lua harpoon_mark.add_file()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>hh', '<cmd>lua harpoon.ui.toggle_quick_menu()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>hj', '<cmd>lua harpoon.ui.nav_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>hk', '<cmd>lua harpoon.ui.nav_prev()<CR>', { noremap = true, silent = true })

--Maximize current buffer
vim.api.nvim_set_keymap('n', '<leader>m', ':MaximizerToggle<CR>', { noremap = true, silent = true })

--Find and replace
vim.api.nvim_set_keymap('n', '<leader>r', '<cmd>lua require("spectre").toggle()<CR>', { noremap = true, silent = true })

-- Go to next error
vim.api.nvim_set_keymap('n', ']e', ':lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>zz',
  { noremap = true, silent = true })

--rip grep in current working directory
vim.api.nvim_set_keymap('n', '<leader>g', ':lua require("telescope.builtin").live_grep()<CR>',
  { noremap = true, silent = true })

-- Open a new line above the current line in normal mode
vim.api.nvim_set_keymap('n', '<leader>o', 'O<Esc>', { noremap = true })

-- Open a new tab
vim.api.nvim_set_keymap('n', '<leader>t', ':tabe<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<leader>ss', ':CodeSnapPreviewOn', { noremap = true, silent = true })

--Open Quickfix window
vim.api.nvim_set_keymap('n', '<leader>q', ':copen<CR>', { noremap = true, silent = true })

--Close Quickfix window
vim.api.nvim_set_keymap('n', '<leader>qq', ':cclose<CR>', { noremap = true, silent = true })

-- Delete everything on screen
vim.api.nvim_set_keymap('n', '<leader>d', 'ggVGd', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<A-Up>', ':m-2<CR>', { noremap = true, silent = true })

vim.api.nvim_set_keymap('n', '<A-Down>', ':m+1<CR>', { noremap = true, silent = true })

-- Move selected text up
vim.api.nvim_set_keymap('x', '<A-Up>', 'dkP`[V`]', { noremap = true, silent = true })

-- Move selected text down
vim.api.nvim_set_keymap('x', '<A-Down>', 'dp`[V`]', { noremap = true, silent = true })

-- Map Shift+Alt+Up to copy the current line above and move the cursor to the new line
vim.api.nvim_set_keymap('n', '<S-A-Up>', '<cmd>call append(line(".") - 1, getline("."))<CR>k',
  { noremap = true, silent = true })

-- Map Shift+Alt+Down to copy the current line below and move the cursor to the new line
vim.api.nvim_set_keymap('n', '<S-A-Down>', '<cmd>call append(line("."), getline("."))<CR>j',
  { noremap = true, silent = true })

-- Map Shift+Alt+Up in visual mode to create empty lines above and duplicate the selected text
vim.api.nvim_set_keymap('v', '<S-A-Up>',
  "<cmd>'<,'>t'<-1<CR>:call repeat#set('\\<Plug>MultipleCursorAction', v:count1)<CR>gvr=<CR>",
  { noremap = true, silent = true })

-- Map Shift+Alt+Down in visual mode to create empty lines below and duplicate the selected text
vim.api.nvim_set_keymap('v', '<S-A-Down>',
  "<cmd>'<,'>t'>+1<CR>:call repeat#set('\\<Plug>MultipleCursorAction', v:count1)<CR>gvjo<Esc>r=<CR>",
  { noremap = true, silent = true })

-- Map Shift+Alt+Down in visual mode to create empty lines below and duplicate the selected text
vim.api.nvim_set_keymap('v', '<S-A-Down>',
  "<cmd>'<,'>t'>+1<CR>:call repeat#set('\\<Plug>MultipleCursorAction', v:count1)<CR>gvjo<Esc>r=<CR>",
  { noremap = true, silent = true })

-- Move selected text up
vim.api.nvim_set_keymap('x', '<A-Up>', 'dkP`[V`]', { noremap = true, silent = true })

-- Move selected text down
vim.api.nvim_set_keymap('x', '<A-Down>', 'dp`[V`]', { noremap = true, silent = true })

-- Map Shift+Alt+Up to copy the current line above and move the cursor to the new line
vim.api.nvim_set_keymap('n', '<S-A-Up>', '<cmd>call append(line(".") - 1, getline("."))<CR>k',
  { noremap = true, silent = true })

-- Map Shift+Alt+Down to copy the current line below and move the cursor to the new line
vim.api.nvim_set_keymap('n', '<S-A-Down>', '<cmd>call append(line("."), getline("."))<CR>j',
  { noremap = true, silent = true })

-- Paste selected text
vim.api.nvim_set_keymap('v', '<C-z>', 'y\'>p', { noremap = true, silent = true })

-- Remap escape key to go to normal mode
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true })
