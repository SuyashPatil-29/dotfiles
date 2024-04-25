local colorscheme = require "plugins.colorscheme"
return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require("telescope").setup({
        extensions_list = { "themes", "terms" },
        extensions = {
          ['ui-select'] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })

      local builtin = require("telescope.builtin")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local pickers = require("telescope.pickers")
      local finders = require("telescope.finders")
      local sorters = require("telescope.sorters")

      function enter(prompt_bufnr)
        local selected = action_state.get_selected_entry()
        if selected then
          local color_scheme = selected.value
          vim.cmd("colorscheme " .. color_scheme)
          actions.close(prompt_bufnr)
        end
      end

      function next_color(prompt_bufnr)
        actions.move_selection_next(prompt_bufnr)
        local selected = action_state.get_selected_entry()
        local cmd = 'colorscheme ' .. selected[1]
        vim.cmd(cmd)
      end

      function prev_color(prompt_bufnr)
        actions.move_selection_previous(prompt_bufnr)
        local selected = action_state.get_selected_entry()
        local cmd = 'colorscheme ' .. selected[1]
        vim.cmd(cmd)
      end

      local all_colors = { "catppuccin", "catppuccin-frappe", "catppuccin-latte", "catppuccin-macchiato", "codemonkey",
        "catppuccin-mocha", "desert", "elflord", "evening", "habamax", "industry",
        "koehler", "lunaperche", "murphy", "pablo", "peachpuff", "quiet", "ron", "slate", "torte", "onedark", "onedarker",
        "onedarkest", "tokyonight",
      }

      local opts = {
        finder = finders.new_table(all_colors),
        sorter = sorters.get_generic_fuzzy_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          map("i", "<CR>", enter)
          map("i", "<Down>", next_color)
          map("i", "<Up>", prev_color)

          map("n", "<CR>", enter)
          map("n", "<Down>", next_color)
          map("n", "<Up>", prev_color)
          return true
        end,
        theme = "dropdown", -- Use the 'ivy' theme for better UX
      }


      local colors = pickers.new(opts)
      vim.keymap.set('n', '<leader>cp', function() colors:find() end, { desc = "Color Picker" })

      vim.keymap.set('n', '<C-p>', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Find Buffers" })

      require("telescope").load_extension("ui-select")
    end
  },
}
