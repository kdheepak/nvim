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
  -- Or with configuration
  {
    "projekt0n/github-nvim-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    -- config = function()
    --   require("github-theme").setup({
    --     -- ...
    --   })
    --
    --   vim.cmd("colorscheme github_light_colorblind")
    -- end,
  },
}
