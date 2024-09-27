return {
  "mistricky/codesnap.nvim",
  build = "make",
  config = function()
    require("codesnap").setup({
      watermark = "",
      title = "",
      save_path = os.getenv("HOME") .. "/Desktop",
    })
  end,
}
