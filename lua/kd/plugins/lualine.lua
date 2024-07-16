return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    { "nvim-tree/nvim-web-devicons" },
  },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "rose-pine",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {
        lualine_a = { { "buffers", show_filename_only = false } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = { "tabs" },
      },
      extensions = {},
    })
  end,
}
