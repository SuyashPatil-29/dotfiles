-- -- Theme/Colorscheme
-- return {
--   "catppuccin/nvim",
--   name = "catppuccin",
--   priority = 1000,
--   config = function()
--     require("catppuccin").setup({
--       flavour = "macchiato", -- latte, frappe, macchiato, mocha
--       background = { -- :h background
--         light = "macchiato",
--         dark = "macchiato",
--       },
--     })
--     -- setup must be called before loading
--     vim.cmd.colorscheme "catppuccin"
--   end,
-- }
--

return {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('onedark').setup {
        -- Set a style preset. 'dark' is default.
        style = 'dark', -- dark, darker, cool, deep, warm, warmer, light
      }
      require('onedark').load()
    end,
  }
