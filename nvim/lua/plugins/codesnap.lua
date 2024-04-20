return{
  "mistricky/codesnap.nvim",
    event = "VeryLazy",
  build = "make",
  cmd = "CodeSnapPreviewOn",
  config = function()
    require("codesnap").setup()
  end
}
