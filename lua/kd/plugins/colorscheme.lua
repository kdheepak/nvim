return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        dim_inactive = {
          enabled = true, -- dims the background color of inactive window
        },
      })
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  -- {
  --   "rose-pine/neovim",
  --   name = "rose-pine",
  --   config = function()
  --     require("rose-pine").setup({
  --       styles = {
  --         bold = true,
  --         italic = false,
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
  -- {
  --   "projekt0n/github-nvim-theme",
  --   name = "github-theme",
  --   config = function()
  --     require("github-theme").setup({
  --       -- ...
  --     })
  --
  --     vim.cmd("colorscheme github_light_colorblind")
  --   end,
  -- },
}
