return {
  -- Autocompletion
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    -- Adds LSP completion capabilities
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-calc",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    -- Adds a number of user-friendly snippets
    "rafamadriz/friendly-snippets",
    -- Adds vscode-like pictograms
    "onsails/lspkind.nvim",
    "js-everts/cmp-tailwind-colors",
  },
  config = function()
    local cmp = require "cmp"

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline {
        ["<Tab>"] = {
          c = function()
            if cmp.visible() then
              cmp.close()
            end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-z>", true, true, true), "n", true)
          end,
        },
        ["<S-Tab>"] = {
          c = function()
            if cmp.visible() then
              cmp.close()
            end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n", true)
          end,
        },
        ["<Down>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
        },
        ["<Up>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              cmp.complete()
              cmp.select_prev_item()
            end
          end,
        },
      },
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline {
        ["<S-Tab>"] = {
          c = function()
            if cmp.visible() then
              cmp.close()
            end
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-p>", true, true, true), "n", true)
          end,
        },
        ["<Down>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_next_item()
            else
              cmp.complete()
            end
          end,
        },
        ["<Up>"] = {
          c = function()
            if cmp.visible() then
              cmp.select_prev_item()
            else
              cmp.complete()
              cmp.select_prev_item()
            end
          end,
        },
      },
      sources = {
        { name = "buffer" },
      },
    })

    local luasnip = require "luasnip"
    local kind_icons = {
      Text = "",
      Method = "󰆧",
      Function = "󰊕",
      Constructor = "",
      Field = "󰇽",
      Variable = "󰂡",
      Class = "󰠱",
      Interface = "",
      Module = "",
      Property = "󰜢",
      Unit = "",
      Value = "󰎠",
      Enum = "",
      Keyword = "󰌋",
      Snippet = "",
      Color = "󰏘",
      File = "󰈙",
      Reference = "",
      Folder = "󰉋",
      EnumMember = "",
      Constant = "󰏿",
      Struct = "",
      Supermaven = " ",
      Event = "",
      Operator = "󰆕",
      TypeParameter = "󰅲",
    }
    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup {}
    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      mapping = cmp.mapping.preset.insert {
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete {},
        ["<C-y>"] = cmp.mapping.confirm { select = true },
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ["<A-j>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<A-k>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      sources = {
        { name = "tailwindcss-colorizer-cmp" }, -- Add this line to prioritize tailwindcss-colorizer-cmp
        { name = "supermaven" },
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "calc" },
        { name = "emoji" },
        { name = "treesitter" },
        { name = "crates" },
        { name = "tmux" },
      },
      formatting = {
        expandable_indicator = true,
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
          item.menu = item.kind
          item = require("cmp-tailwind-colors").format(entry, item)
          if kind_icons[item.kind] then
            item.kind = kind_icons[item.kind] .. "  "
          end
          item.abbr = item.abbr .. "  " -- Add two spaces after the abbreviation
          item.menu = "  " .. item.menu -- Add two spaces before the menu
          return item
        end,
      },
    }
  end,
}
