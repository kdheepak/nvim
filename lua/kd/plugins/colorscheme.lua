return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end,
  },
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
    config = function()
      -- require("github-theme").setup({
      --   -- ...
      -- })
      --
      -- vim.cmd("colorscheme github_light_tritanopia")
    end,
  },
}
