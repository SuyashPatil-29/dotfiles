-- Small standalone editor utilities
return {
  -- Session saving using persistence.nvim
  {
    "folke/persistence.nvim",
    event = "BufReadPre", -- this will only start session saving when an actual file was opened
    opts = {},
  },

  -- vim motion practice game
  {
    "ThePrimeagen/vim-be-good",
    lazy = true,
    cmd = { "VimBeGood" },
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

  -- screenshots of code
  {
    "mistricky/codesnap.nvim",
    build = "make build_generator",
    cmd = { "CodeSnap", "CodeSnapSave", "CodeSnapHighlight", "CodeSnapSaveHighlight", "CodeSnapASCII" },
    keys = {
      { "<leader>cs", "<cmd>CodeSnap<cr>", mode = "v", desc = "Screenshot selection" },
    },
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
}
