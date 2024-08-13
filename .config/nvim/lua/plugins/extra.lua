return {
  { "OrangeT/vim-csharp" },
  -- Autotags
  {
    "windwp/nvim-ts-autotag",
    opts = {},
  },

  -- delete buffer
  {
    "famiu/bufdelete.nvim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set(
        "n",
        "Q",
        ":lua require('bufdelete').bufdelete(0, false)<cr>",
        { noremap = true, silent = true, desc = "Delete buffer" }
      )
    end,
  },

  -- nvim-dap
  {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      automatic_installation = true,
      handlers = {},
      ensure_installed = {
        "delve", -- Go debugging
      },
      config = function()
        require("dap").setup()
      end,
    },
  },

  -- nvim-dap for go
  {
    "leoluz/nvim-dap-go",
    config = function()
      require("dap-go").setup()
    end,
  },
  -- useful when there are embedded languages in certain types of files (e.g. Vue or React)
  { "joosepalviste/nvim-ts-context-commentstring", lazy = true },

  -- Neovim plugin to improve the default vim.ui interfaces
  {
    "stevearc/dressing.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    config = function()
      require("dressing").setup()
    end,
  },

  -- Oil is a new way to edit your files

  -- {
  --   "stevearc/oil.nvim",
  --   opts = {},
  --   dependencies = { "nvim-tree/nvim-web-devicons" },
  --   config = function()
  --     require("oil").setup {
  --       default_file_explorer = false,
  --       delete_to_trash = true,
  --       skip_confirm_for_simple_edits = true,
  --       view_options = {
  --         show_hidden = true,
  --         natural_order = true,
  --         is_always_hidden = function(name, _)
  --           return name == ".." or name == ".git"
  --         end,
  --       },
  --       float = {
  --         padding = 2,
  --         max_width = 90,
  --         max_height = 0,
  --       },
  --       win_options = {
  --         wrap = true,
  --         winblend = 0,
  --       },
  --       keymaps = {
  --         ["C-s"] = false,
  --         ["<C-c>"] = false,
  --         ["<leader>c"] = "actions.close",
  --         ["g?"] = "actions.show_help",
  --         ["<CR>"] = "actions.select",
  --         ["<C-v>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
  --         ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
  --         ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
  --         ["<C-p>"] = "actions.preview",
  --         ["<C-l>"] = "actions.refresh",
  --         ["-"] = "actions.parent",
  --         ["_"] = "actions.open_cwd",
  --         ["`"] = "actions.cd",
  --         ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory" },
  --         ["gs"] = "actions.change_sort",
  --         ["gx"] = "actions.open_external",
  --         ["g."] = "actions.toggle_hidden",
  --         ["g\\"] = "actions.toggle_trash",
  --       },
  --     }
  --   end,
  -- },
  --
  -- Neovim notifications and LSP progress messages
  {
    "j-hui/fidget.nvim",
    branch = "legacy",
    enabled = false,
    config = function()
      require("fidget").setup {
        window = { blend = 0 },
      }
    end,
  },

  -- LSP client for JAVA using jdtls
  {
    "mfussenegger/nvim-jdtls",
    config = function() end,
  },

  -- Smooth scrolling neovim plugin written in lua
  {
    "karb94/neoscroll.nvim",
    config = function()
      require("neoscroll").setup {
        stop_eof = true,
        easing_function = "sine",
        hide_cursor = true,
        cursor_scrolls_alone = true,
      }
    end,
  },

  -- Bufferline to show tabs like vs code
  {
    "akinsho/nvim-bufferline.lua",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup {
        options = {
          offsets = {
            {
              filetype = "neo-tree",
              text = "File Explorer",
              text_align = "center",
            },
          },
          numbers = "ordinal",
          -- separator_style = "slant",
          show_buffer_close_icons = true,
          show_close_icon = true,
          max_name_length = 18,
          max_prefix_length = 15,   -- prefix used when a buffer is de-duplicated
          tab_size = 15,
          diagnostics = "nvim_lsp", -- Display diagnostics in the bufferline
          left_trunc_marker = "",
          right_trunc_marker = "",
          show_tab_indicators = true,
          always_show_bufferline = true,
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and "   " or (e == "warning" and "   " or "   ")
              s = s .. n .. sym
            end
            return s
          end,
          color_icons = true,
        },
      }
    end,
  },

  -- find and replace
  {
    "nvim-pack/nvim-spectre",
    cmd = { "Spectre" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "catppuccin/nvim",
    },
    config = function()
      local theme = require("catppuccin.palettes").get_palette "macchiato"

      vim.api.nvim_set_hl(0, "SpectreSearch", { bg = theme.red, fg = theme.base })
      vim.api.nvim_set_hl(0, "SpectreReplace", { bg = theme.green, fg = theme.base })

      require("spectre").setup {
        highlight = {
          search = "SpectreSearch",
          replace = "SpectreReplace",
        },
        mapping = {
          ["send_to_qf"] = {
            map = "<C-q>",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "send all items to quickfix",
          },
        },
      }
    end,
  },

  -- Add/change/delete surrounding delimiter pairs with ease
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },

  -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API
  {
    "folke/neodev.nvim",
    config = function()
      require("neodev").setup {
        library = { plugins = { "neotest" }, types = true },
      }
    end,
  },

  -- Neovim Lua plugin to automatically manage character pairs. Part of 'mini.nvim' library.
  {
    "echasnovski/mini.pairs",
    event = "VeryLazy",
    config = function(_, opts)
      require("mini.pairs").setup(opts)
    end,
  },

  {
    "echasnovski/mini.indentscope",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.indentscope").setup()
    end,
  },

  {
    "echasnovski/mini.animate",
    version = false,
    event = "VeryLazy",
    config = function()
      require("mini.animate").setup {
        -- Cursor path
        cursor = {
          enable = false,
        },

        -- Vertical scroll
        scroll = {
          enable = true,
        },

        -- Window resize
        resize = {
          enable = true,
        },

        -- Window open
        open = {
          enable = true,
        },

        -- Window close
        close = {
          enable = true,
        },
      }
    end,
  },

  -- Lorem Ipsum generator for Neovim
  {
    "derektata/lorem.nvim",
    enabled = false,
    config = function()
      local lorem = require "lorem"
      lorem.setup {
        sentenceLength = "mixedShort",
        comma = 1,
      }
    end,
  },

  -- Indent guide for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    enabled = false,
    version = "2.1.0",
    opts = {
      char = "┊",
      -- char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- editor config support
  {
    "editorconfig/editorconfig-vim",
  },

  -- Enhanced f/t motions for Leap
  {
    "ggandor/flit.nvim",
    keys = function()
      ---@type LazyKeys[]
      local ret = {}
      for _, key in ipairs { "f", "F", "t", "T" } do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  -- mouse replacement
  {
    "ggandor/leap.nvim",
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require "leap"
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  -- breadcrumbs
  -- {
  --   "LunarVim/breadcrumbs.nvim",
  --   config = function()
  --     require("breadcrumbs").setup()
  --   end,
  -- },
  -- Simple winbar/statusline plugin that shows your current code context
  -- {
  --   "SmiteshP/nvim-navic",
  --   config = function()
  --     local icons = require("config.icons")
  --     require("nvim-navic").setup({
  --       highlight = true,
  --       lsp = {
  --         auto_attach = true,
  --         preference = { "typescript-tools" },
  --       },
  --       click = true,
  --       separator = " " .. icons.ui.ChevronRight .. " ",
  --       depth_limit = 0,
  --       depth_limit_indicator = "..",
  --       icons = {
  --         File = " ",
  --         Module = " ",
  --         Namespace = " ",
  --         Package = " ",
  --         Class = " ",
  --         Method = " ",
  --         Property = " ",
  --         Field = " ",
  --         Constructor = " ",
  --         Enum = " ",
  --         Interface = " ",
  --         Function = " ",
  --         Variable = " ",
  --         Constant = " ",
  --         String = " ",
  --         Number = " ",
  --         Boolean = " ",
  --         Array = " ",
  --         Object = " ",
  --         Key = " ",
  --         Null = " ",
  --         EnumMember = " ",
  --         Struct = " ",
  --         Event = " ",
  --         Operator = " ",
  --         TypeParameter = " ",
  --       },
  --     })
  --   end,
  -- },

  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
      -- configurations go here
    },
    config = function()
      require("barbecue").setup {
        create_autocmd = false, -- prevent barbecue from updating itself automatically
      }

      vim.api.nvim_create_autocmd({
        "WinScrolled", -- or WinResized on NVIM-v0.9 and higher
        "BufWinEnter",
        "CursorHold",
        "InsertLeave",

        -- include this if you have set `show_modified` to `true`
        -- "BufModifiedSet",
      }, {
        group = vim.api.nvim_create_augroup("barbecue.updater", {}),
        callback = function()
          require("barbecue.ui").update()
        end,
      })
    end,
  },
  -- better code annotation
  {
    "danymat/neogen",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local neogen = require "neogen"

      neogen.setup {
        snippet_engine = "luasnip",
      }
    end,
    -- version = "*"
  },

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
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },
  {
    "ThePrimeagen/vim-be-good",
    lazy = true,
    cmd = { "VimBeGood" },
    config = function()
      -- require("ibl").setup()
    end,
  },
  -- Plugin to follow links in MD
  { "jghauser/follow-md-links.nvim" },
  -- Images in neovim

  {
    "vhyrro/luarocks.nvim",
    priority = 1001, -- this plugin needs to run before anything else
    opts = {
      rocks = { "magick" },
    },
  },
  -- {
  --   "3rd/image.nvim",
  --   config = function()
  --     require("image").setup {
  --       backend = "kitty",
  --       integrations = {
  --         markdown = {
  --           enabled = true,
  --           clear_in_insert_mode = false,
  --           download_remote_images = true,
  --           only_render_image_at_cursor = false,
  --           filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
  --           resolve_image_path = function(document_path, image_path, fallback)
  --             return fallback(document_path, image_path)
  --           end,
  --         },
  --         html = {
  --           enabled = false,
  --         },
  --         css = {
  --           enabled = false,
  --         },
  --       },
  --       max_width = nil,
  --       max_height = nil,
  --       max_width_window_percentage = nil,
  --       max_height_window_percentage = 50,
  --       window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
  --       window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
  --       editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
  --       tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
  --       hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
  --     }
  --   end,
  -- },

  -- Markdown Preview
  -- install without yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },

  -- Yazi file manager for neovim

  -- {
  --   "DreamMaoMao/yazi.nvim",
  --   dependencies = {
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-lua/plenary.nvim",
  --   },
  --
  --   keys = {
  --     { "<leader>e", "<cmd>Yazi<CR>", desc = "Toggle Yazi" },
  --   },
  -- },

  -- Lazy
  {
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    keys = {
      {
        "gw",
        mode = { "n", "x" },
        function()
          require("wtf").ai()
        end,
        desc = "Debug diagnostic with AI",
      },
      {
        mode = { "n" },
        "gW",
        function()
          require("wtf").search()
        end,
        desc = "Search diagnostic with Google",
      },
    },
    config = function()
      require("wtf").setup(
        {
          -- Default AI popup type
          popup_type = "vertical",
          -- An alternative way to set your API key
          openai_api_key = vim.env.OPENAI_API_KEY,
          -- ChatGPT Model
          openai_model_id = "gpt-3.5-turbo",
          -- Send code as well as diagnostics
          context = true,
          -- Set your preferred language for the response
          language = "english",
          -- Any additional instructions
          additional_instructions = "Start the reply with 'OH HAI THERE'",
          -- Default search engine, can be overridden by passing an option to WtfSeatch
          search_engine = "google",
          -- Callbacks
          hooks = {
            request_started = nil,
            request_finished = nil,
          },
          -- Add custom colours
          winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        }
      )
    end
  },
  -- Lazy
  {
    'piersolenski/telescope-import.nvim',
    dependencies = 'nvim-telescope/telescope.nvim',
    config = function()
      require("telescope").load_extension("import")
      require("telescope").setup({
        extensions = {
          import = {
            -- Add imports to the top of the file keeping the cursor in place
            insert_at_top = true,
            -- Support additional languages
            custom_languages = {
              {
                -- The regex pattern for the import statement
                regex = [[^(?:import(?:[\"'\s]*([\w*{}\n, ]+)from\s*)?[\"'\s](.*?)[\"'\s].*)]],
                -- The Vim filetypes
                filetypes = { "typescript", "typescriptreact", "javascript", "react" },
                -- The filetypes that ripgrep supports (find these via `rg --type-list`)
                extensions = { "js", "ts" },
              },
            },
          },
        },
        vim.keymap.set("n", "<leader>fi", "<cmd>Telescope import<cr>", { desc = "Import" })
      })
    end
  }
}
