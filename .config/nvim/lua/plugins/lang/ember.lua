-- Ember / Glimmer: filetype detection + treesitter.
-- LSP (ember-language-server + glint) is configured in lsp/lsp-config.lua and
-- only activates inside Ember projects.
return {
  -- Treesitter parsers for templates (.hbs) and embedded glimmer.
  -- `init` always runs at startup (even though treesitter loads lazily), so it
  -- is a good place to register the .gjs/.gts filetypes.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "glimmer", "javascript", "typescript" } },
    init = function()
      vim.filetype.add({
        extension = {
          gjs = "javascript.glimmer",
          gts = "typescript.glimmer",
        },
      })

      -- Highlight .hbs / glimmer files with the glimmer parser, and fall back to
      -- the base JS/TS parser for the script side of .gjs/.gts.
      pcall(function()
        vim.treesitter.language.register("glimmer", { "handlebars", "html.handlebars" })
        vim.treesitter.language.register("javascript", "javascript.glimmer")
        vim.treesitter.language.register("typescript", "typescript.glimmer")
      end)
    end,
  },
}
