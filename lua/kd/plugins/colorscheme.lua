return {
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  -- },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   config = function()
  --     require("rose-pine").setup({
  --       styles = {
  --         bold = true,
  --         italic = false,
  --         transparency = true,
  --       },
  --       highlight_groups = {
  --         Comment = { italic = true },
  --         ["@markup.italic"] = { italic = true },
  --       },
  --     })
  --     -- load the colorscheme here
  --     vim.cmd.colorscheme("rose-pine")
  --   end,
  -- },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("github-theme").setup({
        -- ...
      })

      vim.cmd("colorscheme github_light_colorblind")
    end,
  },
}
