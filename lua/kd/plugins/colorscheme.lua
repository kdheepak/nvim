return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    dependencies = {
      {
        "echasnovski/mini.indentscope",
        version = "*", -- wait till new 0.7.0 release to put it back on semver
        event = "BufReadPre",
        opts = {
          symbol = "▏",
          -- symbol = "│",
          options = { try_as_border = true },
        },
        config = function(_, opts)
          vim.api.nvim_create_autocmd("FileType", {
            pattern = {
              "help",
              "alpha",
              "dashboard",
              "neo-tree",
              "Trouble",
              "lazy",
              "mason",
            },
            callback = function()
              vim.b.miniindentscope_disable = true
            end,
          })
          require("mini.indentscope").setup(opts)
        end,
      },
    },
    config = function()
      vim.opt.list = true
      vim.opt.listchars:append("space:⋅")
      local catppuccin = require("catppuccin")
      catppuccin.setup({})
      vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
      vim.cmd("colorscheme catppuccin")
    end,
  },
  -- {
  --   "projekt0n/github-nvim-theme",
  --   lazy = false, -- make sure we load this during startup if it is your main colorscheme
  --   priority = 1000, -- make sure to load this before all the other start plugins
  --   config = function()
  --     -- require("github-theme").setup({})
  --     -- vim.cmd("colorscheme github_light_colorblind")
  --   end,
  -- },
}
