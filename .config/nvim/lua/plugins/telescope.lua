-- Tmux Sessions Configuration
local function configure_tmux_sessions()
  local actions = require "telescope.actions"
  local action_state = require "telescope.actions.state"
  local pickers = require "telescope.pickers"
  local finders = require "telescope.finders"
  local sorters = require "telescope.sorters"

  local function switch_tmux_session(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    if selected then
      vim.cmd("silent !tmux switch-client -t " .. selected.value)
      actions.close(prompt_bufnr)
    end
  end

  local opts = {
    finder = finders.new_oneshot_job({ "tmux", "list-sessions", "-F", "#{session_name}" }, {
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry,
        }
      end,
    }),
    sorter = sorters.get_generic_fuzzy_sorter {},
    attach_mappings = function(prompt_bufnr, map)
      map("i", "<CR>", switch_tmux_session)
      map("n", "<CR>", switch_tmux_session)
      return true
    end,
    theme = "dropdown",
  }

  local tmux_sessions = pickers.new(opts)
  vim.keymap.set("n", "<leader>ts", function()
    tmux_sessions:find()
  end, { desc = "Switch Tmux Sessions" })
end

-- Telescope Configuration
local function configure_telescope()
  local telescope = require "telescope"
  local actions = require "telescope.actions"
  local icons = require "config.icons"

  telescope.load_extension("neoclip")
  telescope.load_extension("noice")


  vim.api.nvim_create_autocmd("FileType", {
    pattern = "TelescopeResults",
    callback = function(ctx)
      vim.api.nvim_buf_call(ctx.buf, function()
        vim.fn.matchadd("TelescopeParent", "\t\t.*$")
        vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
      end)
    end,
  })

  telescope.setup {
    defaults = {
      mappings = { i = { ["<esc>"] = actions.close } },
      path_display = { "filename_first" },
      previewer = false,
      prompt_prefix = " " .. icons.ui.Telescope .. " ",
      selection_caret = icons.ui.BoldArrowRight .. " ",
      file_ignore_patterns = { "node_modules", "package-lock.json" },
      initial_mode = "insert",
      select_strategy = "reset",
      sorting_strategy = "ascending",
      color_devicons = true,
      set_env = { ["COLORTERM"] = "truecolor" },
      layout_config = {
        prompt_position = "top",
        preview_cutoff = 120,
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
        "--glob=!.git/",
      },
    },
    pickers = {
      find_files = {
        previewer = false,
        layout_config = { height = 0.4, prompt_position = "top", preview_cutoff = 120 },
        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" }, -- Make sure to include hidden files
      },
      git_files = {
        previewer = false,
        layout_config = { height = 0.4, prompt_position = "top", preview_cutoff = 120 },
      },
      buffers = {
        mappings = { i = { ["<c-d>"] = actions.delete_buffer }, n = { ["<c-d>"] = actions.delete_buffer } },
        previewer = false,
        initial_mode = "normal",
        layout_config = { height = 0.4, width = 0.6, prompt_position = "top", preview_cutoff = 120 },
      },
      current_buffer_fuzzy_find = {
        previewer = true,
        layout_config = { prompt_position = "top", preview_cutoff = 120 },
      },
      live_grep = {
        only_sort_text = true,
        previewer = true,
      },
      grep_string = {
        only_sort_text = true,
        previewer = true,
      },
      lsp_references = {
        show_line = false,
        previewer = true,
      },
      treesitter = {
        show_line = false,
        previewer = true,
      },
      colorscheme = {
        enable_preview = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          previewer = false,
          initial_mode = "normal",
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = {
              width = 0.5,
              height = 0.4,
              preview_width = 0.6,
            },
          },
        },
      },
      package_info = {
        -- Optional theme (the extension doesn't set a default theme)
        -- theme = "ivy",
      },
      -- frecency = {
      --   default_workspace = "CWD",
      --   show_scores = true,
      --   show_unindexed = true,
      --   disable_devicons = false,
      --   ignore_patterns = {
      --     "*.git/*",
      --     "*/tmp/*",
      --     "*/lua-language-server/*",
      --   },
      -- },
    },
  }

  telescope.load_extension "ui-select"
end


-- Key Mappings for Telescope
local function setup_key_mappings()
  local builtin = require "telescope.builtin"
  vim.keymap.set("n", "<C-p>", builtin.find_files, {})
  vim.keymap.set("n", "<leader>ff", builtin.live_grep, { desc = "Open live grep" })
end

return {
  {
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      configure_telescope()
      configure_tmux_sessions()
      setup_key_mappings()
    end,
  },
}
