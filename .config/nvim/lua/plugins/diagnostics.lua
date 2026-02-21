-- Better diagnostic experience
return {
  -- Improved diagnostic virtual text
  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    event = "LspAttach",
    enabled = false, -- Enable if you want diagnostic lines instead of virtual text
    config = function()
      require("lsp_lines").setup()
      -- Disable virtual_text since it's redundant with lsp_lines
      vim.diagnostic.config({ virtual_text = false })

      -- Toggle lsp_lines with a keymap
      vim.keymap.set("n", "<leader>ld", require("lsp_lines").toggle, {
        desc = "Toggle LSP Lines",
      })
    end,
  },

  -- Better UI for LSP related items
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = {
      modes = {
        diagnostics = {
          auto_open = false,
          auto_close = true,
        },
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
    },
  },

  -- Enhanced LSP UI
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    enabled = false, -- Enable if you want lspsaga features
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      ui = {
        border = "rounded",
        code_action = "",
      },
      lightbulb = {
        enable = false,
        sign = false,
      },
      symbol_in_winbar = {
        enable = false,
      },
    },
    keys = {
      { "gh", "<cmd>Lspsaga finder<cr>", desc = "LSP Finder" },
      { "gp", "<cmd>Lspsaga peek_definition<cr>", desc = "Peek Definition" },
      { "K", "<cmd>Lspsaga hover_doc<cr>", desc = "Hover Doc" },
      { "<leader>ca", "<cmd>Lspsaga code_action<cr>", desc = "Code Action", mode = { "n", "v" } },
      { "<leader>rn", "<cmd>Lspsaga rename<cr>", desc = "Rename" },
    },
  },
}
