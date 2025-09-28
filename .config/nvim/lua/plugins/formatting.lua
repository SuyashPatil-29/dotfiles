-- Code formatting with conform.nvim (replaces none-ls for better performance)
return {
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>gf",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
      {
        "<leader>cf",
        function()
          require("conform").format({ async = true })
        end,
        desc = "Format buffer (async)",
      },
      {
        "<leader>ci",
        "<cmd>ConformInfo<cr>",
        desc = "Conform Info",
      },
    },
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_format = "fallback",
      },
      formatters_by_ft = {
        lua = { "stylua" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        graphql = { "prettier" },
        handlebars = { "prettier" },
        go = { "goimports", "gofumpt" },
        python = { "black" },
        cpp = { "clang_format" },
        c = { "clang_format" },
        cs = { "csharpier" },
      },
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 3000,
      },
      format_after_save = {
        lsp_format = "fallback",
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2" },
        },
        prettier = {
          prepend_args = { "--single-quote", "--jsx-single-quote" },
        },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      
      -- Setup format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function(args)
          require("conform").format({ bufnr = args.buf })
        end,
      })
    end,
  },
}
