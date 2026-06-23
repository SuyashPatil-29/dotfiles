-- Treesitter-adjacent editing helpers and quickfix tooling
return {
  -- Autotags for HTML/JSX/TSX
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- Context-aware commentstring (used by mini.comment for embedded languages)
  { "joosepalviste/nvim-ts-context-commentstring", lazy = true },

  -- Treesitter textobjects
  { "nvim-treesitter/nvim-treesitter-textobjects" },

  -- Better code annotation / docblocks
  {
    "danymat/neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      require("neogen").setup {
        snippet_engine = "luasnip",
      }
    end,
  },

  -- Refactoring helpers
  {
    "ThePrimeagen/refactoring.nvim",
    enabled = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    config = function()
      require("refactoring").setup {}
    end,
  },

  -- Better quickfix window
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {},
  },
}
