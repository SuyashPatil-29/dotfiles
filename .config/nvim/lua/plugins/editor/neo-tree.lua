-- File explorer (replaces the snacks.nvim explorer)
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cmd = "Neotree",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    {
      "<leader>e",
      "<cmd>Neotree toggle filesystem left<cr>",
      desc = "File Explorer (sidebar)",
    },
    {
      "<leader><tab>",
      "<cmd>Neotree toggle filesystem float<cr>",
      desc = "File Explorer (float)",
    },
    {
      "<leader>be",
      "<cmd>Neotree toggle buffers left<cr>",
      desc = "Buffer Explorer",
    },
    {
      "<leader>ge",
      "<cmd>Neotree toggle git_status float<cr>",
      desc = "Git Explorer",
    },
  },
  deactivate = function()
    vim.cmd([[Neotree close]])
  end,
  init = function()
    -- Open neo-tree when nvim is launched on a directory
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("neotree_start_directory", { clear = true }),
      desc = "Start Neo-tree with a directory",
      once = true,
      callback = function()
        if package.loaded["neo-tree"] then
          return
        end
        local stats = vim.uv.fs_stat(vim.fn.argv(0))
        if stats and stats.type == "directory" then
          require("neo-tree")
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    sources = { "filesystem", "buffers", "git_status" },
    open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
    source_selector = {
      winbar = true,
      statusline = false,
    },
    default_component_configs = {
      indent = {
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
      },
    },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_default",
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { ".DS_Store", "thumbs.db" },
      },
    },
    git_status = {
      window = {
        position = "float",
      },
    },
    window = {
      -- Default to a centered float (used on startup when nvim opens a directory
      -- and by <leader><tab>). <leader>e overrides this with an explicit sidebar.
      position = "float",
      width = 34,
      -- Appearance when opened as a float
      popup = {
        size = { height = "80%", width = "60%" },
        position = "50%",
      },
      mappings = {
        ["<space>"] = "none", -- keep <space> as leader
        ["l"] = "open",
        ["h"] = "close_node",
        ["H"] = "toggle_hidden",
        ["P"] = { "toggle_preview", config = { use_float = true } },
        ["Y"] = "copy_to_clipboard",
        ["O"] = "open_with_window_picker",
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    -- Refresh git status in the tree when lazygit / fugitive writes finish
    vim.api.nvim_create_autocmd("TermClose", {
      pattern = "*lazygit",
      callback = function()
        if package.loaded["neo-tree.sources.git_status"] then
          require("neo-tree.sources.git_status").refresh()
        end
      end,
    })
  end,
}
