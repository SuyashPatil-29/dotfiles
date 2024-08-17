-- Lazy
return {
  "jackMort/ChatGPT.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "nvim-lua/plenary.nvim",
    "folke/trouble.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    require("chatgpt").setup {
      api_key = vim.env.OPENAI_API_KEY,
    }
    vim.keymap.set("n", "<leader>cg", "<cmd>ChatGPT<cr>", { desc = "ChatGPT" })
    vim.keymap.set(
      "n",
      "<leader>cf",
      "<cmd>ChatGPTRun fix_bugs<cr>",
      { desc = "ChatGPT fixes bugs in previously selected code", noremap = true, silent = true }
    )
    vim.keymap.set(
      "n",
      "<leader>ce",
      "<cmd>ChatGPTRun explain_code<cr>",
      { desc = "ChatGPT explains previously selected code", noremap = true, silent = true }
    )
    vim.keymap.set(
      "n",
      "<leader>ca",
      "<cmd>ChatGPTEditWithInstructions<cr>",
      { desc = "ChatGPT edits previously selected code with instructions", noremap = true, silent = true }
    )
  end,
}
