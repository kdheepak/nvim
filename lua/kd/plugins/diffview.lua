return {
  "sindrets/diffview.nvim",
  config = function()
    require("diffview").setup({
      view = {
        -- Use 4-way diff (ours, base, theirs; local) for fixing conflicts
        merge_tool = {
          layout = "diff4_mixed",
          disable_diagnostics = true,
        },
      },
    })
  end,
}
