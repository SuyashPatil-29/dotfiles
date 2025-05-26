return {
  -- C# support
  { "OrangeT/vim-csharp" },
  {
    "jinzhongjia/LspUI.nvim",
    branch = "main",
    config = function()
      require("LspUI").setup({
        -- config options go here
      })
    end
  },
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

  -- -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API
  -- {
  --   "folke/neodev.nvim",
  --   config = function()
  --     require("neodev").setup {
  --       library = { plugins = { "neotest" }, types = true },
  --       lspconfig = true,
  --     }
  --   end,
  -- },

  {
    'prichrd/netrw.nvim',
    opts = {},
    config = function()
      require("netrw").setup({
        -- File icons to use when `use_devicons` is false or if
        -- no icon is found for the given file type.
        icons = {
          symlink = '',
          directory = '',
          file = '',
        },
        -- Uses mini.icon or nvim-web-devicons if true, otherwise use the file icon specified above
        use_devicons = true,
        mappings = {
          -- Function mappings receive an object describing the node under the cursor
          ['p'] = function(payload) print(vim.inspect(payload)) end,
          -- String mappings are executed as vim commands
          ['<Leader>p'] = ":echo 'hello world'<CR>",
        },
      })
    end
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
    -- "echasnovski/mini.animate",
    -- version = false,
    -- event = "VeryLazy",
    -- config = function()
    --   require("mini.animate").setup {
    --     -- Cursor path
    --     cursor = {
    --       enable = false,
    --     },
    --
    --     -- Vertical scroll
    --     scroll = {
    --       enable = true,
    --     },
    --
    --     -- Window resize
    --     resize = {
    --       enable = true,
    --     },
    --
    --     -- Window open
    --     open = {
    --       enable = true,
    --     },
    --
    --     -- Window close
    --     close = {
    --       enable = true,
    --     },
    --   }
    -- end,
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

  -- breadcrumbs for neovim
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
  -- Session saving using persistence.nvim
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
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
    "ThePrimeagen/vim-be-good",
    lazy = true,
    cmd = { "VimBeGood" },
    config = function()
      -- require("ibl").setup()
    end,
  },
  -- markdown preview
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },

  -- Plugin to search and use chatgpt to answer questions
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
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    lazy = false,
    opts = {
      save_path = "~/Documents/codesnap",
      has_breadcrumbs = true,
      bg_theme = "peach",
      watermark = "",
      mac_window_bar = false,
      code_font_family = "SFMono Nerd Font",
      has_line_number = true,
      show_workspace = true,
      bg_x_padding = 72,
      bg_y_padding = 52,
    },
  },
  -- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup()
    end
  },
  {
    "Rics-Dev/project-explorer.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      paths = { "~/Desktop/work", "~/Desktop/web-dev" }, -- custom path set by user
      newProjectPath = "~/Desktop/",                     --custom path for new projects
      file_explorer = function(dir)                      --custom file explorer set by user
        vim.cmd("Neotree close")
        vim.cmd("Neotree " .. dir)
      end,
      -- Or for oil.nvim:
      -- file_explorer = function(dir)
      --   require("oil").open(dir)
      -- end,
    },
    config = function(_, opts)
      require("project_explorer").setup(opts)
    end,
    keys = {
      { "<leader>fp", "<cmd>ProjectExplorer<cr>", desc = "Project Explorer" },
    },
    lazy = false,
  },
  {
    "kevinhwang91/nvim-bqf",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function(_, opts)
      require("bqf").setup(opts)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
}
