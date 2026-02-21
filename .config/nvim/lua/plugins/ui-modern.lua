-- Modern UI enhancements
return {
  -- Better vim.ui.select and vim.ui.input
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = {
        enabled = true,
        default_prompt = "Input",
        win_options = {
          winblend = 0,
        },
      },
      select = {
        enabled = true,
        backend = { "builtin" },
        builtin = {
          border = "rounded",
          relative = "editor",
          win_options = {
            winblend = 0,
          },
        },
      },
    },
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    enabled = false, -- Enable if you want smooth scrolling (might conflict with mini.animate)
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
    },
  },

  -- Better code context at top of screen
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      enable = true,
      max_lines = 3,
      trim_scope = "outer",
      min_window_height = 0,
      mode = "cursor",
      separator = "─",
    },
    keys = {
      {
        "<leader>tc",
        function()
          require("treesitter-context").toggle()
        end,
        desc = "Toggle Treesitter Context",
      },
    },
  },

  -- Highlight colors in your editor
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    enabled = false, -- Enable if you want to see color previews
    config = function()
      require("colorizer").setup({
        "*", -- Highlight all files
        css = { css = true },
        javascript = { css = true },
      })
    end,
  },

  -- Indent guides (alternative to indent-blankline)
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "VeryLazy",
    enabled = false, -- Already have snacks statuscolumn
    main = "ibl",
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
        },
      },
    },
  },
}
