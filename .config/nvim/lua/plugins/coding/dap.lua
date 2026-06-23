-- Debug Adapter Protocol
return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "williamboman/mason.nvim" },
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
    },
  },
}
