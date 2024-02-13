return {
  {
    "nvim-tree/nvim-web-devicons",
    enabled = vim.g.icons_enabled,
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      override = require("kd.utils").icons.web_dev_icons,
    },
  },
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      symbol_map = require("kd.utils").icons.kinds,
    },
    enabled = vim.g.icons_enabled,
    config = function(_, opts)
      require("lspkind").init(opts)
    end,
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
      },
      select = {
        builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = false, -- "Name" codes like Blue or blue
          RRGGBBAA = false, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = true, -- CSS rgb() and rgba() functions
          hsl_fn = true, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "virtualtext", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = true, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { "css" } }, -- Enable sass colors
          virtualtext = "■■■■■",
          -- update color values even if buffer is not focused
          -- example use: cmp_menu, cmp_docs
          always_update = false,
        },
      })
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    opts = {
      icons = {
        kinds = {
          symbols = require("kd.utils").icons.kinds,
        },
      },
    },
  },
}
