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

  local tmux_sessions = pickers.new(opts, _)
  vim.keymap.set("n", "<leader>ts", function()
    tmux_sessions:find()
  end, { desc = "Switch Tmux Sessions" })
end

local function document_symbols_for_selected(prompt_bufnr)
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")
  local entry = action_state.get_selected_entry()

  if entry == nil then
    print("No file selected")
    return
  end

  actions.close(prompt_bufnr)

  vim.schedule(function()
    local bufnr = vim.fn.bufadd(entry.path)
    vim.fn.bufload(bufnr)

    local params = { textDocument = vim.lsp.util.make_text_document_params(bufnr) }

    vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result, _, _)
      if err then
        print("Error getting document symbols: " .. vim.inspect(err))
        return
      end

      if not result or vim.tbl_isempty(result) then
        print("No symbols found")
        return
      end

      local function flatten_symbols(symbols, parent_name)
        local flattened = {}
        for _, symbol in ipairs(symbols) do
          local name = symbol.name
          if parent_name then
            name = parent_name .. "." .. name
          end
          table.insert(flattened, {
            name = name,
            kind = symbol.kind,
            range = symbol.range,
            selectionRange = symbol.selectionRange,
          })
          if symbol.children then
            local children = flatten_symbols(symbol.children, name)
            for _, child in ipairs(children) do
              table.insert(flattened, child)
            end
          end
        end
        return flattened
      end

      local flat_symbols = flatten_symbols(result)

      -- Define highlight group for symbol kind
      vim.cmd([[highlight TelescopeSymbolKind guifg=#61AFEF]])

      require("telescope.pickers").new({}, {
        prompt_title = "Document Symbols: " .. vim.fn.fnamemodify(entry.path, ":t"),
        finder = require("telescope.finders").new_table({
          results = flat_symbols,
          entry_maker = function(symbol)
            local kind = vim.lsp.protocol.SymbolKind[symbol.kind] or "Other"
            return {
              value = symbol,
              display = function(entry)
                local display_text = string.format("%-50s %s", entry.value.name, kind)
                return display_text, { { { #entry.value.name + 1, #display_text }, "TelescopeSymbolKind" } }
              end,
              ordinal = symbol.name,
              filename = entry.path,
              lnum = symbol.selectionRange.start.line + 1,
              col = symbol.selectionRange.start.character + 1,
            }
          end,
        }),
        sorter = require("telescope.config").values.generic_sorter({}),
        previewer = require("telescope.config").values.qflist_previewer({}),
        attach_mappings = function(_, map)
          map("i", "<CR>", function(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            vim.cmd("edit " .. selection.filename)
            vim.api.nvim_win_set_cursor(0, { selection.lnum, selection.col - 1 })
          end)
          return true
        end,
      }):find()
    end)
  end)
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
      mappings = {
        i = {
          ["<esc>"] = actions.close,

          ["<C-s>"] = document_symbols_for_selected,
        },

        n = {
          ["<C-s>"] = document_symbols_for_selected,
        },


      },
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
