-- UI enhancements and visual improvements
return {
  -- Highlight patterns and colors (replaces nvim-colorizer)
  {
    "echasnovski/mini.hipatterns",
    event = "VeryLazy",
    opts = function()
      local hipatterns = require("mini.hipatterns")
      return {
        highlighters = {
          -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
          todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
          note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          -- Highlight hex color strings `#rrggbb` and `#rrggbbaa`
          hex_color = hipatterns.gen_highlighter.hex_color(),
        },
      }
    end,
  },

  -- Mini map for code navigation (replaces barbecue breadcrumbs)
  {
    "echasnovski/mini.map",
    keys = {
      { "<leader>mc", function() require("mini.map").close() end, desc = "Close mini map" },
      { "<leader>mf", function() require("mini.map").toggle_focus() end, desc = "Focus mini map" },
      { "<leader>mo", function() require("mini.map").open() end, desc = "Open mini map" },
      { "<leader>mr", function() require("mini.map").refresh() end, desc = "Refresh mini map" },
      { "<leader>ms", function() require("mini.map").toggle_side() end, desc = "Toggle mini map side" },
      { "<leader>mt", function() require("mini.map").toggle() end, desc = "Toggle mini map" },
    },
    config = function()
      require("mini.map").setup()
      local map = require("mini.map")
      map.setup({
        integrations = {
          map.gen_integration.builtin_search(),
          map.gen_integration.gitsigns(),
          map.gen_integration.diagnostic(),
        },
      })
    end,
  },

  -- Indent scope visualization (already in your config, but ensuring it's here)
  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "VeryLazy",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },
}
