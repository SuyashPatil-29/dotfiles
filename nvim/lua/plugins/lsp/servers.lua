return {
  jsonls = {
    settings = {
      json = {
        schema = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
  lua_ls = {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        workspace = {
          checkThirdParty = false,
          -- Tells lua_ls where to find all the Lua files that you have loaded
          -- for your neovim configuration.
          library = {
            "${3rd}/luv/library",
            unpack(vim.api.nvim_get_runtime_file("", true)),
          },
          -- If lua_ls is really slow on your computer, you can try this instead:
          -- library = { vim.env.VIMRUNTIME },
        },
        completion = {
          callSnippet = "Replace",
        },
        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
        -- diagnostics = { disable = { 'missing-fields' } },
      },
    },
  },
  clangd = {
    filetypes = { "c", "cpp" },
    cmd = { "clangd" },
    init_options = {
      clangdFileStatus = true,
      usePlaceholderReferences = true,
      completeUnimported = true,
      semanticHighlighting = true,
    },
  },
  bashls = {
    filetypes = { "sh", "zsh" },
  },
  vimls = {
    filetypes = { "vim" },
  },
  tsserver = {},
  yamlls = {
    cmd = { "yaml-language-server", "--stdio" },
    filetypes = { "yaml" },
  },
}
