-- Additional mini.nvim plugins for enhanced editing
return {
  -- Better text objects with AI (around/inside)
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          g = function() -- Whole buffer, inspired by https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-ai.md#textobject-specifications
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
    end,
  },

  -- Move lines and selections easily
  {
    "echasnovski/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        -- Move visual selection in Visual mode
        left = "",
        right = "",
        down = "<A-Down>",
        up = "<A-Up>",

        -- Move current line in Normal mode
        line_left = "",
        line_right = "",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },

  -- Better increment/decrement
  {
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    opts = {
      mappings = {
        toggle = "gS",
      },
    },
  },

  -- Highlight word under cursor
  {
    "echasnovski/mini.cursorword",
    event = "VeryLazy",
    config = function()
      require("mini.cursorword").setup({
        delay = 100,
      })
    end,
  },
}
