return {
  "onsails/lspkind.nvim",
  opts = {
    mode = "symbol",
    symbol_map = require("kd.utils").icons.kinds,
  },
  enabled = vim.g.icons_enabled,
  config = function(_, opts)
    require("lspkind").init(opts)
  end,
}
