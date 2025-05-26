return {
  'stevearc/oil.nvim',
  config = function()
    -- Disable netrw
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("oil").setup({
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      default_file_explorer = true,

      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        "icon",
        -- "permissions", -- Removed to hide rwxr-xr-x display
        -- "size",
        -- "mtime",
      },

      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },

      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },

      -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      delete_to_trash = true,

      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = true,

      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      -- (:help prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = true,

      -- Oil will automatically delete hidden buffers after this delay
      -- You can set the delay to false to disable cleanup entirely
      -- Note that the cleanup process only starts when you enter Oil buffers
      cleanup_delay_ms = 2000,

      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = true,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only autosave unmodified buffers
        autosave_changes = false,
      },

      -- Constrain the cursor to the editable parts of the oil buffer
      -- Set to `false` to disable, or "name" to keep it on the file names
      constrain_cursor = "editable",

      -- Set to true to watch the filesystem for changes and reload oil
      watch_for_changes = true,

      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = false, -- Disable preview to avoid conflict with file finder
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        -- Enhanced floating-specific mappings
        ["<esc>"] = "actions.close",
        ["q"] = "actions.close",
        ["H"] = "g^", -- Go to first entry
        ["L"] = "g$", -- Go to last entry
      },

      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,

      view_options = {
        -- Show files and directories that start with "."
        show_hidden = false,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          -- Hide common temp/build files
          local hidden_patterns = {
            "%.DS_Store$",
            "%.git$",
            "node_modules$",
            "%.cache$",
            "%.tmp$",
            "%.log$",
          }
          for _, pattern in ipairs(hidden_patterns) do
            if name:match(pattern) then
              return true
            end
          end
          return false
        end,
        -- Sort file names in a more intuitive order for humans. Is less performant,
        -- so you can set to false if you prefer. Will use "smart" sorting only when
        -- show_hidden = true
        natural_order = true,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      },

      -- Extra arguments to pass to SCP when moving/copying files over SSH
      extra_scp_args = {},

      -- EXPERIMENTAL support for performing file operations with git
      git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path)
          return false
        end,
        mv = function(src_path, dest_path)
          return false
        end,
        rm = function(path)
          return false
        end,
      },

      -- Enhanced floating window configuration
      float = {
        padding = 4,
        max_width = 120,
        max_height = 40,
        border = "rounded",
        win_options = {
          winblend = 10,
        },
        preview_split = "auto",
        -- Custom override for better floating experience
        override = function(conf)
          -- Calculate better dimensions based on screen size
          local screen_w = vim.o.columns
          local screen_h = vim.o.lines
          
          -- Use 70% of screen width, but not more than 100 columns
          conf.width = math.min(math.floor(screen_w * 0.7), 100)
          -- Use 70% of screen height, but not more than 30 rows
          conf.height = math.min(math.floor(screen_h * 0.7), 30)
          
          -- Center the window
          conf.row = math.floor((screen_h - conf.height) / 2)
          conf.col = math.floor((screen_w - conf.width) / 2)
          
          return conf
        end,
      },

      -- Configuration for the actions floating preview window
      preview = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        max_width = 0.9,
        -- min_width = {40, 0.4} means "at least 40 columns, or at least 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        max_height = 0.9,
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
      },

      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },

      -- Configuration for the floating SSH window
      ssh = {
        border = "rounded",
      },
    })

    -- Key mappings for Oil
    vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    vim.keymap.set("n", "<leader><tab>", "<CMD>OilToggle<CR>", { desc = "Toggle Oil file explorer" })
    vim.keymap.set("n", "<leader>e", "<CMD>OilFloat<CR>", { desc = "Toggle Oil floating window" })



    -- Enhanced Oil buffer autocommands
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        local opts = { buffer = true, silent = true }
        
        -- Enhanced navigation for floating windows
        vim.keymap.set("n", "H", "g^", opts) -- Go to first file
        vim.keymap.set("n", "L", "g$", opts) -- Go to last file
        
        -- Yank operations (copy file names/paths)
        vim.keymap.set("n", "yy", function()
          local oil = require("oil")
          local entry = oil.get_cursor_entry()
          if entry then
            vim.fn.setreg("+", entry.name)
            vim.notify("Yanked: " .. entry.name)
          end
        end, opts)
        
        vim.keymap.set("n", "yp", function()
          local oil = require("oil")
          local dir = oil.get_current_dir()
          local entry = oil.get_cursor_entry()
          if entry and dir then
            local full_path = dir .. entry.name
            vim.fn.setreg("+", full_path)
            vim.notify("Yanked full path: " .. full_path)
          end
        end, opts)
        
        -- Quick directory operations
        vim.keymap.set("n", "cd", function()
          local oil = require("oil")
          local dir = oil.get_current_dir()
          if dir then
            vim.cmd("cd " .. dir)
            vim.notify("Changed directory to: " .. dir)
          end
        end, opts)
        
        -- Enhanced file operations - auto-close floating when opening files (OPTIMIZED)
        vim.keymap.set("n", "<cr>", function()
          local entry = require("oil").get_cursor_entry()
          if entry and entry.type == "file" then
            -- Close floating window when opening a file (no delay)
            local win_config = vim.api.nvim_win_get_config(0)
            if win_config.relative ~= "" then -- is floating
              require("oil").close()
            end
          end
          -- Execute the default select action
          require("oil.actions").select.callback()
        end, opts)
      end,
    })

    -- Enhanced Oil commands
    vim.api.nvim_create_user_command("OilToggle", function()
      local oil = require("oil")
      local current_buf = vim.api.nvim_get_current_buf()
      
      if vim.bo[current_buf].filetype == "oil" then
        oil.close()
      else
        oil.open()
      end
    end, { desc = "Toggle Oil file explorer" })

    vim.api.nvim_create_user_command("OilFloat", function()
      require("oil").open_float()
    end, { desc = "Open Oil in floating window" })

    vim.api.nvim_create_user_command("OilFloatCwd", function()
      require("oil").open_float(".")
    end, { desc = "Open Oil floating in current working directory" })

    -- Optional: Create a custom status line for Oil buffers
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "oil",
      callback = function()
        vim.opt_local.statusline = "%#Normal# 📁 Oil: %{substitute(getcwd(), $HOME, '~', '')} %="
      end,
    })
  end,
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
