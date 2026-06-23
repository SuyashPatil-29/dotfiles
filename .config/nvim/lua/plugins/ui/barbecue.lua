-- breadcrumbs for neovim
return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  event = "LspAttach",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    attach_navic = false, -- Prevent barbecue from auto-attaching navic (causes conflicts)
    create_autocmd = false,
  },
  config = function(_, opts)
    require("barbecue").setup(opts)

    -- Setup navic manually to handle multiple LSP servers gracefully
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("navic_attach", { clear = true }),
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.server_capabilities.documentSymbolProvider then
          -- Silently try to attach, ignore if already attached
          pcall(function()
            require("nvim-navic").attach(client, args.buf)
          end)
        end
      end,
    })

    vim.api.nvim_create_autocmd({
      "WinScrolled",
      "BufWinEnter",
      "CursorHold",
      "InsertLeave",
    }, {
      group = vim.api.nvim_create_augroup("barbecue.updater", { clear = true }),
      callback = function()
        require("barbecue.ui").update()
      end,
    })
  end,
}
