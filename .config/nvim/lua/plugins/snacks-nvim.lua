return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = {
      enabled = true,
      -- Reduce diagnostics overhead to prevent buffer errors
      diagnostics = {
        enabled = false, -- Disable if causing issues, can be re-enabled later
      },
    },
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

    -- Auto-open explorer disabled due to buffer race condition
    -- Use <leader>e or <leader><tab> to manually open the explorer
    -- Uncomment below if you want auto-open (may cause buffer errors):
    --
    -- vim.api.nvim_create_autocmd("VimEnter", {
    --   desc = "Open Snacks explorer on startup",
    --   group = vim.api.nvim_create_augroup("snacks_auto_open", { clear = true }),
    --   callback = function()
    --     if vim.fn.argc() == 0 and not vim.o.insertmode then
    --       vim.defer_fn(function()
    --         if vim.api.nvim_buf_is_valid(0) then
    --           Snacks.explorer()
    --         end
    --       end, 200)
    --     end
    --   end,
    -- })
  end,
}
