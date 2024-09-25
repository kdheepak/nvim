return {
  "zbirenbaum/copilot.lua",
  config = function(opts)
    vim.g.copilot_proxy_strict_ssl = false
    require("copilot").setup(opts)
  end,
}
