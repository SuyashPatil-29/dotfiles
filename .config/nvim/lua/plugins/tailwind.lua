return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tailwindcss = {},
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      { "roobert/tailwindcss-colorizer-cmp.nvim", config = true },
    },
    opts = function(_, opts)
      opts.formatting = {
        format = require("tailwindcss-colorizer-cmp").formatter,
      }
      opts.window = {
        documentation = {
          border = "rounded",
          winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
        },
      }
    end,
  },
}
