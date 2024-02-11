return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      -- load the colorscheme here
      vim.cmd.colorscheme("rose-pine")
    end,
  },
}
