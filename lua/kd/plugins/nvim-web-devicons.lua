return {
  "nvim-tree/nvim-web-devicons",
  enabled = vim.g.icons_enabled,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    override = require("kd.utils").icons.web_dev_icons,
  },
}
