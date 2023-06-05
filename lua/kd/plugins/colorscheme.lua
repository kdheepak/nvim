return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    dependencies = {
      {
        "Yggdroot/indentLine",
        config = function()
          vim.cmd("let g:indentLine_char_list = ['│']")
        end,
      },
      {
        "echasnovski/mini.indentscope",
        version = "*", -- wait till new 0.7.0 release to put it back on semver
        event = "BufReadPre",
        opts = {
          -- symbol = "▏",
          symbol = "│",
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
      -- {
      --   "lukas-reineke/indent-blankline.nvim",
      --   opts = {
      --     buftype_exclude = {
      --       "nofile",
      --       "terminal",
      --     },
      --     filetype_exclude = {
      --       "help",
      --       "startify",
      --       "aerial",
      --       "alpha",
      --       "dashboard",
      --       "lazy",
      --       "neogitstatus",
      --       "NvimTree",
      --       "neo-tree",
      --       "Trouble",
      --     },
      --     context_patterns = {
      --       "class",
      --       "return",
      --       "function",
      --       "method",
      --       "^if",
      --       "^while",
      --       "jsx_element",
      --       "^for",
      --       "^object",
      --       "^table",
      --       "block",
      --       "arguments",
      --       "if_statement",
      --       "else_clause",
      --       "jsx_element",
      --       "jsx_self_closing_element",
      --       "try_statement",
      --       "catch_clause",
      --       "import_statement",
      --       "operation_type",
      --     },
      --     show_trailing_blankline_indent = false,
      --     use_treesitter = false,
      --     char = "▏",
      --     context_char = "▏",
      --     show_current_context = false,
      --     space_char_blankline = " ",
      --   },
      -- },
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
