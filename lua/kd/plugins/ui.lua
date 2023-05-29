return {
  {
    "nvim-tree/nvim-web-devicons",
    enabled = vim.g.icons_enabled,
    opts = {
      override = {
        deb = { icon = "", name = "Deb" },
        lock = { icon = "󰌾", name = "Lock" },
        mp3 = { icon = "󰎆", name = "Mp3" },
        mp4 = { icon = "", name = "Mp4" },
        out = { icon = "", name = "Out" },
        ["robots.txt"] = { icon = "󰚩", name = "Robots" },
        ttf = { icon = "", name = "TrueTypeFont" },
        rpm = { icon = "", name = "Rpm" },
        woff = { icon = "", name = "WebOpenFontFormat" },
        woff2 = { icon = "", name = "WebOpenFontFormat2" },
        xz = { icon = "", name = "Xz" },
        zip = { icon = "", name = "Zip" },
      },
    },
  },
  {
    "onsails/lspkind.nvim",
    opts = {
      mode = "symbol",
      symbol_map = require("kd/utils").icons.kinds,
    },
    enabled = vim.g.icons_enabled,
    config = function()
      require("lspkind").init(opts)
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = { on_open = function(win) vim.api.nvim_win_set_config(win, { zindex = 1000 }) end },
    config = function(_, opts)
      local notify = require "notify"
      notify.setup(opts)
      vim.notify = notify
    end
  },
  {
    "stevearc/dressing.nvim",
    opts = {
      input = {
        default_prompt = "➤ ",
        win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" },
      },
      select = {
        backend = { "telescope", "builtin" },
        builtin = { win_options = { winhighlight = "Normal:Normal,NormalNC:Normal" } },
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
          filetypes = {
              "lua", "css",
          },

          user_default_options = {
              RRGGBB = true, -- #RRGGBB hex codes
              RRGGBBAA = true, -- #RRGGBBAA hex codes
              AARRGGBB = false, -- 0xAARRGGBB hex codes
              RGB = false, -- #RGB hex codes
              names = false, -- `Name` codes like Blue or blue
              rgb_fn = false, -- CSS rgb() and rgba() functions
              hsl_fn = false, -- CSS hsl() and hsla() functions
              css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
              css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
              -- Available modes for `mode`: foreground, background,  virtualtext
              mode = "virtualtext", -- Set the display mode.
              -- Available methods are false / true / "normal" / "lsp" / "both"
              -- True is same as normal
              tailwind = false, -- Enable tailwind colors
              -- parsers can contain values used in |user_default_options|
              sass = { enable = false, parsers = { css }, }, -- Enable sass colors
              virtualtext = "■",
          },

          -- all the sub-options of filetypes apply to buftypes
          buftypes = {},
      })
    end
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      buftype_exclude = {
        "nofile",
        "terminal",
      },
      filetype_exclude = {
        "help",
        "startify",
        "aerial",
        "alpha",
        "dashboard",
        "lazy",
        "neogitstatus",
        "NvimTree",
        "neo-tree",
        "Trouble",
      },
      context_patterns = {
        "class",
        "return",
        "function",
        "method",
        "^if",
        "^while",
        "jsx_element",
        "^for",
        "^object",
        "^table",
        "block",
        "arguments",
        "if_statement",
        "else_clause",
        "jsx_element",
        "jsx_self_closing_element",
        "try_statement",
        "catch_clause",
        "import_statement",
        "operation_type",
      },
      show_trailing_blankline_indent = false,
      use_treesitter = true,
      char = "▏",
      context_char = "▏",
      show_current_context = true,
    },
  },
  {
    "folke/noice.nvim",
    config = function()
      require("noice").setup({
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },
      })
    end,
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
      }
  }
}
