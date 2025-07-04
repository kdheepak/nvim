return {
  "mistricky/codesnap.nvim",
  build = "make",
  cond = function()
    return jit.os ~= "Windows"
  end,
  config = function()
    require("codesnap").setup({
      watermark = "",
      title = "",
      save_path = os.getenv("HOME") .. "/Desktop",
    })
  end,
}
