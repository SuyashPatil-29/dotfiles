return {
  {
    "ThePrimeagen/harpoon",
    event = "VeryLazy",
    config = function()
      require("harpoon").setup()

      -- Map <leader>ha to add the current file to harpoon marks
      vim.api.nvim_set_keymap('n', '<leader>ha', '<cmd>lua require("harpoon.mark").add_file()<CR>',
        { noremap = true, silent = true })
      -- Map <leader>hh to toggle the harpoon quick menu
      vim.api.nvim_set_keymap('n', '<leader>hh', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>',
        { noremap = true, silent = true })
      -- Map <leader>hj to navigate to the next harpoon mark
      vim.api.nvim_set_keymap('n', '<leader>hr', '<cmd>lua require("harpoon.mark").rm_file()<CR>',
        { noremap = true, silent = true })

      -- Map <leader>hk to navigate to the previous harpoon mark
      vim.api.nvim_set_keymap('n', '<leader>hc', '<cmd>lua require("harpoon.mark").clear_all()<CR>',
        { noremap = true, silent = true })


      vim.api.nvim_set_keymap('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<CR>',
        { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<CR>',
        { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<CR>',
        { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<CR>',
        { noremap = true, silent = true })
      vim.api.nvim_set_keymap('n', '<leader>5', '<cmd>lua require("harpoon.ui").nav_file(5)<CR>',
        { noremap = true, silent = true })
    end,
  },
}
