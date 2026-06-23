-- Bufferline to show tabs like vs code
return {
  "akinsho/nvim-bufferline.lua",
  version = "*",
  event = "VeryLazy",
  dependencies = "nvim-tree/nvim-web-devicons",
  config = function()
    require("bufferline").setup {
      options = {
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            text_align = "center",
          },
          {
            filetype = "snacks_explorer",
            text = "File Explorer",
            text_align = "center",
          },
        },
        numbers = "ordinal",
        -- separator_style = "slant",
        show_buffer_close_icons = true,
        show_close_icon = true,
        max_name_length = 18,
        max_prefix_length = 15,   -- prefix used when a buffer is de-duplicated
        tab_size = 15,
        diagnostics = "nvim_lsp", -- Display diagnostics in the bufferline
        left_trunc_marker = "",
        right_trunc_marker = "",
        show_tab_indicators = true,
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diagnostics_dict, _)
          local s = " "
          for e, n in pairs(diagnostics_dict) do
            local sym = e == "error" and "   " or (e == "warning" and "   " or "   ")
            s = s .. n .. sym
          end
          return s
        end,
        color_icons = true,
      },
    }
  end,
}
