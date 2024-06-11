-- return {
--   "nvim-lualine/lualine.nvim",
--   dependencies = {
--     "meuter/lualine-so-fancy.nvim",
--   },
--   enabled = true,
--   lazy = false,
--   event = { "BufReadPost", "BufNewFile", "VeryLazy" },
--   config = function()
--     -- local icons = require("config.icons")
--     require("lualine").setup({
--       options = {
--         theme = "auto",
--         -- theme = "catppuccin",
--         globalstatus = true,
--         icons_enabled = true,
--         -- component_separators = { left = "│", right = "│" },
--         component_separators = { left = "|", right = "|" },
--         section_separators = { left = "", right = "" },
--         disabled_filetypes = {
--           statusline = {
--             "alfa-nvim",
--             "help",
--             "neo-tree",
--             "Trouble",
--             "spectre_panel",
--             "toggleterm",
--           },
--           winbar = {},
--         },
--       },
--       sections = {
--         lualine_a = {},
--         lualine_b = {
--           "fancy_branch",
--         },
--         lualine_c = {
--           {
--             "filename",
--             path = 1, -- 2 for full path
--             symbols = {
--               modified = "  ",
--               -- readonly = "  ",
--               -- unnamed = "  ",
--             },
--           },
--           { "fancy_diagnostics", sources = { "nvim_lsp" }, symbols = { error = " ", warn = " ", info = " " } },
--           { "fancy_searchcount" },
--         },
--         lualine_x = {
--           "fancy_lsp_servers",
--           "fancy_diff",
--           "progress",
--         },
--         lualine_y = {},
--         lualine_z = {},
--       },
--       inactive_sections = {
--         lualine_a = {},
--         lualine_b = {},
--         lualine_c = { "filename" },
--         -- lualine_x = { "location" },
--         lualine_y = {},
--         lualine_z = {},
--       },
--       tabline = {},
--       extensions = { "neo-tree", "lazy" },
--     })
--   end,
-- }

return {
  {
    "nvim-lualine/lualine.nvim",
    config = function()
      local harpoon = require "harpoon.mark"

      local function truncate_branch_name(branch)
        if not branch or branch == "" then
          return ""
        end

        -- Match the branch name to the specified format
        local _, _, ticket_number = string.find(branch, "skdillon/sko%-(%d+)%-")

        -- If the branch name matches the format, display sko-{ticket_number}, otherwise display the full branch name
        if ticket_number then
          return "sko-" .. ticket_number
        else
          return branch
        end
      end

      local function harpoon_component()
        local total_marks = harpoon.get_length()

        if total_marks == 0 then
          return ""
        end

        local current_mark = "—"

        local mark_idx = harpoon.get_current_index()
        if mark_idx ~= nil then
          current_mark = tostring(mark_idx)
        end

        return string.format("󱡅 %s/%d", current_mark, total_marks)
      end

      require("lualine").setup {
        options = {
          theme = "auto",
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "█", right = "█" },
        },
        sections = {
          lualine_b = {
            { "branch", icon = "", fmt = truncate_branch_name },
            harpoon_component,
            "diff",
            "diagnostics",
          },
          lualine_c = {
            { "filename", path = 1 },
          },
          lualine_x = {
            "filetype",
          },
        },
      }
    end,
  },
}
