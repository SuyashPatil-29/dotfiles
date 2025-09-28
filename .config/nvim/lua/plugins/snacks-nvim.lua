return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false }, -- Disable dashboard since you want file explorer
    explorer = { enabled = true },
    indent = { enabled = false },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = {
      enabled = true,
      sources = {
        files = { hidden = true },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  keys = {
    -- File Explorer
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    {
      "<leader><tab>",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
    -- File pickers
    {
      "<C-p>",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.grep()
      end,
      desc = "Live Grep",
    },
    {
      "<leader>o",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Open Buffer",
    },
  },
  
  config = function(_, opts)
    require("snacks").setup(opts)
    
    -- Auto-open explorer on startup (like you wanted with Neo-tree)
    vim.api.nvim_create_autocmd("VimEnter", {
      desc = "Open Snacks explorer on startup",
      group = vim.api.nvim_create_augroup("snacks_auto_open", { clear = true }),
      callback = function()
        -- Only open if no file was opened and no stdin
        if vim.fn.argc() == 0 and not vim.o.insertmode then
          vim.schedule(function()
            Snacks.explorer()
          end)
        end
      end,
    })
  end,
}
